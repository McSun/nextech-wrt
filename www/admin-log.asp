<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<script type='text/javascript'>

//	<% nvram("log_remote,log_remoteip,log_remoteport,log_file,log_limit,log_in,log_out,log_mark,log_events"); %>

function verifyFields(focused, quiet)
{
	var a, b;
	
	a = E('_f_log_file').checked;
	b = E('_f_log_remote').checked;

	a = !(a || b);
	E('_log_in').disabled = a;
	E('_log_out').disabled = a;
	E('_log_limit').disabled = a;	
	E('_log_mark').disabled = a;
	E('_f_log_acre').disabled = a;	
	E('_f_log_crond').disabled = a;
	E('_f_log_dhcpc').disabled = a;
	E('_f_log_ntp').disabled = a;	
	E('_f_log_pppoe').disabled = a;
	E('_f_log_sched').disabled = a;	

	elem.display(PR('_log_remoteip'), b);
	E('_log_remoteip').disabled = !b;
	E('_log_remoteport').disabled = !b;
	
	if (a) return 1;
	
	if (!v_range('_log_limit', quiet, 0, 2400)) return 0;
	if (!v_range('_log_mark', quiet, 0, 1440)) return 0;
	if (b) {
		if ((!v_ip('_log_remoteip', quiet)) || (!v_port('_log_remoteport', quiet))) return 0;
	}
	return 1;
}

function save()
{
	var a, fom;

	if (!verifyFields(null, false)) return;

	fom = E('_fom');
	fom.log_remote.value = E('_f_log_remote').checked ? 1 : 0;
	fom.log_file.value = E('_f_log_file').checked ? 1 : 0;
	
	a = [];
	if (E('_f_log_acre').checked) a.push('acre');
	if (E('_f_log_crond').checked) a.push('crond');
	if (E('_f_log_dhcpc').checked) a.push('dhcpc');
	if (E('_f_log_ntp').checked) a.push('ntp');
	if (E('_f_log_pppoe').checked) a.push('pppoe');
	if (E('_f_log_sched').checked) a.push('sched');
	fom.log_events.value = a.join(',');
	
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
                        
                        <input type='hidden' name='_nextpage' value='admin-log.asp'>
                        <input type='hidden' name='_service' value='logging-restart'>
                        
                        <input type='hidden' name='log_remote'>
                        <input type='hidden' name='log_file'>
                        <input type='hidden' name='log_events'>
                        
                        <script type='text/javascript'>
                        </script>
                        
                        <div class='section-title'>Syslog</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        
                        // adjust (>=1.22)
                        nvram.log_mark *= 1;
                        if (nvram.log_mark >= 120) nvram.log_mark = 120;
                            else if (nvram.log_mark >= 60) nvram.log_mark = 60;
                            else if (nvram.log_mark > 0) nvram.log_mark = 30;
                            else nvram.log_mark = 0;
                        
                        createFieldTable('', [
                            { title: 'Log Internally', name: 'f_log_file', type: 'checkbox', value: nvram.log_file == 1 },
                            { title: 'Log to Remote System', name: 'f_log_remote', type: 'checkbox', value: nvram.log_remote == 1 },
                            { title: 'IP Address / Port', indent: 2, multi: [
                                { name: 'log_remoteip', type: 'text', maxlen: 15, size: 17, value: nvram.log_remoteip, suffix: ':' },
                                { name: 'log_remoteport', type: 'text', maxlen: 5, size: 7, value: nvram.log_remoteport } ]},
                            { title: 'Generate Marker', name: 'log_mark', type: 'select', options: [[0,'Disabled'],[30,'Every 30 Minutes'],[60,'Every 1 Hour'],[120,'Every 2 Hours']], value: nvram.log_mark },
                            { title: 'Events Logged', text: '<small>(some of the changes will take effect after a restart)</small>' },
                                { title: 'Access Restriction De/Activiation', indent: 2, name: 'f_log_acre', type: 'checkbox', value: (nvram.log_events.indexOf('acre') != -1) },
                                { title: 'Cron', indent: 2, name: 'f_log_crond', type: 'checkbox', value: (nvram.log_events.indexOf('crond') != -1) },
                                { title: 'DHCP Client', indent: 2, name: 'f_log_dhcpc', type: 'checkbox', value: (nvram.log_events.indexOf('dhcpc') != -1) },
                                { title: 'NTP', indent: 2, name: 'f_log_ntp', type: 'checkbox', value: (nvram.log_events.indexOf('ntp') != -1) },
                                { title: 'PPPoE', indent: 2, name: 'f_log_pppoe', type: 'checkbox', value: (nvram.log_events.indexOf('pppoe') != -1) },
                                { title: 'Scheduler', indent: 2, name: 'f_log_sched', type: 'checkbox', value: (nvram.log_events.indexOf('sched') != -1) },
                            { title: 'Connection Logging' },
                                { title: 'Inbound Connection', indent: 2, name: 'log_in', type: 'select', options: [[0,'Disabled (recommended)'],[1,'If Blocked By Firewall'],[2,'If Allowed By Firewall'],[3,'Both']], value: nvram.log_in },
                                { title: 'Outbound Connection', indent: 2, name: 'log_out', type: 'select', options: [[0,'Disabled (recommended)'],[1,'If Blocked By Firewall'],[2,'If Allowed By Firewall'],[3,'Both']], value: nvram.log_out },
                                { title: 'Limit Logging', indent: 2, name: 'log_limit', type: 'text', maxlen: 4, size: 5, value: nvram.log_limit, suffix: ' <small>(messages per minute / 0 for unlimited)</small>' }
                        ]);
                        </script>
                        </div>
                        
                        <!-- / / / -->
                        
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
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
