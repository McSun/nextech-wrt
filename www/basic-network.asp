<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
#spin {
	visibility: hidden;
	vertical-align: middle;
}
</style>
<script type='text/javascript'>
//	<% nvram("dhcp_lease,dhcp_num,dhcp_start,dhcpd_startip,dhcpd_endip,l2tp_server_ip,lan_gateway,lan_ipaddr,lan_netmask,lan_proto,mtu_enable,ppp_demand,ppp_idletime,ppp_passwd,ppp_redialperiod,ppp_service,ppp_username,pptp_server_ip,security_mode2,wan_dns,wan_gateway,wan_ipaddr,wan_mtu,wan_netmask,wan_proto,wan_wins,wds_enable,wl_channel,wl_closed,wl_crypto,wl_key,wl_key1,wl_key2,wl_key3,wl_key4,wl_lazywds,wl_mode,wl_net_mode,wl_passphrase,wl_radio,wl_radius_ipaddr,wl_radius_port,wl_ssid,wl_wds,wl_wep_bit,wl_wpa_gtk_rekey,wl_wpa_psk,wl_radius_key,wds_save,wl_auth,wl0_hwaddr"); %>

xob = null;
ghz = [['1', '1 - 2.412 GHz'],['2', '2 - 2.417 GHz'],['3', '3 - 2.422 GHz'],['4', '4 - 2.427 GHz'],['5', '5 - 2.432 GHz'],['6', '6 - 2.437 GHz'],['7', '7 - 2.442 GHz'],['8', '8 - 2.447 GHz'],['9', '9 - 2.452 GHz'],['10', '10 - 2.457 GHz'],['11', '11 - 2.462 GHz'],['12', '12 - 2.467 GHz'],['13', '13 - 2.472 GHz'],['14', '14 - 2.484 GHz']]

if ((!fixIP(nvram.dhcpd_startip)) || (!fixIP(nvram.dhcpd_endip))) {
	var x = nvram.lan_ipaddr.split('.').splice(0, 3).join('.') + '.';
	nvram.dhcpd_startip = x + nvram.dhcp_start;
	nvram.dhcpd_endip = x + ((nvram.dhcp_start * 1) + (nvram.dhcp_num * 1) - 1);
}

function spin(x)
{
	var e = E('_f_scan');
	e.disabled = x;
	if (x) e.value = 'Scan ' + (wscan.tries + 1);
		else e.value = 'Scan';
	E('spin').style.visibility = x ? 'visible' : 'hidden';
}

function scan()
{
	if (xob) return;

	xob = new XmlHttp();
	xob.onCompleted = function(text, xml) {
		try {
			var i;

			wlscandata = [];
			eval(text);

			for (i = 0; i < wlscandata.length; ++i) {
				var data = wlscandata[i];
				var ch = data[2];
				var mac = data[0];

				if (!wscan.inuse[ch]) {
					wscan.inuse[ch] = {
						count: 0,
						rssi: -999,
						ssid: ''
					};
				}

				if (!wscan.seen[mac]) {
					wscan.seen[mac] = 1;
					++wscan.inuse[ch].count;
				}

				if (data[4] > wscan.inuse[ch].rssi) {
					wscan.inuse[ch].rssi = data[4];
					wscan.inuse[ch].ssid = data[1];
				}
			}
			var e = E('_wl_channel');
			for (i = 0; i < 14; ++i) {
				var s = ghz[i][1];
				var u = wscan.inuse[i + 1];
				if (u) s += ' (' + u.count + ' AP' + (u.count == 1 ? '' : 's') + ' / strongest: "' + ellipsis(u.ssid, 15) + '" ' + u.rssi + ' dBm)';
				e.options[i].innerHTML = s;
			}
			e.style.width = '400px';

			xob = null;

			if (wscan.tries < 4) {
				++wscan.tries;
				setTimeout(scan, 1000);
				return;
			}
		}
		catch (x) {
		}
		spin(0);
	}
	xob.onError = function(x) {
		alert('error: ' + x);
		spin(0);
		xob = null;
	}

	spin(1);
	xob.post('update.cgi', 'exec=wlscan');
}

function scanButton()
{
	if (xob) return;

	wscan = {
		seen: [],
		inuse: [],
		tries: 0
	};

	scan();
}

function joinAddr(a) {
	var r, i, s;

	r = [];
	for (i = 0; i < a.length; ++i) {
		s = a[i];
		if ((s != '00:00:00:00:00:00') && (s != '0.0.0.0')) r.push(s);
	}
	return r.join(' ');
}

function random_x(max)
{
	var c = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
	var s = '';
	while (max-- > 0) s += c.substr(Math.floor(c.length * Math.random()), 1);
	return s;
}

function random_psk(id)
{
	var e = E(id);
	e.value = random_x(63);
	verifyFields(null, 1);
}

function random_wep()
{
	E('_wl_passphrase').value = random_x(16);
	generate_wep();
}

function v_wep(e, quiet)
{
	var s = e.value.toUpperCase().replace(/[^0-9A-F]/g, '');
	if (s.length != e.maxLength) {
		ferror.set(e, 'Invalid WEP key, ', quiet);
		return 0;
	}
	e.value = s;
	ferror.clear(e);
	return 1;
}

// compatible w/ Linksys' and Netgear's (key 1) method for 128-bits
function generate_wep()
{
	function _wepgen(pass, i)
	{
		while (pass.length < 64) pass += pass;
		return hex_md5(pass.substr(0, 64)).substr(i, (E('_wl_wep_bit').value == 128) ? 26 : 10);
	}

	var e = E('_wl_passphrase');
	var pass = e.value;
	if (!v_length(e, false, 3)) return;
	E('_wl_key1').value = _wepgen(pass, 0);
	pass += '#$%';
	E('_wl_key2').value = _wepgen(pass, 2);
	pass += '!@#';
	E('_wl_key3').value = _wepgen(pass, 4);
	pass += '%&^';
	E('_wl_key4').value = _wepgen(pass, 6);
	verifyFields(null, 1);
}

function verifyFields(focused, quiet)
{
	var i;
	var ok = 1;
	var a, b, c, d, e;


	// --- visibility ---

	var vis = {
		_wan_na: 1,

		_wan_proto: 1,
		_ppp_username: 1,
		_ppp_passwd: 1,
		_ppp_service: 1,
		_l2tp_server_ip: 1,
		_wan_ipaddr: 1,
		_wan_netmask: 1,
		_wan_gateway: 1,
		_pptp_server_ip: 1,
		_ppp_demand: 1,
		_ppp_idletime: 1,
		_ppp_redialperiod: 1,
		_mtu_enable: 1,
		_f_wan_mtu: 1,

		_dhcp_lease: 1,
		_f_dhcpd_enable: 1,
		_dhcpd_startip: 1,
		_dhcpd_endip: 1,
		_f_dns_1: 1,
		_f_dns_2: 1,
		_f_dns_3: 1,
		_lan_gateway: 1,
		_lan_ipaddr: 1,
		_lan_netmask: 1,
		_wan_wins: 1,

		_f_wl_radio: 1,
		_f_wmode: 1,
		_wl_net_mode: 1,
		_wl_ssid: 1,
		_f_bcast: 1,
		_wl_channel: 1,
		_f_scan: 1,

		_security_mode2: 1,
		_wl_crypto: 1,
		_wl_wpa_psk: 1,
		_f_psk_random1: 1,
		_f_psk_random2: 1,
		_wl_wpa_gtk_rekey: 1,
		_wl_radius_key: 1,
		_wl_radius_ipaddr: 1,
		_wl_radius_port: 1,
		_wl_wep_bit: 1,
		_wl_passphrase: 1,
		_f_wep_gen: 1,
		_f_wep_random: 1,
		_wl_key1: 1,
		_wl_key2: 1,
		_wl_key3: 1,
		_wl_key4: 1,

		_f_wl_lazywds: 1,
		_f_wds_0: 1
	};

	var wan = E('_wan_proto').value;
	var wmode = E('_f_wmode').value;

	if (wmode == 'wet') {
		wan = 'disabled';
		vis._wan_proto = 0;
		vis._f_dhcpd_enable = 0;
		vis._dhcp_lease = 0;
	}
	else vis._wan_na = 0;

	switch (wan) {
	case 'disabled':
		vis._ppp_username = 0;
		vis._ppp_service = 0;
		vis._l2tp_server_ip = 0;
		vis._wan_ipaddr = 0;
		vis._wan_netmask = 0;
		vis._wan_gateway = 0;
		vis._pptp_server_ip = 0;
		vis._ppp_demand = 0;
		vis._mtu_enable = 0;
		vis._f_wan_mtu = 0;
		break;
	case 'dhcp':
		vis._l2tp_server_ip = 0;
		vis._ppp_demand = 0;
		vis._ppp_service = 0;
		vis._ppp_username = 0;
		vis._pptp_server_ip = 0;
		vis._wan_gateway = 0;
		vis._wan_ipaddr = 0;
		vis._wan_netmask = 0;

		vis._lan_gateway = 0;
		break;
	case 'pppoe':
		vis._l2tp_server_ip = 0;
		vis._pptp_server_ip = 0;
		vis._wan_gateway = 0;
		vis._wan_ipaddr = 0;
		vis._wan_netmask = 0;

		vis._lan_gateway = 0;
		break;
	case 'static':
		vis._l2tp_server_ip = 0;
		vis._ppp_demand = 0;
		vis._ppp_service = 0;
		vis._ppp_username = 0;
		vis._pptp_server_ip = 0;

		vis._lan_gateway = 0;
		break;
	case 'pptp':
		vis._l2tp_server_ip = 0;
		vis._ppp_service = 0;
		vis._wan_gateway = 0;

		vis._lan_gateway = 0;
		break;
	case 'l2tp':
		vis._ppp_service = 0;
		vis._pptp_server_ip = 0;
		vis._wan_gateway = 0;
		vis._wan_ipaddr = 0;
		vis._wan_netmask = 0;

		vis._lan_gateway = 0;
		break;
	}

	vis._ppp_idletime = (E('_ppp_demand').value == 1) && vis._ppp_demand
	vis._ppp_redialperiod = !vis._ppp_idletime && vis._ppp_demand;

	if (vis._mtu_enable) {
		if (E('_mtu_enable').value == 0) {
			vis._f_wan_mtu = 2;
			a = E('_f_wan_mtu');
			switch (E('_wan_proto').value) {
			case 'pppoe':
				a.value = 1492;
				break;
			case 'pptp':
			case 'l2tp':
				a.value = 1460;
				break;
			 default:
				a.value = 1500;
				break;
			}
		}
	}

	if (!E('_f_dhcpd_enable').checked) vis._dhcp_lease = 0;

	if (!E('_f_wl_radio').checked) {
		vis._f_wl_lazywds = 2;
		vis._f_wds_0 = 2;
		vis._f_wmode = 2;
		vis._security_mode2 = 2;
		vis._wl_channel = 2;
		vis._f_bcast = 2;
		vis._wl_crypto = 2;
		vis._wl_net_mode = 2;
		vis._wl_wpa_psk = 2;
		vis._wl_radius_key = 2;
		vis._wl_wpa_gtk_rekey = 2;
		vis._wl_radius_ipaddr = 2;
		vis._wl_ssid = 2;
		vis._wl_wep_bit = 2;
	}

	switch (wmode) {
	case 'apwds':
	case 'wds':
		break;
	case 'wet':
	case 'sta':
		vis._f_bcast = 0;
	default:
		vis._f_wl_lazywds = 0;
		vis._f_wds_0 = 0;
		break;
	}

	var sm2 = E('_security_mode2').value;
	switch (sm2) {
	case 'disabled':
		vis._wl_crypto = 0;
		vis._wl_wep_bit = 0;
		vis._wl_wpa_psk = 0;
		vis._wl_radius_key = 0;
		vis._wl_radius_ipaddr = 0;
		vis._wl_wpa_gtk_rekey = 0;

		break;
	case 'wep':
		vis._wl_crypto = 0;
		vis._wl_wpa_psk = 0;
		vis._wl_radius_key = 0;
		vis._wl_radius_ipaddr = 0;
		vis._wl_wpa_gtk_rekey = 0;
		break;
	case 'radius':
		vis._wl_crypto = 0;
		vis._wl_wpa_psk = 0;
		break;
	default:	// wpa*
		vis._wl_wep_bit = 0;
		if (sm2.indexOf('personal') != -1) {
			vis._wl_radius_key = 0;
			vis._wl_radius_ipaddr = 0;
		}
		else {
			vis._wl_wpa_psk = 0;
		}
		break;
	}

	if ((E('_f_wl_lazywds').value == 1) && (vis._f_wds_0 == 1)) {
		vis._f_wds_0 = 2;
	}

	//

	vis._ppp_passwd = vis._ppp_username;
	vis._dhcpd_startip = vis._dhcpd_endip = vis._wan_wins = vis._dhcp_lease;
	vis._f_scan = vis._wl_channel;
	vis._f_psk_random1 = vis._wl_wpa_psk;
	vis._f_psk_random2 = vis._wl_radius_key;
	vis._wl_radius_port = vis._wl_radius_ipaddr;
	vis._wl_key1 = vis._wl_key2 = vis._wl_key3 = vis._wl_key4 = vis._f_wep_gen = vis._f_wep_random = vis._wl_passphrase = vis._wl_wep_bit;

	for (i = 1; i < 10; ++i) {
		vis['_f_wds_' + i] = vis._f_wds_0;
	}
	for (a in vis) {
		b = E(a);
		c = vis[a];
		b.disabled = (c != 1);
		PR(b).style.display = c ? '' : 'none';
	}


	// --- verify ---

	if (wmode == 'sta') {
		if (wan == 'disabled') {
			ferror.set('_wan_proto', 'Wireless Client mode requires a valid WAN setting (usually DHCP).', quiet);
			return 0;
		}
	}
	ferror.clear('_wan_proto');

	if ((vis._f_wmode == 1) && (wmode != 'ap') && (sm2.substr(0, 4) == 'wpa2')) {
		ferror.set('_security_mode2', 'WPA2 is supported only in AP mode.', quiet);
		return 0;
	}
	ferror.clear('_security_mode2');

	a = E('_wl_wpa_psk');
	ferror.clear(a);
	if (vis._wl_wpa_psk == 1) {
		if ((a.value.length < 8) || ((a.value.length == 64) && (a.value.search(/[^0-9A-Fa-f]/) != -1))) {
			ferror.set('_wl_wpa_psk', 'Invalid pre-shared key. Please enter at least 8 characters or 64 hexadecimal digits.', quiet);
			ok = 0;
		}
	}

	// IP address
	a = ['_l2tp_server_ip','_pptp_server_ip', '_wan_gateway','_wan_ipaddr','_lan_ipaddr', '_wl_radius_ipaddr', '_dhcpd_startip', '_dhcpd_endip'];
	for (i = a.length - 1; i >= 0; --i)
		if ((vis[a[i]]) && (!v_ip(a[i], quiet))) ok = 0;

	// IP address, blank -> 0.0.0.0
	a = ['_f_dns_1', '_f_dns_2', '_f_dns_3','_wan_wins','_lan_gateway'];
	for (i = a.length - 1; i >= 0; --i)
		if ((vis[a[i]]) && (!v_ipz(a[i], quiet))) ok = 0;

	// netmask
	a = ['_wan_netmask','_lan_netmask'];
	for (i = a.length - 1; i >= 0; --i)
		if ((vis[a[i]]) && (!v_netmask(a[i], quiet))) ok = 0;

	// range
	a = [['_ppp_idletime', 3, 1440],['_ppp_redialperiod', 1, 86400],['_f_wan_mtu', 576, 1500],
		 ['_dhcp_lease', 1, 10080],['_wl_wpa_gtk_rekey', 60, 7200], ['_wl_radius_port', 1, 65535]];
	for (i = a.length - 1; i >= 0; --i) {
		v = a[i];
		if ((vis[v[0]]) && (!v_range(v[0], quiet, v[1], v[2]))) ok = 0;
	}

	// length
	a = [['_wl_ssid', 1], ['_wl_radius_key', 1]];
	for (i = a.length - 1; i >= 0; --i) {
		v = a[i];
		if ((vis[v[0]]) && (!v_length(v[0], quiet, v[1], E(v[0]).maxlength))) ok = 0;
	}

	if (vis._wl_key1) {
		a = (E('_wl_wep_bit').value == 128) ? 26 : 10;
		for (i = 1; i <= 4; ++i) {
			b = E('_wl_key' + i);
			b.maxLength = a;
			if ((b.value.length > 0) || (E('_f_wepidx_' + i).checked)) {
				if (!v_wep(b, quiet)) ok = 0;
			}
			else ferror.clear(b);
		}
	}

	ferror.clear('_f_wds_0');
	if (vis._f_wds_0 == 1) {
		b = 0;
		for (i = 0; i < 10; ++i) {
			a = E('_f_wds_' + i);
			if (!v_macz(a, quiet)) ok = 0;
				else if (!isMAC0(a.value)) b = 1;
		}
		if (!b) {
			ferror.set('_f_wds_0', 'WDS MAC address required.', quiet);
			ok = 0;
		}
	}

	a = E('_dhcpd_startip');
	b = E('_dhcpd_endip');
	
	if ((!a._error_msg) && (!b._error_msg)) {
		c = aton(E('_lan_netmask').value);
		d = aton(E('_lan_ipaddr').value) & c;
		e = 'Invalid IP address or subnet mask';
		if ((aton(a.value) & c) != d) {
			ferror.set(a, e, quiet);
			ok = 0;
		}
		if ((aton(b.value) & c) != d) {
			ferror.set(b, e, quiet);
			ok = 0;
		}
	}
	
	if ((!a._error_msg) && (!b._error_msg)) {
		if (aton(a.value) > aton(b.value)) {
			c = a.value;
			a.value = b.value;
			b.value = c;
		}
		
		elem.setInnerHTML('dhcp_count', '(' + ((aton(b.value) - aton(a.value)) + 1) + ')');
	}

	return ok;
}

function earlyInit()
{
	verifyFields(null, 1);
}

function save()
{
	var a, b, c;
	var i;

	if (!verifyFields(null, false)) return;

	var fom = E('_fom');
	var wmode = fom.f_wmode.value;
	var sm2 = fom.security_mode2.value;
	var wradio = fom.f_wl_radio.checked;

	fom.lan_proto.value = fom.f_dhcpd_enable.checked ? 'dhcp' : 'static';

	fom.wan_mtu.value = fom.f_wan_mtu.value;
	fom.wan_mtu.disabled = fom.f_wan_mtu.disabled;

	if (wmode == 'apwds') fom.wl_mode.value = 'ap';
		else fom.wl_mode.value = wmode;

	if (wmode == 'wet') {
		fom.wan_proto.value = 'disabled';
		fom.wan_proto.disabled = 0;
		fom.lan_proto.value = 'static';
	}

	a = [];
	for (i = 0; i < 10; ++i) a.push(E('_f_wds_' + i).value);
	fom.wl_wds.value = joinAddr(a);

	fom.wds_save.value = nvram.wds_save;
	if (wmode.indexOf('wds') != -1) {
        fom.wds_enable.value = 1;
		fom.wl_lazywds.value = fom.f_wl_lazywds.value;
		if (fom.wl_lazywds.value == 1) fom.wl_wds.value = '';
			else fom.wds_save.value = fom.wl_wds.value;
	}
	else {
		fom.wds_enable.value = 0;
		fom.wl_wds.value = '';
		fom.wl_lazywds.value = 0;
	}

	fom.wan_dns.value = joinAddr([fom.f_dns_1.value, fom.f_dns_2.value, fom.f_dns_3.value])

	fom.wl_radio.value = fom.f_wl_radio.checked ? 1 : 0;
	fom.wl_radio.disabled = fom.f_wl_radio.disabled;

	fom.wl_auth.value = nvram.wl_auth;

	switch (sm2) {
	case 'disabled':
	case 'radius':
	case 'wep':
		fom.security_mode.value = sm2;
		fom.wl_akm.value = '';
		break;
	default:
		c = [];
		if (sm2.indexOf('personal') != -1) {
			if (sm2.indexOf('wpa2_') == -1) c.push('psk');
			if (sm2.indexOf('wpa_') == -1) c.push('psk2');
		}
		else {
			if (sm2.indexOf('wpa2_') == -1) c.push('wpa');
			if (sm2.indexOf('wpa_') == -1) c.push('wpa2');
		}
		c = c.join(' ');
		fom.security_mode.value = c;
		fom.wl_akm.value = c;
		break;
	}
	fom.wl_auth_mode.value = (sm2 == 'radius') ? 'radius' : 'none';
	fom.wl_wep.value = ((sm2 == 'radius') || (sm2 == 'wep')) ? 'enabled': 'disabled';
	fom.wl_auth_mode.disabled = fom.wl_wep.disabled = fom.security_mode.disabled = fom.wl_akm.disabled = fom.security_mode2.disabled;

	if (sm2.indexOf('wpa') != -1) fom.wl_auth.value = 0;

	fom.wl_gmode.value = (fom.wl_net_mode.value == 'b-only') ? 0 : (fom.wl_net_mode.value == 'g-only') ? 2 : 1;
	fom.wl_gmode.disabled = fom.wl_net_mode.disabled;

	fom.wl_closed.value = fom.f_bcast.checked ? 0 : 1;
	fom.wl_closed.disabled = fom.f_bcast.disabled;

	fom.wl_key.value = fields.radio.selected(fom.f_wepidx).value;
	fom.wl_key.disabled = fom.wl_key1.disabled;

	fom.wl_mode.disabled = fom.wl_wds.disabled = fom.wds_enable.disabled = !fom.f_wl_radio.checked;

	if (nvram.lan_ipaddr != fom.lan_ipaddr.value) {
		fom._moveip.value = 1;
		form.submit(fom);
	}
	else {
		form.submit(fom, 1);
	}
}
</script>
<body onLoad="init()" style="WIDTH: 100%; HEIGHT: 100%" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0">
<script language="javascript">
{  
	function ChangeLink(obj,state,imgname)  {    
		var img = document.getElementById(imgname);    
		obj.style.color = '#FFFFFF';    
		img.src ='HeaderButtonOff.gif';    
		if(state=='over')    {      
			obj.style.color = '#FDCA17';      
			img.src ='HeaderButtonOver.gif';    
		}  
	}
}
</script>
<table style="WIDTH: 100%; HEIGHT: 100%" cellSpacing="0" cellPadding="0" border="0">
  <tr id="HeaderRow">
    <td><table id="Header_MainMenuMiddle" cellspacing="0" cellpadding="0" border="0" height="120" width="100%" background="HeaderMiddle.gif">
        <tr>
          <td nowrap="nowrap" align="Left" valign="Top" colspan="2"><table cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td valign="top"><a id="Header_SiteLogo" href="Default.aspx"><img src="SiteLogo.gif" alt="" border="0" /></a></td>
              </tr>
              <tr>
                <td valign="top"><a id="Header_Hyperlink1" href="Default.aspx"><img src="SiteLogo2.gif" alt="" border="0" /></a></td>
              </tr>
              <tr>
                <td valign="top"><a id="Header_Hyperlink2" href="Default.aspx"><img src="SiteLogo3.gif" alt="" border="0" /></a></td>
              </tr>
            </table></td>
          <td nowrap="nowrap" align="Right" valign="Top" height="120"><div align="right"> <img id="Header_HeaderPixTop" src="HeaderPix.gif" alt="" align="Top" border="0" /><br>
         
	<a id="Header_hlContact" onMouseOver="ChangeLink(this,'over','Header_imgContact');" onMouseOut="ChangeLink(this,'off','Header_imgContact');" href="http://www.nex-tech.com/Document.aspx?mode=1&amp;id=2204" target="_blank"><font color="White" size="1"><img id="Header_imgContact" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Contact Us&nbsp;</font></a>
	<a id="Header_hlEmployment" onMouseOver="ChangeLink(this,'over','Header_imgSpeed');" onMouseOut="ChangeLink(this,'off','Header_imgSpeed');" href="http://speedtest.nex-tech.com/" target="_blank"><font color="White" size="1"><img id="Header_imgSpeed" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Speed Test&nbsp;</font></a>
	<a id="Header_hlEmployment" onMouseOver="ChangeLink(this,'over','Header_imgEmploy');" onMouseOut="ChangeLink(this,'off','Header_imgEmploy');" href="tech-support.asp" target="_blank"><font color="White" size="1"><img id="Header_imgEmploy" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Tech Support&nbsp;&nbsp;</font></a>
 </div></td>
        </tr>
      </table></td>
  </tr>
  <tr height="100%">
    <td style="WIDTH: 100%; HEIGHT: 100%" vAlign="top"><table id="ContentTable" cellspacing="0" cellpadding="0" border="0" height="100%">
        <tr id="ContentRow">
          <td id="ContentLeftCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%; background-color: #3A362B;"><div id="LeftColumn">
              <table id="DefaultLeftColumn_Table1" class="LeftColumn" cellspacing="0" cellpadding="0" border="0" style="WIDTH: 166px; HEIGHT: 100%">
                <tr id="DefaultLeftColumn_TableRow3">
                  <td id="DefaultLeftColumn_TableCell3" style="WIDTH: 166px; HEIGHT: 10px"></td>
                </tr>
                <tr id="DefaultLeftColumn_TableRow1">
                  <td id="DefaultLeftColumn_TableCell1" align="Center" valign="Top" style="WIDTH: 166px; HEIGHT: 100%"><table cellspacing=0 cellpadding=0>
                      <tr>
                        <td valign=top><span id="DefaultLeftColumn_MainMenu">
                          
                          <table cellpadding="0" cellspacing="0" border="0" width="156px" align="center"
  onmouseover="javascript:StopSlideShow();" onMouseOut="javascript:StartSlideShow();">
                            <tr>
                              <td><img id="DefaultLeftColumn_MainMenu__ctl0_SiteSearchHeader" src="SiteSearchHeaderOff.gif" alt="" border="0" /></td>
                            </tr>
                            <tr>
                              <td id="navi" align="left" class="ToolBox"><!-- this fixed the Navigator width problem, was set to align="center"  -->
                                
                                <script type='text/javascript'>navi()</script>
                                
                              </td>
                            </tr>
                            <tr>
                              <td><img id="DefaultLeftColumn_MainMenu__ctl0_SiteSearchFooter" src="ToolBoxFooterOff.gif" alt="" border="0" /></td>
                            </tr>
                          </table>
                          <br />
                          </span></td>
                      </tr>
                    </table>
                    <span> <br />
                    <br />
                    </span></td>
                </tr>
                <tr id="DefaultLeftColumn_TableRow2">
                  <td id="DefaultLeftColumn_TableCell2" align="Center" valign="Middle" style="WIDTH: 166px; HEIGHT: 100%"></td>
                </tr>
              </table>
            </div></td>
          <td id="ContentCenterCell" valign="Top" style="WIDTH: 100%; HEIGHT: 100%"><div id="divBC" style="LEFT: 171px; POSITION: absolute; TOP: 105px"> <span id="breadcrumb"> <br>
              <table id="breadcrumb__ctl0_panel1" onMouseOver="javascript:HidePanel2();" onMouseOut="javascript:ShowPanel2();" nowrap="nowrap" cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                  <td></td>
                </tr>
              </table>
              <table id="breadcrumb__ctl0_panel2" nowrap="nowrap" cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                  <td></td>
                </tr>
              </table>
              
              </span> </div>
            <table id="Content_Content" cellpadding="0" cellspacing="0" border="0" width="100%">
              <tr>
                <td><table width="90%">
                    <tr>
                      <td valign="top" align="left" style="padding-left: 10px;">
                        <form id='_fom' method='post' action='tomato.cgi'>

                        <!-- / / / -->
                        
                        <input type='hidden' name='_nextpage' value='basic-network.asp'>
                        <input type='hidden' name='_nextwait' value='10'>
                        <input type='hidden' name='_service' value='*'>
                        <input type='hidden' name='_moveip' value='0'>
                        
                        <input type='hidden' name='wan_mtu'>
                        <input type='hidden' name='wl_mode'>
                        <input type='hidden' name='wds_enable'>
                        <input type='hidden' name='wl_wds'>
                        <input type='hidden' name='wds_save'>
                        <input type='hidden' name='lan_proto'>
                        <input type='hidden' name='wan_dns'>
                        <input type='hidden' name='wl_radio'>
                        <input type='hidden' name='wl_closed'>
                        <input type='hidden' name='wl_key'>
                        <input type='hidden' name='wl_gmode'>
                        <input type='hidden' name='security_mode'>
                        <input type='hidden' name='wl_akm'>
                        <input type='hidden' name='wl_auth'>
                        <input type='hidden' name='wl_auth_mode'>
                        <input type='hidden' name='wl_wep'>
                        <input type='hidden' name='wl_lazywds'>
                        
                        
                        <div class='section-title'>WAN / Internet</div>
                        <div class='section' onMouseOver="replaceElement('wan')" onMouseOut="removeElement('wan')">
                        <script type='text/javascript'>
                        createFieldTable('', [
                            { text: '<span id="_wan_na"><i>Wireless Ethernet Bridge Mode</i></span>' },
                            { title: 'Type', name: 'wan_proto', type: 'select', options: [['dhcp','DHCP'],['pppoe','PPPoE'],['static','Static'],['pptp','PPTP'],['l2tp','L2TP'],['disabled','Disabled']],
                                value: nvram.wan_proto },
                            { title: 'Username', name: 'ppp_username', type: 'text', maxlen: 50, size: 54, value: nvram.ppp_username },
                            { title: 'Password', name: 'ppp_passwd', type: 'password', maxlen: 50, size: 54, value: nvram.ppp_passwd },
                            { title: 'Service Name', name: 'ppp_service', type: 'text', maxlen: 50, size: 54, value: nvram.ppp_service },
                            { title: 'L2TP Server', name: 'l2tp_server_ip', type: 'text', maxlen: 15, size: 17, value: nvram.l2tp_server_ip },
                            { title: 'IP Address', name: 'wan_ipaddr', type: 'text', maxlen: 15, size: 17, value: nvram.wan_ipaddr },
                            { title: 'Subnet Mask', name: 'wan_netmask', type: 'text', maxlen: 15, size: 17, value: nvram.wan_netmask },
                            { title: 'Gateway', name: 'wan_gateway', type: 'text', maxlen: 15, size: 17, value: nvram.wan_gateway },
                            { title: 'Gateway', name: 'pptp_server_ip', type: 'text', maxlen: 15, size: 17, value: nvram.pptp_server_ip },
                            { title: 'Connect Mode', name: 'ppp_demand', type: 'select', options: [['1', 'Connect On Demand'],['0', 'Keep Alive']],
                                value: nvram.ppp_demand },
                            { title: 'Max Idle Time', indent: 2, name: 'ppp_idletime', type: 'text', maxlen: 5, size: 7, suffix: ' <i>(minutes)</i>',
                                value: nvram.ppp_idletime },
                            { title: 'Check Interval', indent: 2, name: 'ppp_redialperiod', type: 'text', maxlen: 5, size: 7, suffix: ' <i>(seconds)</i>',
                                value: nvram.ppp_redialperiod },
                            { title: 'MTU', multi: [
                                { name: 'mtu_enable', type: 'select', options: [['0', 'Default'],['1','Manual']], value: nvram.mtu_enable },
                                { name: 'f_wan_mtu', type: 'text', maxlen: 4, size: 6, value: nvram.wan_mtu } ] }
                        ]);
                        </script>
                        </div>
                        
                        <div class='section-title'>LAN</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        dns = nvram.wan_dns.split(/\s+/);
                        ipp = nvram.lan_ipaddr.split('.').splice(0, 3).join('.');
                        
                        createFieldTable('', [
                            { title: 'Router IP Address', name: 'lan_ipaddr', type: 'text', maxlen: 15, size: 17, value: nvram.lan_ipaddr },
                            { title: 'Subnet Mask', name: 'lan_netmask', type: 'text', maxlen: 15, size: 17, value: nvram.lan_netmask },
                            { title: 'Default Gateway', name: 'lan_gateway', type: 'text', maxlen: 15, size: 17, value: nvram.lan_gateway },
                            { title: 'Static DNS', name: 'f_dns_1', type: 'text', maxlen: 15, size: 17, value: dns[0] || '0.0.0.0' },
                            { title: '', name: 'f_dns_2', type: 'text', maxlen: 15, size: 17, value: dns[1] || '0.0.0.0' },
                            { title: '', name: 'f_dns_3', type: 'text', maxlen: 15, size: 17, value: dns[2] || '0.0.0.0' },
                            { title: 'DHCP Server', name: 'f_dhcpd_enable', type: 'checkbox', value: (nvram.lan_proto == 'dhcp') },
                            { title: 'IP Address Range', indent: 2, multi: [
                                { name: 'dhcpd_startip', type: 'text', maxlen: 15, size: 17, value: nvram.dhcpd_startip, suffix: ' - ' },
                                { name: 'dhcpd_endip', type: 'text', maxlen: 15, size: 17, value: nvram.dhcpd_endip, suffix: ' <i id="dhcp_count"></i>' }
                            ] },                            
                            { title: 'Lease Time', indent: 2, name: 'dhcp_lease', type: 'text', maxlen: 6, size: 8, suffix: ' <i>(minutes)</i>',
                                value: (nvram.dhcp_lease > 0) ? nvram.dhcp_lease : 1440 },
                            { title: 'WINS', indent: 2, name: 'wan_wins', type: 'text', maxlen: 15, size: 17, value: nvram.wan_wins }
                        ]);
                        </script>
                        </div>
                        
                        
                        <div class='section-title'>Wireless</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        f = [
                            { title: 'Enable Wireless', name: 'f_wl_radio', type: 'checkbox',
                                value: (nvram.wl_radio == '1') && (nvram.wl_net_mode != 'disabled') },
                            { title: 'MAC Address', text: '<a href="advanced-mac.asp">' + nvram.wl0_hwaddr + '</a>' },
                            { title: 'Wireless Mode', name: 'f_wmode', type: 'select',
                                options: [['ap', 'Access Point'],['apwds', 'Access Point + WDS'],['sta', 'Wireless Client'],['wet', 'Wireless Ethernet Bridge'],['wds', 'WDS']],
                                value: ((nvram.wl_mode == 'ap') && (nvram.wds_enable == '1')) ? 'apwds' : nvram.wl_mode },
                            { title: 'B/G Mode', name: 'wl_net_mode', type: 'select', value: (nvram.wl_net_mode == 'disabled') ? 'mixed' : nvram.wl_net_mode, options:[['mixed','Mixed'],['b-only','B Only'],['g-only','G Only']] },
                            { title: 'SSID', name: 'wl_ssid', type: 'text', maxlen: 32, size: 34, value: nvram.wl_ssid },
                            { title: 'Broadcast', indent: 2, name: 'f_bcast', type: 'checkbox', value: (nvram.wl_closed == '0') },
                            { title: 'Channel', name: 'wl_channel', type: 'select', options: ghz, suffix: ' <input type="button" id="_f_scan" value="Scan" onclick="scanButton()"> <img src="spin.gif" id="spin">',
                                 value: nvram.wl_channel },
                            null,
                            { title: 'Security', name: 'security_mode2', type: 'select',
                                options: [['disabled','Disabled'],['wep','WEP'],['wpa_personal','WPA Personal'],['wpa_enterprise','WPA Enterprise'],['wpa2_personal','WPA2 Personal'],['wpa2_enterprise','WPA2 Enterprise'],['wpaX_personal','WPA / WPA2 Personal'],['wpaX_enterprise','WPA / WPA2 Enterprise'],['radius','Radius']],
                                value: nvram.security_mode2 },
                            { title: 'Encryption', indent: 2, name: 'wl_crypto', type: 'select',
                                options: [['tkip','TKIP'],['aes','AES'],['tkip+aes','TKIP / AES']], value: nvram.wl_crypto },
                            { title: 'Shared Key', indent: 2, name: 'wl_wpa_psk', type: 'text', maxlen: 64, size: 66,
                                suffix: ' <input type="button" id="_f_psk_random1" value="Random" onclick="random_psk(\'_wl_wpa_psk\')">',
                                value: nvram.wl_wpa_psk },
                            { title: 'Shared Key', indent: 2, name: 'wl_radius_key', type: 'text', maxlen: 80, size: 32,
                                suffix: ' <input type="button" id="_f_psk_random2" value="Random" onclick="random_psk(\'_wl_radius_key\')">',
                                value: nvram.wl_radius_key },
                            { title: 'Group Key Renewal', indent: 2, name: 'wl_wpa_gtk_rekey', type: 'text', maxlen: 4, size: 6, suffix: ' <i>(seconds)</i>',
                                value: nvram.wl_wpa_gtk_rekey },
                            { title: 'Radius Server', indent: 2, multi: [
                                { name: 'wl_radius_ipaddr', type: 'text', maxlen: 15, size: 17, value: nvram.wl_radius_ipaddr },
                                { name: 'wl_radius_port', type: 'text', maxlen: 5, size: 7, prefix: ' : ', value: nvram.wl_radius_port } ] },
                            { title: 'Encryption', indent: 2, name: 'wl_wep_bit', type: 'select', options: [['128','128-bits'],['64','64-bits']],
                                value: nvram.wl_wep_bit },
                            { title: 'Passphrase', indent: 2, name: 'wl_passphrase', type: 'text', maxlen: 16, size: 20,
                                suffix: ' <input type="button" id="_f_wep_gen" value="Generate" onclick="generate_wep()"> <input type="button" id="_f_wep_random" value="Random" onclick="random_wep()">',
                                value: nvram.wl_passphrase }
                        ];
                        
                        for (i = 1; i <= 4; ++i)	{
                            f.push(
                                { title: ('Key ' + i), indent: 2, name: ('wl_key' + i), type: 'text', maxlen: 26, size: 34,
                        
                                    suffix: '<input type="radio" onchange="verifyFields(this,1)" onclick="verifyFields(this,1)" name="f_wepidx" id="_f_wepidx_' + i + '" value="' + i + '"' + ((nvram.wl_key == i) ? ' checked>' : '>'),
                                    value: nvram['wl_key' + i] });
                        }
                        
                        f.push(null,
                            { title: 'WDS', name: 'f_wl_lazywds', type: 'select',
                                 options: [['0','Link With...'],['1','Automatic']], value: nvram.wl_lazywds } );
                        wds = ((nvram.wl_wds == '') ? nvram.wds_save : nvram.wl_wds).split(/\s+/);
                        for (i = 0; i < 10; i += 2)	{
                            f.push({ title: (i ? '' : 'MAC Address'), indent: 2, multi: [
                                { name: 'f_wds_' + i, type: 'text', maxlen: 17, size: 20, value: wds[i] || '00:00:00:00:00:00' },
                                { name: 'f_wds_' + (i + 1), type: 'text', maxlen: 17, size: 20, value: wds[i + 1] || '00:00:00:00:00:00' } ] } );
                        }
                        
                        createFieldTable('', f);
                        </script>
                        </div>
                        
                        <!-- / / / -->
                        
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
                        <script type='text/javascript'>earlyInit()</script>	
                        </form>				
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
            <h3>Brainy Bunch Help</h3>
			<div id="wan" style="display:none">
			<p>Type - Type of protocol used to connect to your service.</p>
			<p>MTU - Determines the maximum number of bytes your link can transmit.  For best results default is recommended as other options may cause problems.</p>
			</div>
            <p id="lan_ipaddr" style="display:none"> The address that  your computers will connect to for the router, also this is the address you will connect to with your browser to edit your router.</p>
            <p id="lan_netmask" style="display:none"> Used to show what  class of address and what subnet that address is in.  Recommended address is 255.255.255.0.</p>
            <p id="f_dns_1" style="display:none"> This allows you to designate a server for DNS instead of using default. Leaving  this blank is recommended.</p>
			<p id="f_dns_2" style="display:none"> This allows you to designate a server for DNS instead of using default. Leaving  this blank is recommended.</p>
			<p id="f_dns_3" style="display:none"> This allows you to designate a server for DNS instead of using default. Leaving  this blank is recommended.</p>
            <p id="f_dhcp_enable" style="display:none"> This allows you to automatically obtain an IP address.</p>
            <p id="dhcp_startip" style="display:none"> This allows you to set in a range of address for your connected. devices. Recommended is to use the default listed.</p>
			<p id="dhcp_endip" style="display:none"> This allows you to set in a range of address for your connected. devices. Recommended is to use the default listed.</p>
            <p id="dhcp_lease" style="display:none"> This is how long devices will hold on to an IP address before trying to acquire another(or the same one) from the router.</p>
            <p id="wan_wins" style="display:none"> Similar to netball name service, only add address if needed with pre-windows 2000 operating systems or operating systems that need WINS.</p>
          
            <p id="f_wl_radio" style="display:none"> Physical address of wireless interface, may need for certain security options.</p>
            <p id="f_wmode" style="display:none"> Sets which mode your wireless router will communicate as.</p>
            <p id="f_net_mode" style="display:none"> Sets which mode your router will use.  You can use mixed, B only or G only.  This  would depend on what type of wireless devices you have.</p>
            <p id="wl_ssid" style="display:none"> Sets what your wireless network will be called and broadcast as to allow you to  connect.</p>
            <p id="f_bcast" style="display:none"> Sets weather or not your Wireless router will broadcast your SSID which anyone with a  wireless card will be able to see if set.</p>
            <p id="wl_channel" style="display:none"> Sets the channel and  frequency your router will broadcast at.  You may also hit scan  to locate strongest channel nearest your location.</p>
            <p id="security_mode2" style="display:none"> Sets which type of  security setup you want to use. This will prevent unauthorized  individuals from connecting to your network even if they can see it. WPA is recommended for security.</p>
            <p id="wl_crypto" style="display:none"> Type of encryption that will be used over wireless link to prevent someone from  knowing your shared key.  AES or PKS Preshared Key is recommended for encryption.</p>
            <p id="wl_radius_key" style="display:none"> Password or set of characters that will be needed for computers in your network to  have to be able to connect to your wireless network.  More complex passwords are better as they are harder to break</p>
            <p id="wl_wpa_gtk_rekey" style="display:none"> Number of seconds before your computer renews authentication of the shared key.</p>
          </div></td>
        </tr>
      </table></td>
  </tr>
  <tr id="FooterRow">
  
  <td>
  
  <table cellpadding="0" cellspacing="0" border="0" width="100%" height="66" class="Footer" >
    <tbody>
      <tr >
        <td valign=top nowrap><a id="Footer_hlFooter1" href="http://www.ruraltelephone.com"><img src="FooterLogo1.gif" alt="" border="0" /></a> <a id="Footer_hlFooter2" onClick="window.open('','NewPopUpWindow','directories=no,height=600,width=800,location=no,resizable=yes,scrollbars=1,screenx=15,screeny=15,toolbar=no,opener=orig')" href="http://www.nextechdirectory.com" target="NewPopUpWindow"><img src="FooterLogo2.gif" alt="" border="0" /></a> <a id="Footer_hlFooter3" href="http://www.nex-tech.com/ebillsignup.aspx" target="_blank"><img src="FooterLogo3.gif" alt="" border="0" /></a> <a id="Footer_hlFooter4" href="http://www.nex-tech.com/Document.aspx?id=2764"><img src="FooterLogo4.gif" alt="" border="0" /></a> </td>
        <td valign=top align=right nowrap><a id="Footer_htFooter5" href="http://www.nex-tech.com" target="_blank"><img src="FooterLogo5.gif" alt="" border="0" /></a></td>
      </tr>
      <tr>
      
      <td valign=bottom colspan="2" width="100%">
      
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td valign=bottom class="CopyRight" nowrap>&nbsp;&nbsp;Copyright 2009 All Rights Reserved. Nex-Tech / A Rural Telephone Company. </td>
          <td valign=bottom class="CopyRight" align=right nowrap colspan="2">
        </td>
        </tr>
        <tr>
          <td colspan="3" class="Footer"></td>
        </tr>
      </table>
    </td>
    </tr>
    </tbody>
  </table>
  </td>
  </tr>
</table>
</body>
</HTML>
