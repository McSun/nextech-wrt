<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
textarea {
	width: 98%;
	height: 10em;
}
.empty {
	height: 2em;
}
</style>
<script type='text/javascript'>

//	<% nvram("sch_rboot,sch_rcon,sch_c1,sch_c1_cmd,sch_c2,sch_c2_cmd,sch_c3,sch_c3_cmd"); %>
	
var dowNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
var dowLow = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'];
var scheds = []

tm = [];
for (i = 0; i < 1440; i += 15) {
	tm.push([i, timeString(i)]);
}

tm.push(
	[-1, 'Every minute'], [-3, 'Every 3 minutes'], [-5, 'Every 5 minutes'], [-15, 'Every 15 minutes'], [-30, 'Every 30 minutes'],
	[-60, 'Every hour'], [-(12 * 60), 'Every 12 hours'], [-(24 * 60), 'Every 24 hours'],
	['e', 'Every...']);

/* REMOVE-BEGIN

sch_* = en,time,days

REMOVE-END */

function makeSched(key, custom)
{
	var s, v, w, a, t, i;
	var oe;

	scheds.push(key);
	
	s = nvram['sch_' + key] || '';
	if ((v = s.match(/^(0|1),(-?\d+),(\d+)$/)) == null) {
		v = custom ? ['', 0, -30, 0] : ['', 0, 0, 0];
	}
	w = v[3] * 1;
	if (w <= 0) w = 0xFF;
	
	key = key + '_';
	
	if (custom) {
		t = tm;
	}
	else {
		t = [];
		for (i = 0; i < tm.length; ++i) {
			if ((tm[i][0] >= 0) || (tm[i][0] <= -60) || (tm[i][0] == 'e')) t.push(tm[i]);
		}
	}
	
	oe = 1;
	for (i = 0; i < t.length; ++i) {
		if (v[2] == t[i][0]) {
			oe = 0;
			break;
		}
	}
	
	a = [
		{ title: 'Enabled', name: key + 'enabled', type: 'checkbox', value: v[1] == '1' },
		{ title: 'Time', multi: [
			{ name: key + 'time', type: 'select', options: t, value: oe ? 'e' : v[2] },
			{ name: key + 'every', type: 'text', maxlen: 10, size: 10, value: (v[2] < 0) ? -v[2] : 30,
				prefix: ' ', suffix: ' <small id="_' + key + 'mins"><i>minutes</i></small>' } ] },
		{ title: 'Days', multi: [
			{ name: key + 'sun', type: 'checkbox', suffix: ' Sun &nbsp; ', value: w & 1 },
			{ name: key + 'mon', type: 'checkbox', suffix: ' Mon &nbsp; ', value: w & 2 },
			{ name: key + 'tue', type: 'checkbox', suffix: ' Tue &nbsp; ', value: w & 4 },
			{ name: key + 'wed', type: 'checkbox', suffix: ' Wed &nbsp; ', value: w & 8 },
			{ name: key + 'thu', type: 'checkbox', suffix: ' Thu &nbsp; ', value: w & 16 },
			{ name: key + 'fri', type: 'checkbox', suffix: ' Fri &nbsp; ', value: w & 32 },
			{ name: key + 'sat', type: 'checkbox', suffix: ' Sat &nbsp; &nbsp;', value: w & 64 },
			{ name: key + 'everyday', type: 'checkbox', suffix: ' Everyday', value: (w & 0x7F) == 0x7F } ] }
	];
	
	if (custom) {
		a.push({ title: 'Command', name: 'sch_' + key + 'cmd', type: 'textarea', value: nvram['sch_' + key + 'cmd' ] });
	}
	
	createFieldTable('', a);
}

function verifySched(focused, quiet, key)
{
	var e, f, i, n, b;
	var eTime, eEvery, eEveryday, eCmd;
	
	key = '_' + key + '_';

	eTime = E(key + 'time');
	eEvery = E(key + 'every');
	eEvery.style.visibility = E(key + 'mins').style.visibility = (eTime.value == 'e') ? 'visible' : 'hidden';
	
	eCmd = E('_sch' + key + 'cmd');
	eEveryday = E(key + 'everyday');
	
	if (E(key + 'enabled').checked) {
		eEveryday.disabled = 0;
		eTime.disabled = 0;
		eEvery.disabled = 0;
		if (eCmd) eCmd.disabled = 0;

		if (focused == eEveryday) {
			for (i = 0; i < 7; ++i) {
				f = E(key + dowLow[i]);
				f.disabled = 0;
				f.checked = eEveryday.checked;
			}
		}
		else {
			n = 0;
			for (i = 0; i < 7; ++i) {
				f = E(key + dowLow[i]);
				f.disabled = 0;
				if (f.checked) ++n;
			}
			eEveryday.checked = (n == 7);
		}
		
		if ((eTime.value == 'e') && (!v_mins(eEvery, quiet, eCmd ? 1 : 60, 60 * 24 * 60))) return 0;
		
		if ((eCmd) && (!v_length(eCmd, quiet, quiet ? 0 : 1, 2048))) return 0;
	}
	else {
		eEveryday.disabled = 1;
		eTime.disabled = 1;
		eEvery.disabled = 1;
		for (i = 0; i < 7; ++i) {
			E(key + dowLow[i]).disabled = 1;
		}
		if (eCmd) eCmd.disabled = 1;
	}
	
	if (eCmd) {
		if ((eCmd.value.length) || (!eTime.disabled)) {
			elem.removeClass(eCmd, 'empty');
		}
		else {
			elem.addClass(eCmd, 'empty');
		}
	}
	
	return 1;
}

function verifyFields(focused, quiet)
{
	for (var i = 0; i < scheds.length; ++i) {
		if (!verifySched(focused, quiet, scheds[i])) return 0;
	}
	return 1;
}

function saveSched(fom, key)
{
	var s, i, n, k, en, e;
	
	k = '_' + key + '_';

	en = E(k + 'enabled').checked;
	s = en ? '1' : '0';
	s += ',';
	
	e = E(k + 'time').value;
	if (e == 'e') s += -(E(k + 'every').value * 1);
		else s += e;
	
	n = 0;
	for (i = 0; i < 7; ++i) {
		if (E(k + dowLow[i]).checked) n |= (1 << i);
	}
	if (n == 0) {
		n = 0x7F;
		e = E(k + 'everyday');
		e.checked = 1;
		verifySched(e, key);
	}
	
	e = fom['sch_' + key];
	e.value = s + ',' + n;
}

function save()
{
	var fom, i
	
	if (!verifyFields(null, false)) return;
	
	fom = E('_fom');
	for (i = 0; i < scheds.length; ++i) {
		saveSched(fom, scheds[i]);
	}
	
	form.submit(fom, 1);
}

function init()
{
	verifyFields(null, 1);
	E('content').style.visibility = 'visible';
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
                        <form name='_fom' id='_fom' method='post' action='tomato.cgi'>
                        
                        <!-- / / / -->
                        
                        <input type='hidden' name='_nextpage' value='admin-sched.asp'>
                        <input type='hidden' name='_service' value='sched-restart'>
                        <input type='hidden' name='sch_rboot' value=''>
                        <input type='hidden' name='sch_rcon' value=''>
                        <input type='hidden' name='sch_c1' value=''>
                        <input type='hidden' name='sch_c2' value=''>
                        <input type='hidden' name='sch_c3' value=''>
                        
                        <div class='section-title'>Reboot</div>
                        <div class='section' onMouseOver="replaceElement('reboot')" onMouseOut="removeElement('reboot')">
                        <script type='text/javascript'>
                        makeSched('rboot');
                        </script>
                        </div>
                        
                        <div class='section-title'>Reconnect</div>
                        <div class='section' onMouseOver="replaceElement('reconnect')" onMouseOut="removeElement('reconnect')">
                        <script type='text/javascript'>
                        makeSched('rcon');
                        </script>
                        </div>
                        
                        <div class='section-title'>Custom 1</div>
                        <div class='section' onMouseOver="replaceElement('backup')" onMouseOut="removeElement('backup')">
                        <script type='text/javascript'>
                        makeSched('c1', 1);
                        </script>
                        </div>
                        
                        <div class='section-title'>Custom 2</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        makeSched('c2', 1);
                        </script>
                        </div>
                        
                        <div class='section-title'>Custom 3</div>
                        <div class='section' onMouseOver="replaceElement('custom')" onMouseOut="removeElement('custom')">
                        <script type='text/javascript'>
                        makeSched('c3', 1);
                        </script>
                        </div>
                        
                        <!-- / / / -->
                        
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
					</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
            <h3>Brainy Bunch Help</h3>
            <p id="reboot" style="display:none"> Setup this to automatically  reboot your router at a designated time</p>
            <p id="reconnect" style="display:none"> Setup this to reconnect  to Nextech at a designated time.</p>
            <p id="custom" style="display:none"> Setup custom  script to run at a designated time.</p>
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
