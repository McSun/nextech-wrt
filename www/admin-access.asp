<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
textarea {
	width: 99%;
	height: 10em;
}
</style>
<script type='text/javascript'>
	
//	<% nvram("http_enable,https_enable,http_lanport,https_lanport,remote_management,remote_mgt_https,web_wl_filter,web_favicon,web_css,sshd_eas,sshd_pass,sshd_remote,telnetd_eas,http_wanport,sshd_authkeys,sshd_port,sshd_rport,telnetd_port,rmgt_sip,https_crt_cn,https_crt_save"); %>

changed = 0;
tdup = parseInt('<% psup("telnetd"); %>');
sdup = parseInt('<% psup("dropbear"); %>');

function toggle(service, isup)
{
	if (changed) {
		if (!confirm("Unsaved changes will be lost. Continue anyway?")) return;
	}
	E('_' + service + '_button').disabled = true;
	form.submitHidden('service.cgi', {
		_redirect: 'admin-access.asp',
		_sleep: ((service == 'sshd') && (!isup)) ? '7' : '3',
		_service: service + (isup ? '-stop' : '-start')
	});
}

function verifyFields(focused, quiet)
{
	var ok = 1;
	var a, b, c;

	try {
		a = E('_web_css').value;
		if (a != nvram.web_css) {
			E('guicss').href = a + '.css';
			nvram.web_css = a;
		}
	}
	catch (ex) {
	}

	a = E('_f_http_local');
	b = E('_f_http_remote').value;
	if ((a.value != 3) && (b != 0) && (a.value != b)) {
		ferror.set(a, 'The local http/https must also be enabled when using remote access.', quiet);
		ok = 0;
	}
	else {
		ferror.clear(a);
	}
	
	elem.display(PR('_http_lanport'), (a.value == 1) || (a.value == 3));

	c = (a.value == 2) || (a.value == 3);
	elem.display(PR('_https_lanport'), 'row_sslcert', PR('_https_crt_cn'), PR('_f_https_crt_save'), PR('_f_https_crt_gen'), c);

	if (c) {
		a = E('_https_crt_cn');
		a.value = a.value.replace(/(,+|\s+)/g, ' ').trim();
		if (a.value != nvram.https_crt_cn) E('_f_https_crt_gen').checked = 1;
	}

	if ((!v_port('_http_lanport', quiet)) || (!v_port('_https_lanport', quiet))) ok = 0;

	b = b != 0;
	a = E('_http_wanport');
	elem.display(PR(a), b);
	if ((b) && (!v_port(a, quiet))) ok = 0;

	if (!v_port('_telnetd_port', quiet)) ok = 0;

	a = E('_f_sshd_remote').checked;
	b = E('_sshd_rport');
	elem.display(PR(b), a);
	if ((a) && (!v_port(b, quiet))) ok = 0;

	a = E('_sshd_authkeys');
	if (!v_length(a, quiet, 0, 4096)) {
		ok = 0;
	}
	else if (a.value != '') {
        if (a.value.search(/^\s*ssh-(dss|rsa)/) == -1) {
			ferror.set(a, 'Invalid SSH key.', quiet);
			ok = 0;
		}
	}
	
	a = E('_rmgt_sip');
	if ((a.value.length) && (!v_iptip(a))) return 0;

	a = E('_set_password_1');
	b = E('_set_password_2');
	a.value = a.value.trim();
	b.value = b.value.trim();
	if (a.value != b.value) {
		ferror.set(b, 'Both passwords must match.', quiet);
		ok = 0;
	}
	else if (a.value == '') {
		ferror.set(a, 'Password must not be empty.', quiet);
		ok = 0;
	}
	else {
		ferror.clear(a);
		ferror.clear(b);
	}

	changed |= ok;
	return ok;
}

function save()
{
	var a, b, fom;

	if (!verifyFields(null, false)) return;

	fom = E('_fom');
	a = E('_f_http_local').value * 1;
	if (a == 0) {
		if (!confirm('Warning: Web Admin is about to be disabled. If you decide to re-enable Web Admin at a later time, it must be done manually via Telnet, SSH or by performing a hardware reset. Are you sure you want to do this?')) return;
		fom._nextpage.value = 'about:blank';
	}
	fom.http_enable.value = (a & 1) ? 1 : 0;
	fom.https_enable.value = (a & 2) ? 1 : 0;
	
	fom.https_crt_gen.value = a ? 1 : 0;
	fom.https_crt_save.value = E('_f_https_crt_save').checked ? 1 : 0;

	a = E('_f_http_remote').value;
	fom.remote_management.value = (a != 0) ? 1 : 0;
	fom.remote_mgt_https.value = (a == 2) ? 1 : 0;
	
	fom.web_wl_filter.value = E('_f_http_wireless').checked ? 0 : 1;
	fom.web_favicon.value = E('_f_favicon').checked ? 1 : 0;

	fom.telnetd_eas.value = E('_f_telnetd_eas').checked ? 1 : 0;

	fom.sshd_eas.value = E('_f_sshd_eas').checked ? 1 : 0;
	fom.sshd_pass.value = E('_f_sshd_pass').checked ? 1 : 0;
	fom.sshd_remote.value = E('_f_sshd_remote').checked ? 1 : 0;

	form.submit(fom, 0);
}

function init()
{
	changed = 0;
}
</script>
</HEAD>
<body onload="init()" style="WIDTH: 100%; HEIGHT: 100%" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0">
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
              <a id="Header_hlAbout" onMouseOver="ChangeLink(this,'over','Header_imgAbout');" onMouseOut="ChangeLink(this,'off','Header_imgAbout');" href="http://www.nex-tech.com/AboutNexTech.aspx" target="_blank">
	<font color="White" size="1"><img id="Header_imgAbout" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />About Nex-Tech&nbsp;</font></a>
	<a id="Header_hlContact" onMouseOver="ChangeLink(this,'over','Header_imgContact');" onMouseOut="ChangeLink(this,'off','Header_imgContact');" href="http://www.nex-tech.com/Document.aspx?mode=1&amp;id=2204" target="_blank"><font color="White" size="1"><img id="Header_imgContact" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Contact Us&nbsp;</font></a>
	<a id="Header_hlNews" onMouseOver="ChangeLink(this,'over','Header_imgNews');" onMouseOut="ChangeLink(this,'off','Header_imgNews');" href="http://www.nex-tech.com/Document.aspx?id=2107" target="_blank"><font color="White" size="1" target="_blank"><img id="Header_imgNews" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Internet Solutions&nbsp;</font></a><a id="Header_hlEmployment" onMouseOver="ChangeLink(this,'over','Header_imgEmploy');" onMouseOut="ChangeLink(this,'off','Header_imgEmploy');" href="http://www.nex-tech.com/Document.aspx?id=2832" target="_blank"><font color="White" size="1"><img id="Header_imgEmploy" src="HeaderButtonOff.gif" alt="" align="AbsMiddle" border="0" />Tech Support&nbsp;&nbsp;</font></a> </div></td>
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

							<input type='hidden' name='_nextpage' value='admin-access.asp'>
							<input type='hidden' name='_nextwait' value='10'>
							<input type='hidden' name='_service' value='admin-restart'>

							<input type='hidden' name='http_enable'>
							<input type='hidden' name='https_enable'>
							<input type='hidden' name='https_crt_save'>
							<input type='hidden' name='https_crt_gen'>
							<input type='hidden' name='remote_management'>
							<input type='hidden' name='remote_mgt_https'>
							<input type='hidden' name='web_wl_filter'>
							<input type='hidden' name='web_favicon'>
							<input type='hidden' name='telnetd_eas'>
							<input type='hidden' name='sshd_eas'>
							<input type='hidden' name='sshd_pass'>
							<input type='hidden' name='sshd_remote'>


							<div class='section-title'>Web Admin</div>
							<div class='section'>
							<script type='text/javascript'>
							createFieldTable('', [
								{ title: 'Local Access', name: 'f_http_local', type: 'select', options: [[0,'Disabled'],[1,'HTTP'],[2,'HTTPS'],[3,'HTTP &amp; HTTPS']],
									value: ((nvram.https_enable != 0) ? 2 : 0) | ((nvram.http_enable != 0) ? 1 : 0) },
								{ title: 'HTTP Port', indent: 2, name: 'http_lanport', type: 'text', maxlen: 5, size: 7, value: fixPort(nvram.http_lanport, 80) },
								{ title: 'HTTPS Port', indent: 2, name: 'https_lanport', type: 'text', maxlen: 5, size: 7, value: fixPort(nvram.https_lanport, 443) },
								{ title: 'SSL Certificate', rid: 'row_sslcert' },
								{ title: 'Common Name (CN)', indent: 2, name: 'https_crt_cn', type: 'text', maxlen: 64, size: 64, value: nvram.https_crt_cn,
									suffix: '&nbsp;<small>(optional; space separated)</small>' },
								{ title: 'Regenerate', indent: 2, name: 'f_https_crt_gen', type: 'checkbox', value: 0 },
								{ title: 'Save In NVRAM', indent: 2, name: 'f_https_crt_save', type: 'checkbox', value: nvram.https_crt_save == 1 },
								{ title: 'Remote Access', name: 'f_http_remote', type: 'select', options: [[0,'Disabled'],[1,'HTTP'],[2,'HTTPS']],
									value:  (nvram.remote_management == 1) ? ((nvram.remote_mgt_https == 1) ? 2 : 1) : 0 },
								{ title: 'Port', indent: 2, name: 'http_wanport', type: 'text', maxlen: 5, size: 7, value:  fixPort(nvram.http_wanport, 8080) },
								{ title: 'Allow Wireless Access', name: 'f_http_wireless', type: 'checkbox', value:  nvram.web_wl_filter == 0 },
								null,
								{ title: 'Color Scheme', name: 'web_css', type: 'select',
									options: [['red','Tomato'],['black','Black'],['blue','Blue'],['bluegreen','Blue &amp; Green (Lighter)'],['bluegreen2','Blue &amp; Green (Darker)'],['brown','Brown'],['cyan','Cyan'],['olive','Olive'],['pumpkin','Pumpkin'],['ext/custom','Custom (ext/custom.css)']], value: nvram.web_css },
								{ title: 'Show Browser Icon', name: 'f_favicon', type: 'checkbox', value:  nvram.web_favicon == 1 }
							]);
							</script>
							</div>

							<div class='section-title'>SSH Daemon</div>
							<div class='section'>
							<script type='text/javascript'>
							createFieldTable('', [
								{ title: 'Enable at Startup', name: 'f_sshd_eas', type: 'checkbox', value: nvram.sshd_eas == 1 },
								{ title: 'Remote Access', name: 'f_sshd_remote', type: 'checkbox', value: nvram.sshd_remote == 1 },
								{ title: 'Remote Port', indent: 2, name: 'sshd_rport', type: 'text', maxlen: 5, size: 7, value: nvram.sshd_rport },
								{ title: 'Port', name: 'sshd_port', type: 'text', maxlen: 5, size: 7, value: nvram.sshd_port },
								{ title: 'Allow Password Login', name: 'f_sshd_pass', type: 'checkbox', value: nvram.sshd_pass == 1 },
								{ title: 'Authorized Keys', name: 'sshd_authkeys', type: 'textarea', value: nvram.sshd_authkeys }
							]);
							W('<input type="button" value="' + (sdup ? 'Stop' : 'Start') + ' Now" onclick="toggle(\'sshd\', sdup)" id="_sshd_button">');
							</script>
							</div>

							<div class='section-title'>Remote Web/SSH Admin Restriction</div>
							<div class='section'>
							<script type='text/javascript'>
							createFieldTable('', [
								{ title: 'Allowed IP Address', name: 'rmgt_sip', type: 'text', maxlen: 32, size: 32, value: nvram.rmgt_sip,
									suffix: '&nbsp;<small>(optional; ex: "1.1.1.1", "1.1.1.0/24" or "1.1.1.1 - 2.2.2.2")</small>' }
							]);
							</script>
							</div>

							<div class='section-title'>Telnet Daemon</div>
							<div class='section'>
							<script type='text/javascript'>
							createFieldTable('', [
								{ title: 'Enable at Startup', name: 'f_telnetd_eas', type: 'checkbox', value: nvram.telnetd_eas == 1 },
								{ title: 'Port', name: 'telnetd_port', type: 'text', maxlen: 5, size: 7, value: nvram.telnetd_port }
							]);
							W('<input type="button" value="' + (tdup ? 'Stop' : 'Start') + ' Now" onclick="toggle(\'telnetd\', tdup)" id="_telnetd_button">');
							</script>
							</div>

							<div class='section-title'>Password</div>
							<div class='section'>
							<script type='text/javascript'>
							createFieldTable('', [
								{ title: 'Password', name: 'set_password_1', type: 'password', value: '**********' },
								{ title: '<i>(re-enter to confirm)</i>', indent: 2, name: 'set_password_2', type: 'password', value: '**********' }
							]);
							</script>
							</div>

							<!-- / / / -->
						
					
							<span id='footer-msg'></span>
							<input type='button' value='Save' id='save-button' onclick='save()'>
							<input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
							
							</form>
							<script type='text/javascript'>verifyFields(null, 1);</script>
					
					</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
              <table id="DefaultRightColumn_Table1" class="RightColumn" cellspacing="0" cellpadding="10" border="0" style="WIDTH: 5%; HEIGHT: 100%">
                <tr id="DefaultRightColumn_TableRow3">
                  <td id="DefaultRightColumn_TableCell3" style="WIDTH: 166px; HEIGHT: 10px"></td>
                </tr>
                <tr id="DefaultRightColumn_TableRow1">
                  <td id="DefaultRightColumn_TableCell1" align="Center" valign="Top" style="WIDTH: 166px; HEIGHT: 100%"></td>
                </tr>
                <tr id="DefaultRightColumn_TableRow2">
                  <td id="DefaultRightColumn_TableCell2" align="Center" valign="Middle" style="WIDTH: 166px; HEIGHT: 100%"></td>
                </tr>
              </table>
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
          <td valign=bottom class="CopyRight" align=right nowrap colspan="2"
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
