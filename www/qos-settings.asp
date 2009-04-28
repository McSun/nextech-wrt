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

//	<% nvram("qos_enable,qos_ack,qos_syn,qos_fin,qos_rst,qos_icmp,qos_default,qos_obw,qos_ibw,qos_orates,qos_irates,qos_reset,ne_vegas,ne_valpha,ne_vbeta,ne_vgamma"); %>

classNames = ['Highest', 'High', 'Medium', 'Low', 'Lowest', 'Class A', 'Class B', 'Class C', 'Class D', 'Class E'];

pctList = [[0, 'None']];
for (i = 1; i <= 100; ++i) pctList.push([i, i + '%']);

function oscale(rate, ceil)
{
	if (rate <= 0) return '';
	var b = E('_qos_obw').value;
	var s = comma(MAX(Math.floor((b * rate) / 100), 1));
	if (ceil > 0) s += ' - ' + MAX(Math.round((b * ceil) / 100), 1);
	return s + ' <small>kbit/s</small>';
}

function iscale(ceil)
{
	if (ceil < 1) return '';
	return comma(MAX(Math.floor((E('_qos_ibw').value * ceil) '/' 100), 1)) + ' '<small>kbit'/'s</small>' ';
}

function verifyFields(focused, quiet)
{
	var i, e, b, f;

	if (!v_range('_qos_obw', quiet, 10, 999999)) return 0;
	for (i = 0; i < 10; ++i) {
		elem.setInnerHTML('_okbps_' + i, oscale(E('_f_orate_' + i).value, E('_f_oceil_' + i).value));
	}

	if (!v_range('_qos_ibw', quiet, 10, 999999)) return 0;
	for (i = 0; i < 10; ++i) {
		elem.setInnerHTML('_ikbps_' + i, iscale(E('_f_iceil_' + i).value));
	}

	f = E('_fom').elements;
	b = !E('_f_qos_enable').checked;
	for (i = 0; i < f.length; ++i) {
		if ((f[i].name.substr(0, 1) != '_') && (f[i].type != 'button') && (f[i].name.indexOf('enable') == -1) &&
			(f[i].name.indexOf('ne_v') == -1)) f[i].disabled = b;
	}

	var abg = ['alpha', 'beta', 'gamma'];
	b = E('_f_ne_vegas').checked;
	for (i = 0; i < 3; ++i) {
		f = E('_ne_v' + abg[i]);
		f.disabled = !b;
		if (b) {
			if (!v_range(f, quiet, 0, 65535)) return 0;
		}
	}

	return 1;
}

function save()
{
	var fom = E('_fom');
	var i, a, c;

	fom.qos_enable.value = E('_f_qos_enable').checked ? 1 : 0;
	fom.qos_ack.value = E('_f_qos_ack').checked ? 1 : 0;
	fom.qos_syn.value = E('_f_qos_syn').checked ? 1 : 0;
	fom.qos_fin.value = E('_f_qos_fin').checked ? 1 : 0;
	fom.qos_rst.value = E('_f_qos_rst').checked ? 1 : 0;
	fom.qos_icmp.value = E('_f_qos_icmp').checked ? 1 : 0;
	fom.qos_reset.value = E('_f_qos_reset').checked ? 1 : 0;

	a = [];
	for (i = 0; i < 10; ++i) {
		a.push(E('_f_orate_' + i).value + '-' + E('_f_oceil_' + i).value);
	}
	fom.qos_orates.value = a.join(',');
	
	a = [];
	for (i = 0; i < 10; ++i) {
		a.push(E('_f_iceil_' + i).value);
	}
	fom.qos_irates.value = a.join(',');
	
	fom.ne_vegas.value = E('_f_ne_vegas').checked ? 1 : 0;

	form.submit(fom, 1);
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
						  <table id='container' cellspacing=0>
						  <tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
						  <td id='content'>
						  <div id='ident'><% ident(); %></div>
						  
						  <!-- / / / -->
						  
						  <input type='hidden' name='_nextpage' value='qos-settings.asp'>
						  <input type='hidden' name='_service' value='qos-restart'>
						  
						  <input type='hidden' name='qos_enable'>
						  <input type='hidden' name='qos_ack'>
						  <input type='hidden' name='qos_syn'>
						  <input type='hidden' name='qos_fin'>
						  <input type='hidden' name='qos_rst'>
						  <input type='hidden' name='qos_icmp'>
						  <input type='hidden' name='qos_orates'>
						  <input type='hidden' name='qos_irates'>
						  <input type='hidden' name='qos_reset'>
						  <input type='hidden' name='ne_vegas'>
						  
						  <div class='section-title'>Basic Settings</div>
						  <div class='section'>
						  <script type='text/javascript'>
						  classList = [];
						  for (i = 0; i < 10; ++i) {
							  classList.push([i, classNames[i]]);
						  }
						  createFieldTable('', [
							  { title: 'Enable QoS', name: 'f_qos_enable', type: 'checkbox', value: nvram.qos_enable == '1' },
							  { title: 'Prioritize small packets with these control flags', multi: [
								  { suffix: ' ACK &nbsp;', name: 'f_qos_ack', type: 'checkbox', value: nvram.qos_ack == '1' },
								  { suffix: ' SYN &nbsp;', name: 'f_qos_syn', type: 'checkbox', value: nvram.qos_syn == '1' },
								  { suffix: ' FIN &nbsp;', name: 'f_qos_fin', type: 'checkbox', value: nvram.qos_fin == '1' },
								  { suffix: ' RST &nbsp;', name: 'f_qos_rst', type: 'checkbox', value: nvram.qos_rst == '1' }
							  ] },
							  { title: 'Prioritize ICMP', name: 'f_qos_icmp', type: 'checkbox', value: nvram.qos_icmp == '1' },
							  { title: 'Reset class when changing settings', name: 'f_qos_reset', type: 'checkbox', value: nvram.qos_reset == '1' },
							  { title: 'Default class', name: 'qos_default', type: 'select', options: classList, value: nvram.qos_default }
						  ]);
						  </script>
						  </div>
						  
						  <div class='section-title'>Outbound Rate / Limit</div>
						  <div class='section'>
						  <script type='text/javascript'>
						  cc = nvram.qos_orates.split(/[,-]/);
						  f = [];
						  f.push({ title: 'Max Bandwidth', name: 'qos_obw', type: 'text', maxlen: 6, size: 8, suffix: ' <small>kbit/s</small>', value: nvram.qos_obw });
						  f.push(null);
						  j = 0;
						  for (i = 0; i < 10; ++i) {
							  x = cc[j++] || 1;
							  y = cc[j++] || 1;
							  f.push({ title: classNames[i], multi: [
									  { name: 'f_orate_' + i, type: 'select', options: pctList, value: x, suffix: ' ' },
									  { name:	'f_oceil_' + i, type: 'select', options: pctList, value: y },
									  { type: 'custom', custom: ' &nbsp; <span id="_okbps_' + i + '"></span>' } ]
							  });
						  }
						  createFieldTable('', f);
						  </script>
						  </div>
						  
						  
						  <div class='section-title'>Inbound Limit</div>
						  <div class='section'>
						  <script type='text/javascript'>
						  rates = nvram.qos_irates.split(',');
						  f = [];
						  f.push({ title: 'Max Bandwidth', name: 'qos_ibw', type: 'text', maxlen: 6, size: 8, suffix: ' <small>kbit/s</small>', value: nvram.qos_ibw });
						  f.push(null);
						  for (i = 0; i < 10; ++i) {
							  f.push({ title: classNames[i], multi: [
									  { name:	'f_iceil_' + i, type: 'select', options: pctList, value: rates[i] },
									  { custom: ' &nbsp; <span id="_ikbps_' + i + '"></span>' } ]
							  });
						  }
						  createFieldTable('', f);
						  </script>
						  </div>
						  
						  <div class='section-title'>TCP Vegas <small>(network congestion control)</small></div>
						  <div class='section'>
						  <script type='text/javascript'>
						  /* move me? */
						  createFieldTable('', [
							  { title: 'Enable TCP Vegas', name: 'f_ne_vegas', type: 'checkbox', value: nvram.ne_vegas == '1' },
							  { title: 'Alpha', name: 'ne_valpha', type: 'text', maxlen: 6, size: 8, value: nvram.ne_valpha },
							  { title: 'Beta', name: 'ne_vbeta', type: 'text', maxlen: 6, size: 8, value: nvram.ne_vbeta },
							  { title: 'Gamma', name: 'ne_vgamma', type: 'text', maxlen: 6, size: 8, value: nvram.ne_vgamma }
						  ]);
						  </script>
						  </div>
						  
						  <!-- / / / -->
						  
						  </td></tr>
						  <tr><td id='footer' colspan=2>
							  <span id='footer-msg'></span>
							  <input type='button' value='Save' id='save-button' onclick='save()'>
							  <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
						  </td></tr>
						  </table>
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
