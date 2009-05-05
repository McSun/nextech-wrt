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

//	<% nvram("security_mode,wl_afterburner,wl_antdiv,wl_ap_isolate,wl_auth,wl_bcn,wl_dtim,wl_frag,wl_frameburst,wl_gmode_protection,wl_plcphdr,wl_rate,wl_rateset,wl_rts,wl_txant,wl_wme,wl_wme_no_ack,wl_txpwr,wl_mrate,t_features,wl_distance,wl_maxassoc,wlx_hpamp,wlx_hperx"); %>

hp = features('hpamp');

function verifyFields(focused, quiet)
{
	if (!v_range('_f_distance', quiet, 0, 99999)) return 0;
	if (!v_range('_wl_maxassoc', quiet, 0, 255)) return 0;
	if (!v_range('_wl_bcn', quiet, 1, 65535)) return 0;
	if (!v_range('_wl_dtim', quiet, 1, 255)) return 0;
	if (!v_range('_wl_frag', quiet, 256, 2346)) return 0;
	if (!v_range('_wl_rts', quiet, 0, 2347)) return 0;
	if (!v_range(E('_wl_txpwr'), quiet, 1, 251)) return 0;

	E('_wl_wme_no_ack').disabled = E('_wl_wme').selectedIndex != 1;
	return 1;
}

function save()
{
	var fom;
	var n;

	if (!verifyFields(null, false)) return;
	
	fom = E('_fom');
	n = fom._f_distance.value * 1;
	fom.wl_distance.value = n ? n : '';
	
	if (hp) {
		if ((fom.wlx_hpamp.value != nvram.wlx_hpamp) || (fom.wlx_hperx.value != nvram.wlx_hperx)) {
			fom._service.disabled = 1;
			fom._reboot.value = 1;
			form.submit(fom, 0);
			return;
		}
	}
	else {
		fom.wlx_hpamp.disabled = 1;
		fom.wlx_hperx.disabled = 1;
	}
	
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
                        
                        <!-- / / / -->
                        
                        <input type='hidden' name='_nextpage' value='advanced-wireless.asp'>
                        <input type='hidden' name='_nextwait' value='10'>
                        <input type='hidden' name='_service' value='*'>
                        <input type='hidden' name='_reboot' value='0'>
                        
                        <input type='hidden' name='wl_distance'>
                        
                        <div class='section-title'>Settings</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        at = ((nvram.security_mode != "wep") && (nvram.security_mode != "radius") && (nvram.security_mode != "disabled"));
                        createFieldTable('', [
                            { title: 'Afterburner', name: 'wl_afterburner', type: 'select', options: [['auto','Auto'],['on','Enable'],['off','Disable *']],
                                value: nvram.wl_afterburner },
                            { title: 'AP Isolation', name: 'wl_ap_isolate', type: 'select', options: [['0','Disable *'],['1','Enable']],
                                value: nvram.wl_ap_isolate },
                            { title: 'Authentication Type', name: 'wl_auth', type: 'select',
                                options: [['0','Auto *'],['1','Shared Key']], attrib: at ? 'disabled' : '',
                                value: at ? 0 : nvram.wl_auth },
                            { title: 'Basic Rate', name: 'wl_rateset', type: 'select', options: [['default','Default *'],['12','1-2 Mbps'],['all','All']],
                                value: nvram.wl_rateset },
                            { title: 'Beacon Interval', name: 'wl_bcn', type: 'text', maxlen: 5, size: 7,
                                suffix: ' <small>(range: 1 - 65535; default: 100)</small>', value: nvram.wl_bcn },
                            { title: 'CTS Protection Mode', name: 'wl_gmode_protection', type: 'select', options: [['off','Disable *'],['auto','Auto']],
                                value: nvram.wl_gmode_protection },
                            { title: 'Distance / ACK Timing', name: 'f_distance', type: 'text', maxlen: 5, size: 7,
                                suffix: ' <small>meters</small>&nbsp;&nbsp;<small>(range: 0 - 99999; 0 = use default)</small>',
                                    value: (nvram.wl_distance == '') ? '0' : nvram.wl_distance },
                            { title: 'DTIM Interval', name: 'wl_dtim', type: 'text', maxlen: 3, size: 5,
                                suffix: ' <small>(range: 1 - 255; default: 1)</small>', value: nvram.wl_dtim },
                            { title: 'Fragmentation Threshold', name: 'wl_frag', type: 'text', maxlen: 4, size: 6,
                                suffix: ' <small>(range: 256 - 2346; default: 2346)</small>', value: nvram.wl_frag },
                            { title: 'Frame Burst', name: 'wl_frameburst', type: 'select', options: [['off','Disable *'],['on','Enable']],
                                value: nvram.wl_frameburst },
                            { title: 'HP', hidden: !hp },
                                { title: 'Amplifier', indent: 2, name: 'wlx_hpamp', type: 'select', options: [['0','Disable'],['1','Enable *']],
                                    value: nvram.wlx_hpamp != '0', hidden: !hp },
                                { title: 'Enhanced RX Sensitivity', indent: 2, name: 'wlx_hperx', type: 'select', options: [['0','Disable *'],['1','Enable']],
                                    value: nvram.wlx_hperx != '0', hidden: !hp },
                            { title: 'Maximum Clients', name: 'wl_maxassoc', type: 'text', maxlen: 3, size: 5,
                                suffix: ' <small>(range: 1 - 255; default: 128)</small>', value: nvram.wl_maxassoc },
                            { title: 'Multicast Rate', name: 'wl_mrate', type: 'select',
                                options: [['0','Auto *'],['1000000','1 Mbps'],['2000000','2 Mbps'],['5500000','5.5 Mbps'],['6000000','6 Mbps'],['9000000','9 Mbps'],['11000000','11 Mbps'],['12000000','12 Mbps'],['18000000','18 Mbps'],['24000000','24 Mbps'],['36000000','36 Mbps'],['48000000','48 Mbps'],['54000000','54 Mbps']],
                                value: nvram.wl_mrate },
                            { title: 'Preamble', name: 'wl_plcphdr', type: 'select', options: [['long','Long *'],['short','Short']],
                                value: nvram.wl_plcphdr },
                            { title: 'RTS Threshold', name: 'wl_rts', type: 'text', maxlen: 4, size: 6,
                                suffix: ' <small>(range: 0 - 2347; default: 2347)</small>', value: nvram.wl_rts },
                            { title: 'Receive Antenna', name: 'wl_antdiv', type: 'select', options: [['3','Auto *'],['1','A'],['0','B']],
                                value: nvram.wl_antdiv },
                            { title: 'Transmit Antenna', name: 'wl_txant', type: 'select', options: [['3','Auto *'],['1','A'],['0','B']],
                                value: nvram.wl_txant },
                            { title: 'Transmit Power', name: 'wl_txpwr', type: 'text', maxlen: 3, size: 5,
                                suffix: hp ?
                                    ' <small>mW (before amplification)</small>&nbsp;&nbsp;<small>(range: 1 - 251; default: 10)</small>' :
                                    ' <small>mW</small>&nbsp;&nbsp;<small>(range: 1 - 251; default: 42)</small>',
                                    value: nvram.wl_txpwr },
                            { title: 'Transmission Rate', name: 'wl_rate', type: 'select',
                                options: [['0','Auto *'],['1000000','1 Mbps'],['2000000','2 Mbps'],['5500000','5.5 Mbps'],['6000000','6 Mbps'],['9000000','9 Mbps'],['11000000','11 Mbps'],['12000000','12 Mbps'],['18000000','18 Mbps'],['24000000','24 Mbps'],['36000000','36 Mbps'],['48000000','48 Mbps'],['54000000','54 Mbps']],
                                value: nvram.wl_rate },
                            { title: 'WMM', name: 'wl_wme', type: 'select', options: [['off','Disable *'],['on','Enable']], value: nvram.wl_wme },
                            { title: 'No ACK', name: 'wl_wme_no_ack', indent: 2, type: 'select', options: [['off','Disable *'],['on','Enable']],
                                value: nvram.wl_wme_no_ack }
                        ]);
                        </script>
                        </div>
                        <small>The default settings are indicated with the asterisk <b style='font-size: 1.5em'>*</b> symbol.</small>
                        
                        <!-- / / / -->
                        
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
                        <script type='text/javascript'>verifyFields(null, 1);</script>				
					</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
            <h3>Brainy Bunch Help</h3>
            <p>Setup Advanced Wireless Settings, for  advanced users only.  Defaults are recommended.</p>
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
