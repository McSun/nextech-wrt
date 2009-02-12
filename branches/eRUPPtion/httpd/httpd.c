/*

	micro_httpd/mini_httpd

	Copyright � 1999,2000 by Jef Poskanzer <jef@acme.com>.
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions
	are met:
	1. Redistributions of source code must retain the above copyright
	   notice, this list of conditions and the following disclaimer.
	2. Redistributions in binary form must reproduce the above copyright
	   notice, this list of conditions and the following disclaimer in the
	   documentation and/or other materials provided with the distribution.

	THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
	OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
	OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
	SUCH DAMAGE.

*/
/*

	Copyright 2003, CyberTAN  Inc.  All Rights Reserved

	This is UNPUBLISHED PROPRIETARY SOURCE CODE of CyberTAN Inc.
	the contents of this file may not be disclosed to third parties,
	copied or duplicated in any form without the prior written
	permission of CyberTAN Inc.

	This software should be used as a reference only, and it not
	intended for production use!

	THIS SOFTWARE IS OFFERED "AS IS", AND CYBERTAN GRANTS NO WARRANTIES OF ANY
	KIND, EXPRESS OR IMPLIED, BY STATUTE, COMMUNICATION OR OTHERWISE.  CYBERTAN
	SPECIFICALLY DISCLAIMS ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
	FOR A SPECIFIC PURPOSE OR NONINFRINGEMENT CONCERNING THIS SOFTWARE

*/
/*

	Modified for Tomato Firmware
	Portions, Copyright (C) 2006-2008 Jonathan Zarate
	
*/	

#include "tomato.h"
#include <errno.h>
#include <fcntl.h>
#include <time.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <getopt.h>
#include <stdarg.h>
#include <sys/wait.h>
#include <error.h>
#include <sys/signal.h>
#include <netinet/tcp.h>
#include <sys/stat.h>

#include <wlutils.h>


#include "../mssl/mssl.h"
int do_ssl;

int post;
int listenfd;
int connfd = -1;
FILE *connfp = NULL;
struct sockaddr_in clientsai;
int header_sent;
char *user_agent;
//	int hidok = 0;

const char mime_html[] = "text/html; charset=utf-8";
const char mime_plain[] = "text/plain";
const char mime_javascript[] = "text/javascript";
const char mime_binary[] = "application/tomato-binary-file";	// instead of "application/octet-stream" to make browser just "save as" and prevent automatic detection weirdness	-- zzz
const char mime_octetstream[] = "application/octet-stream";

static int match(const char* pattern, const char* string);
static int match_one(const char* pattern, int patternlen, const char* string);
static void handle_request(void);


static void reap(int sig)
{
    int status;
	while (waitpid(-1, &status, WNOHANG) > 0) {
		//
	}
}


// --------------------------------------------------------------------------------------------------------------------


static const char *http_status_desc(int status)
{
	switch (status) {
	case 200:
		return "OK";
	case 302:
		return "Found";
	case 400:
		return "Invalid Request";
	case 401:
		return "Unauthorized";
	case 404:
		return "Not Found";
	case 501:
		return "Not Implemented";
	}
	return "Unknown";
}

void send_header(int status, const char* header, const char* mime, int cache)
{
	time_t now;
	char tms[128];

	now = time(NULL);
	if (now < Y2K) now += Y2K;	// test		--- zzz
	strftime(tms, sizeof(tms), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&now));	// RFC 1123
	web_printf("HTTP/1.0 %d %s\r\n"
			   "Date: %s\r\n",
			   status, http_status_desc(status),
			   tms);
	
	if (mime) web_printf("Content-Type: %s\r\n", mime);
	if (cache > 0) {
		web_printf("Cache-Control: max-age=%d\r\n", cache * 60);
	}
	else {
		web_puts("Cache-Control: no-cache, no-store, must-revalidate, private\r\n"
				 "Expires: Thu, 31 Dec 1970 00:00:00 GMT\r\n"
				 "Pragma: no-cache\r\n");
	}
	if (header) web_printf("%s\r\n", header);
	web_puts("Connection: close\r\n\r\n");
	
	header_sent = 1;
}

void send_error(int status, const char *header, const char *text)
{
	const char *s = http_status_desc(status);
	send_header(status, header, mime_html, 0);
	web_printf(
		"<html>"
		"<head><title>Error</title></head>"
		"<body>"
		"<h2>%d %s</h2> %s"
		"</body></html>",
		status, s, text ? text : s);
}

void redirect(const char *path)
{
	char s[512];
	
	snprintf(s, sizeof(s), "Location: %s", path);
	send_header(302, s, mime_html, 0);
	web_puts(s);
	
	_dprintf("Redirect: %s\n", path);
}

int skip_header(int *len)
{
	char buf[2048];

	while (*len > 0) {
		if (!web_getline(buf, MIN(*len, sizeof(buf)))) {
			break;
		}
		*len -= strlen(buf);
		if ((strcmp(buf, "\n") == 0) || (strcmp(buf, "\r\n") == 0)) {
			return 1;
		}
	}
	return 0;
}

	
// -----------------------------------------------------------------------------

static void eat_garbage(void)
{
	int i;
	int flags;

	// eat garbage \r\n (IE6, ...) or browser ends up with a tcp reset error message
	if ((!do_ssl) && (post)) {
		if (((flags = fcntl(connfd, F_GETFL)) != -1) && (fcntl(connfd, F_SETFL, flags | O_NONBLOCK) != -1)) {
//					if (fgetc(connfp) != EOF) fgetc(connfp);
			for (i = 0; i < 1024; ++i) {
				if (fgetc(connfp) == EOF) break;
			}
			fcntl(connfd, F_SETFL, flags);
		}
	}
}

// -----------------------------------------------------------------------------


void send_authenticate(const char *realm)
{
	char header[128];

	if (realm == NULL) realm = nvram_get("router_name");
	if ((realm == NULL) || (*realm == 0) || (strlen(realm) > 64)) realm = "unknown";	
	
	sprintf(header, "WWW-Authenticate: Basic realm=\"%s\"", realm);

/*
	char *sn;
	char quirk[64];

	if (user_agent) {
		cprintf("user_agent=%s\n", user_agent);
	}
	
	if ((user_agent) && (strstr(user_agent, "MSIE 7") != NULL)) {
		sn = nvram_get("web_sess");
		if ((sn == NULL) || (*sn == 0) || (strlen(sn) > 16)) {
			gen_sessnum();
			sn = nvram_safe_get("web_sess");
		}
		sprintf(quirk, "[%s] ", sn);
	}
	else {
		quirk[0] = 0;
	}
	sprintf(header, "WWW-Authenticate: Basic realm=\"%s%s\"", quirk, realm);
*/

	send_error(401, header, NULL);
}

static int check_auth(char* authorization, int clen)
{
	char buf[512];
	const char *p;
	char* pass;
	int len;

	if ((authorization != NULL) && (strncasecmp(authorization, "Basic ", 6) == 0)) {
		if (base64_decoded_len(strlen(authorization + 6)) <= sizeof(buf)) {
			len = base64_decode(authorization + 6, buf, strlen(authorization) - 6);
			buf[len] = 0;
			if ((pass = strchr(buf, ':')) != NULL) {
				*pass++ = 0;
				if ((strcmp(buf, "admin") == 0) || (strcmp(buf, "root") == 0)) {
					p = nvram_get("http_passwd");
					if (strcmp(pass, ((p == NULL) || (*p == 0)) ? "admin" : p) == 0) {
						return 1;
					}
				}
			}
		}
	}

	if (post) web_eat(clen);
	eat_garbage();
	send_authenticate(NULL);
	return 0;

/*
	char buf[512];
	const char *p;
	const char *c;
	const char *wo;
	const char *wop;
	char* pass;
	int len;

	if ((authorization != NULL) && (strncasecmp(authorization, "Basic ", 6) == 0)) {
		if (base64_decoded_len(strlen(authorization + 6)) <= sizeof(buf)) {
			len = base64_decode(authorization + 6, buf, strlen(authorization) - 6);
			buf[len] = 0;
			if ((pass = strchr(buf, ':')) != NULL) {
				*pass++ = 0;
				if ((strcmp(buf, "admin") == 0) || (strcmp(buf, "root") == 0)) {
					p = nvram_get("http_passwd");
					if (strcmp(pass, ((p == NULL) || (*p == 0)) ? "admin" : p) == 0) {
						c = inet_ntoa(clientsai.sin_addr);
						wo = nvram_safe_get("web_out");
						if ((wop = find_word(wo, c)) != NULL) {
							if (!nvram_match("web_outx", (char *)c)) {
								nvram_set("web_outx", c);
								goto WRONG;
							}
							
							if (strlen(wo) > 196) {
								nvram_set("web_out", "");
							}
							else {
								len = wop - wo;
								if ((len > 0) && (wo[len - 1] == ',')) --len;
								strncpy(buf, wo, len);
								wop += strlen(c);
								while (*wop == ',') ++wop;
								strcpy(buf + len, wop);
								nvram_set("web_out", buf);
							}

							nvram_unset("web_outx");
						}
						return 1;
					}

				}
			}
		}
	}

WRONG:
	if (post) web_eat(clen);
	eat_garbage();
	send_authenticate(NULL);
	nvram_set("web_outx", inet_ntoa(clientsai.sin_addr));
	return 0;
*/
}

int check_wlaccess(void)
{
	char mac[32];
	char ifname[32];
	sta_info_t sti;
	
	if (nvram_match("web_wl_filter", "1")) {
		if (get_client_info(mac, ifname)) {
			memset(&sti, 0, sizeof(sti));
			strcpy((char *)&sti, "sta_info");	// sta_info0<mac>
			ether_atoe(mac, (char *)&sti + 9);
			if (wl_ioctl(nvram_safe_get("wl_ifname"), WLC_GET_VAR, &sti, sizeof(sti)) == 0) {
				if (nvram_match("debug_logwlac", "1")) {
					syslog(LOG_WARNING, "Wireless access from %s blocked.", mac);
				}
				return 0;
			}
		}
	}
	return 1;
}

// -----------------------------------------------------------------------------

static int match_one(const char* pattern, int patternlen, const char* string)
{
	const char* p;

	for (p = pattern; p - pattern < patternlen; ++p, ++string) {
		if (*p == '?' && *string != '\0')
			continue;
		if (*p == '*') {
			int i, pl;
			++p;
			if (*p == '*') {
				/* Double-wildcard matches anything. */
				++p;
				i = strlen(string);
			} else
				/* Single-wildcard matches anything but slash. */
				i = strcspn(string, "/");
			pl = patternlen - (p - pattern);
			for (; i >= 0; --i)
				if (match_one(p, pl, &(string[i])))
					return 1;
			return 0;
		}
		if (*p != *string)
			return 0;
	}
	if (*string == '\0')
		return 1;
	return 0;
}

//	Simple shell-style filename matcher.  Only does ? * and **, and multiple
//	patterns separated by |.  Returns 1 or 0.
static int match(const char* pattern, const char* string)
{
	const char* p;

	for (;;) {
		p = strchr(pattern, '|');
		if (p == NULL) return match_one(pattern, strlen(pattern), string);
		if (match_one(pattern, p - pattern, string)) return 1;
		pattern = p + 1;
	}
}


void do_file(char *path)
{
	FILE *f;
	char buf[1024];
	int nr;
	if ((f = fopen(path, "r")) != NULL) {
		while ((nr = fread(buf, 1, sizeof(buf), f)) > 0)
			web_write(buf, nr);
		fclose(f);
	}
}

static void handle_request(void)
{
	char line[10000], *cur;
	char *method, *path, *protocol, *authorization, *boundary;
	char *cp;
	char *file;
	const struct mime_handler *handler;
	int cl = 0;

	user_agent = NULL;
	header_sent = 0;
	authorization = boundary = NULL;
	bzero(line, sizeof(line));

	// Parse the first line of the request.
	if (!web_getline(line, sizeof(line))) {
		send_error(400, NULL, NULL);
		return;
	}

	_dprintf("%s\n", line);

	method = path = line;
	strsep(&path, " ");
	if (!path) {	// Avoid http server crash, added by honor 2003-12-08
		send_error(400, NULL, NULL);
		return;
	}
	while (*path == ' ') path++;
	
	if ((strcasecmp(method, "GET") != 0) && (strcasecmp(method, "POST") != 0)) {
		send_error(501, NULL, NULL);
		return;
	}
	
	protocol = path;
	strsep(&protocol, " ");
	if (!protocol) {	// Avoid http server crash, added by honor 2003-12-08
		send_error(400, NULL, NULL);
		return;
	}
	while (*protocol == ' ') protocol++;

	if (path[0] != '/') {
		send_error(400, NULL, NULL);
		return;
	}
	file = path + 1;

#if 0
	const char *hid;
	int n;

	hid = nvram_safe_get("http_id");
	n = strlen(hid);
	cprintf("file=%s hid=%s n=%d +n=%s\n", file, hid, n, path + n + 1);
	if ((strncmp(file, hid, n) == 0) && (path[n + 1] == '/')) {
		path += n + 1;
		file = path + 1;
		hidok = 1;

		cprintf("OK path=%s file=%s\n", path, file);
	}
#endif

	if ((cp = strchr(file, '?')) != NULL) {
		*cp = 0;
		webcgi_init(cp + 1);
	}	
	
	if ((file[0] == '/') || (strncmp(file, "..", 2) == 0) || (strstr(file, "/../") != NULL) || 
		(strcmp(file + (strlen(file) - 3), "/..") == 0)) {
		send_error(400, NULL, NULL);
		return;
	}

	if ((file[0] == 0) || (strcmp(file, "index.asp") == 0)) {
//		file = "status-overview.asp";
		file = "index.asp";		
	}
	else if ((strcmp(file, "ext/") == 0) || (strcmp(file, "ext") == 0)) {
		file = "ext/index.asp";
	}
	
	cp = protocol;
	strsep(&cp, " ");
	cur = protocol + strlen(protocol) + 1;
	
	while (web_getline(cur, line + sizeof(line) - cur)) {
		if ((strcmp(cur, "\n") == 0) || (strcmp(cur, "\r\n") == 0)) {
			break;
		}

		if (strncasecmp(cur, "Authorization:", 14) == 0) {
			cp = &cur[14];
			cp += strspn(cp, " \t");
			authorization = cp;
			cur = cp + strlen(cp) + 1;
		}
		else if (strncasecmp(cur, "Content-Length:", 15) == 0) {
			cp = &cur[15];
			cp += strspn(cp, " \t");
			cl = strtoul(cp, NULL, 0);
			if ((cl < 0) || (cl >= INT_MAX)) {
				send_error(400, NULL, NULL);
				return;
			}
		}
		else if ((strncasecmp(cur, "Content-Type:", 13) == 0) && ((cp = strstr(cur, "boundary=")))) {
			boundary = &cp[9];
			for (cp = cp + 9; *cp && *cp != '\r' && *cp != '\n'; cp++);
			*cp = '\0';
			cur = ++cp;
		}
		else if (strncasecmp(cur, "User-Agent:", 11) == 0) {
			user_agent = cur + 11;
			user_agent += strspn(user_agent, " \t");
			cur = user_agent + strlen(user_agent);
			*cur++ = 0;
//			cprintf("agent: [%s]\n", user_agent);
		}
	}

	post = (strcasecmp(method, "post") == 0);

	for (handler = &mime_handlers[0]; handler->pattern; handler++) {
		if (match(handler->pattern, file)) {
			if (handler->auth) {
				if (!check_auth(authorization, cl)) return;
			}
			
			if (handler->input) handler->input(file, cl, boundary);
			
			eat_garbage();
			
			if (handler->mime_type != NULL) {
				send_header(200, NULL, handler->mime_type, handler->cache);
			}

			if (handler->output) {
				handler->output(file);
			}
			
			return;
		}
	}

	if (!check_auth(authorization, cl)) return;	

#if 0
	if ((!post) && (strchr(file, '.') == NULL)) {
		cl = strlen(file);
		if ((cl > 1) && (cl < 64)) {
			char alt[128];

			path = alt + 1;
			strcpy(path, file);
			
			cp = path + cl - 1;
			if (*cp == '/') *cp = 0;

			if ((cp = strrchr(path, '/')) != NULL) *cp = '-';

			strcat(path, ".asp");
			if (f_exists(path)) {
				alt[0] = '/';
				redirect(alt);
				return;
			}
		}
	}
#endif

	send_error(404, NULL, NULL);
}

#ifdef TCONFIG_HTTPS
static void save_cert(void)
{
	if (eval("tar", "-C", "/", "-czf", "/tmp/cert.tgz", "/etc/cert.pem", "/etc/key.pem") == 0) {
		if (nvram_set_file("https_crt_file", "/tmp/cert.tgz", 2048)) {
			if (!nvram_match("debug_nocommit", "1")) nvram_commit();
		}
	}
	unlink("/tmp/cert.tgz");
}

static void erase_cert(void)
{
	unlink("/etc/cert.pem");
	unlink("/etc/key.pem");
	nvram_unset("https_crt_file");
	nvram_unset("https_crt_gen");
}

static void start_ssl(void)
{
	int ok;
	int save;
	int retry;
	unsigned long long sn;
	char t[32];
	
	if (nvram_match("https_crt_gen", "1")) {
		erase_cert();
	}

	retry = 1;
	while (1) {
		save = nvram_match("https_crt_save", "1");

		if ((!f_exists("/etc/cert.pem")) || (!f_exists("/etc/key.pem"))) {
			ok = 0;
			if (save) {
				if (nvram_get_file("https_crt_file", "/tmp/cert.tgz", 2048)) {
					if (eval("tar", "-C", "/", "-xzf", "/tmp/cert.tgz") == 0) ok = 1;
					unlink("/tmp/cert.tgz");
				}
			}
			if (!ok) {
				erase_cert();
				syslog(LOG_INFO, "Generating SSL certificate...");
				
				// browsers seems to like this when the ip address moves...	-- zzz
				f_read("/dev/urandom", &sn, sizeof(sn));

				sprintf(t, "%llu", sn & 0x7FFFFFFFFFFFFFFFUL);
				eval("gencert.sh", t);
			}
		}

		if ((save) && (*nvram_safe_get("https_crt_file")) == 0) {
			save_cert();
		}

		if (ssl_init("/etc/cert.pem", "/etc/key.pem")) return;
		
		erase_cert();
		
		syslog(retry ? LOG_WARNING : LOG_ERR, "Unable to start SSL");
		if (!retry) exit(1);
		retry = 0;
	}
}
#endif

void init_id(void)
{
	char s[128];
	unsigned long long n;

	if (strncmp(nvram_safe_get("http_id"), "TID", 3) != 0) {
		f_read("/dev/urandom", &n, sizeof(n));
		sprintf(s, "TID%llx", n);
		nvram_set("http_id", s);	
	}
}

void check_id(void)
{
	const char *hid;
	
	hid = nvram_safe_get("http_id");
	if (strcmp(hid, webcgi_safeget("_http_id", "")) != 0) {
#if 0
		if (url) {
			const char *a;
			int n;

			// http://xxx/yyy/TID/zzz
			if (((a = strrchr(url, '/')) != NULL) && (a != url)) {
				n = strlen(hid);
				a -= n;
				if ((a > url) && (*(a - 1) == '/')) {
					if (strncmp(a, hid, n) == 0) return;
				}
			}
		}

#endif

//		if (hidok) return;

		_dprintf("http_id mismatch %s != %s\n", hid, webcgi_safeget("_http_id", ""));
		syslog(LOG_WARNING, "http_id mismatch");
		exit(1);
	}
}

int main(int argc, char **argv)
{
	int c;
	int debug = 0;
	int server_port = 0;

	while ((c = getopt(argc, argv, "hdp:s")) != -1) {
		switch (c) {
		case 'h':
			printf(
				"Usage: %s [options]\n"
				"  -d        Debug mode / do not demonize\n"
				"  -p <port> Port to listen on\n"
#ifdef TCONFIG_HTTPS
				"  -s        Use HTTPS\n"
#endif
				, argv[0]);
			return 1;
		case 'd':
			debug = 1;
			break;
		case 'p':
			server_port = atoi(optarg);
			break;
#ifdef TCONFIG_HTTPS
		case 's':
			do_ssl = 1;
			break;
#endif
		}
	}

	if (server_port == 0) {
#ifdef TCONFIG_HTTPS
		if (do_ssl) {
			server_port = nvram_get_int("https_lanport");
			if (server_port <= 0) server_port = 443;
		}
		else {
			server_port = nvram_get_int("http_lanport");
			if (server_port <= 0) server_port = 80;
		}
#else
		server_port = nvram_get_int("http_lanport");
		if (server_port <= 0) server_port = 80;
#endif
	}

	openlog("httpd", LOG_PID, LOG_DAEMON);

	if (!debug) {
		if (daemon(1, 1) == -1) {
			syslog(LOG_ERR, "daemon: %m");
			return 0;
		}


		char s[16];
		sprintf(s, "%d", getpid());
		f_write_string(do_ssl ? "/var/run/httpsd.pid" : "/var/run/httpd.pid", s, 0, 0644);
	}
	else {
		printf("DEBUG mode, not daemonizing\n");
	}

	signal(SIGPIPE, SIG_IGN);
	signal(SIGALRM, SIG_IGN);
	signal(SIGHUP, SIG_IGN);
	signal(SIGCHLD, reap);

#ifdef TCONFIG_HTTPS
	if (do_ssl) start_ssl();
#endif

	struct timeval tv;
	int n;

	if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
		syslog(LOG_ERR, "create listening socket: %m");
		return 1;
	}
	fcntl(listenfd, F_SETFD, FD_CLOEXEC);
	n = 1;
	setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, (char*)&n, sizeof(n));

	struct sockaddr_in	sai;
	sai.sin_family = AF_INET;
	sai.sin_port = htons(server_port);
	sai.sin_addr.s_addr = INADDR_ANY;
	if (bind(listenfd, (struct sockaddr *)&sai, sizeof(sai)) < 0) {
		syslog(LOG_ERR, "bind: %m");
		return 1;
	}

	if (listen(listenfd, 64) < 0) {
		syslog(LOG_ERR, "listen: %m");
		return 1;
	}
	
	init_id();

	for (;;) {
		webcgi_init(NULL);
		if (connfd >= 0) close(connfd);

		n = sizeof(clientsai);
		if ((connfd = accept(listenfd, (struct sockaddr *)&clientsai, &n)) < 0) {
//			if ((errno != EINTR) && (errno != EAGAIN)) {
//				syslog(LOG_ERR, "accept: %m");
//				return 1;
//			}
			sleep(1);
			continue;
		}

		if (!wait_action_idle(10)) {
//			syslog(LOG_WARNING, "router is busy");
			continue;
		}

		if (!check_wlaccess()) {
			continue;
		}
		
		if (fork() == 0) {
			close(listenfd);

			tv.tv_sec = 60;
			tv.tv_usec = 0;
			setsockopt(connfd, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));
			setsockopt(connfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));

			n = 1;
			setsockopt(connfd, IPPROTO_TCP, TCP_NODELAY, (char *)&n, sizeof(n));

			fcntl(connfd, F_SETFD, FD_CLOEXEC);

			if (web_open()) handle_request();
			web_close();
			exit(0);
		}
	}

	close(listenfd);
	return 0;
}