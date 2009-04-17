<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<script type='text/javascript'>

//	<% nvram("tm_sel,tm_dst,tm_tz,ntp_updates,ntp_server,ntp_tdod,ntp_kiss"); %>


var ntpList = [
	['custom', 'Custom...'],
	['', 'Default'],
	['africa', 'Africa'],
	['asia', 'Asia'],
	['europe', 'Europe'],
	['oceania', 'Oceania'],
	['north-america', 'North America'],
	['south-america', 'South America'],
	['us', 'US']
];

/* REMOVE-BEGIN
var ntpList = [
	['custom', 'Custom'],
	['', 'pool.ntp.org'],
	['africa', 'africa.pool.ntp.org'],
	['asia', 'asia.pool.ntp.org'],
	['europe', 'europe.pool.ntp.org'],
	['oceania', 'oceania.pool.ntp.org'],
	['north-america', 'north-america.pool.ntp.org'],
	['south-america', 'south-america.pool.ntp.org'],
	['us', 'us.pool.ntp.org']
];
REMOVE-END */

function ntpString(name)
{
	if (name == '') name = 'pool.ntp.org';
		else name = name + '.pool.ntp.org';
	return '0.' + name + ' 1.' + name + ' 2.' + name;
}

function verifyFields(focused, quiet)
{
	var ok = 1;

	var s = E('_tm_sel').value;
	var f_dst = E('_f_tm_dst');
	var f_tz = E('_f_tm_tz');
	if (s == 'custom') {
		f_dst.disabled = true;
		f_tz.disabled = false;
		PR(f_dst).style.display = 'none';
		PR(f_tz).style.display = '';
	}
	else {
		f_tz.disabled = true;
		PR(f_tz).style.display = 'none';
		PR(f_dst).style.display = '';
		if (s.match(/^([A-Z]+[\d:-]+)[A-Z]+/)) {
			if (!f_dst.checked) s = RegExp.$1;
			f_dst.disabled = false;
		}
		else {
			f_dst.disabled = true;
		}
		f_tz.value = s;
	}

	var a = 1;
	var b = 1;
	switch (E('_ntp_updates').value * 1) {
	case -1:
		b = 0;
	case 0:
		a = 0;
		break;
	}
	elem.display(PR('_f_ntp_tdod'), a);

	elem.display(PR('_f_ntp_server'), b);
	a = (E('_f_ntp_server').value == 'custom');
	elem.display(PR('_f_ntp_1'), PR('_f_ntp_2'), PR('_f_ntp_3'), a && b);

	elem.display(PR('ntp-preset'), !a && b);

	if (a) {
		if ((E('_f_ntp_1').value == '') && (E('_f_ntp_2').value == '') && ((E('_f_ntp_3').value == ''))) {
			ferror.set('_f_ntp_1', 'At least one NTP server is required', quiet);
			return 0;
		}
	}
	else {
		E('ntp-preset').innerHTML = ntpString(E('_f_ntp_server').value).replace(/\s+/, ', ');
	}

	ferror.clear('_f_ntp_1');
	return 1;
}

function save(clearKiss)
{
	if (!verifyFields(null, 0)) return;

	var fom, a, i;

	fom = E('_fom');
	fom.tm_dst.value = fom.f_tm_dst.checked ? 1 : 0;
	fom.tm_tz.value = fom.f_tm_tz.value;

	if (E('_f_ntp_server').value != 'custom') {
		fom.ntp_server.value = ntpString(E('_f_ntp_server').value);
	}
	else {
		a = [fom.f_ntp_1.value, fom.f_ntp_2.value, fom.f_ntp_3.value];
		for (i = 0; i < a.length; ) {
			if (a[i] == '') a.splice(i, 1);
				else ++i;
		}
		fom.ntp_server.value = a.join(' ');
	}

	fom.ntp_tdod.value = fom.f_ntp_tdod.checked ? 1 : 0;
	fom.ntp_kiss.disabled = !clearKiss;
	form.submit(fom);
}

function earlyInit()
{
	if (nvram.ntp_kiss != '') {
		E('ntpkiss-ip').innerHTML = nvram.ntp_kiss;
		E('ntpkiss').style.display = '';
	}
	verifyFields(null, 1);
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
                        
                        <input type='hidden' name='_nextpage' value='basic-time.asp'>
                        <input type='hidden' name='_nextwait' value='5'>
                        <input type='hidden' name='_service' value='ntpc-restart'>
                        <input type='hidden' name='_sleep' value='3'>
                        
                        <input type='hidden' name='tm_dst'>
                        <input type='hidden' name='tm_tz'>
                        <input type='hidden' name='ntp_server'>
                        <input type='hidden' name='ntp_tdod'>
                        <input type='hidden' name='ntp_kiss' value='' disabled>
                        
                        
                        <div class='section-title'>Time</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        
                        ntp = nvram.ntp_server.split(/\s+/);
                        
                        ntpSel = 'custom';
                        for (i = ntpList.length - 1; i > 0; --i) {
                            if (ntpString(ntpList[i][0]) == nvram.ntp_server) ntpSel = ntpList[i][0];
                        }
                                        
                        createFieldTable('', [
                            { title: 'Router Time', text: '<span id="clock"><% time(); %></span>' },
                            null,
                            { title: 'Time Zone', name: 'tm_sel', type: 'select', options: [
                                ['custom','Custom...'],
                                ['UTC12','UTC-12:00 Kwajalein'],
                                ['UTC11','UTC-11:00 Midway Island, Samoa'],
                                ['UTC10','UTC-10:00 Hawaii'],
                                ['NAST9NADT,M3.2.0/2,M11.1.0/2','UTC-09:00 Alaska'],
                                ['PST8PDT,M3.2.0/2,M11.1.0/2','UTC-08:00 Pacific Time'],
                                ['UTC7','UTC-07:00 Arizona'],
                                ['MST7MDT,M3.2.0/2,M11.1.0/2','UTC-07:00 Mountain Time'],
                                ['UTC6','UTC-06:00 Mexico'],
                                ['CST6CDT,M3.2.0/2,M11.1.0/2','UTC-06:00 Central Time'],
                                ['UTC5','UTC-05:00 Colombia, Panama'],
                                ['EST5EDT,M3.2.0/2,M11.1.0/2','UTC-05:00 Eastern Time'],
                                ['VET4:30','UTC-04:30 Venezuela'],
                                ['BOT4','UTC-04:00 Bolivia'],
                                ['AST4ADT,M3.2.0/2,M11.1.0/2','UTC-04:00 Atlantic Time'],
                                ['BRWST4BRWDT,M10.3.0/0,M2.5.0/0','UTC-04:00 Brazil West'],
                                ['NST3:30NDT,M3.2.0/0:01,M11.1.0/0:01','UTC-03:30 Newfoundland'],
                                ['WGST3WGDT,M3.5.6/22,M10.5.6/23','UTC-03:00 Greenland'],
                                ['BRST3BRDT,M10.3.0/0,M2.5.0/0','UTC-03:00 Brazil East'],
                                ['UTC3','UTC-03:00 Guyana'],
                                ['UTC2','UTC-02:00 Mid-Atlantic'],
                                ['STD1DST,M3.5.0/2,M10.5.0/2','UTC-01:00 Azores'],
                                ['UTC0','UTC+00:00 Gambia, Liberia, Morocco'],
                                ['GMT0BST,M3.5.0/2,M10.5.0/2','UTC+00:00 England'],
                                ['UTC-1','UTC+01:00 Tunisia'],
                                ['CET-1CEST,M3.5.0/2,M10.5.0/3','UTC+01:00 France, Germany, Italy, Poland, Sweden'],
                                ['EET-2EEST-3,M3.5.0/3,M10.5.0/4','UTC+02:00 Finland'],
                                ['UTC-2','UTC+02:00 South Africa'],
                                ['STD-2DST,M3.5.0/2,M10.5.0/2','UTC+02:00 Greece, Ukraine, Romania, Turkey, Latvia'],
                                ['UTC-3','UTC+03:00 Iraq, Jordan, Kuwait'],
                                ['MSK-3MSD,M3.5.0/3,M10.5.0/4','UTC+03:00 Moscow'],
                                ['UTC-4','UTC+04:00 Armenia'],
                                ['UTC-5','UTC+05:00 Pakistan, Russia'],
                                ['UTC-5:30','UTC+05:30 Bombay, Calcutta, Madras, New Delhi'],
                                ['UTC-6','UTC+06:00 Bangladesh, Russia'],
                                ['UTC-7','UTC+07:00 Thailand, Russia'],
                                ['UTC-8','UTC+08:00 China, Hong Kong, Western Australia, Singapore, Taiwan, Russia'],
                                ['UTC-9','UTC+09:00 Japan, Korea'],
                                ['ACST-9:30ACDT,M10.1.0/2,M4.1.0/3', 'UTC+09:30 South Australia'],
                                ['UTC-10','UTC+10:00 Guam, Russia'],
                                ['STD-10DST,M10.5.0/2,M3.5.0/2','UTC+10:00 Australia'],
                                ['UTC-11','UTC+11:00 Solomon Islands'],
                                ['UTC-12','UTC+12:00 Fiji'],
                                ['NZST-12NZDT,M9.5.0/2,M4.1.0/3','UTC+12:00 New Zealand']
                            ], value: nvram.tm_sel },
                            { title: 'Auto Daylight Savings Time', indent: 2, name: 'f_tm_dst', type: 'checkbox', value: nvram.tm_dst != '0' },
                            { title: 'Custom TZ String', indent: 2, name: 'f_tm_tz', type: 'text', maxlen: 32, size: 34, value: nvram.tm_tz || '' },
                            null,
                            { title: 'Auto Update Time', name: 'ntp_updates', type: 'select', options: [[-1,'Never'],[0,'Only at startup'],[1,'Every hour'],[2,'Every 2 hours'],[4,'Every 4 hours'],[6,'Every 6 hours'],[8,'Every 8 hours'],[12,'Every 12 hours'],[24,'Every 24 hours']],
                                value: nvram.ntp_updates },
                            { title: 'Trigger Connect On Demand', indent: 2, name: 'f_ntp_tdod', type: 'checkbox', value: nvram.ntp_tdod != '0' },
                            { title: 'NTP Time Server', name: 'f_ntp_server', type: 'select', options: ntpList, value: ntpSel },
                            { title: '&nbsp;', text: '<small><span id="ntp-preset">xx</span></small>', hidden: 1 },
                            { title: '', name: 'f_ntp_1', type: 'text', maxlen: 48, size: 50, value: ntp[0] || 'pool.ntp.org', hidden: 1 },
                            { title: '', name: 'f_ntp_2', type: 'text', maxlen: 48, size: 50, value: ntp[1] || '', hidden: 1 },
                            { title: '', name: 'f_ntp_3', type: 'text', maxlen: 48, size: 50, value: ntp[2] || '', hidden: 1 }
                        ]);
                        </script>
                        </div>
                        <br><br>
                        
                        <div id='ntpkiss' style='display:none'>
                        The following NTP servers have been automatically blocked by request from the server:
                        <b id='ntpkiss-ip'></b>
                        <div>
                            <input type='button' value='Clear' onclick='save(1)'>
                        </div>
                        </div>
                        
                        <!-- / / / -->
                        
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save(0)'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
                        <script type='text/javascript'>earlyInit()</script>				
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
