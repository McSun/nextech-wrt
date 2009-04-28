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
<script type='text/javascript' src='debug.js'></script>
<script type='text/javascript' src='bwm-hist.js'></script>

<script type='text/javascript'>

//	<% nvram("wan_ifname,lan_ifname,rstats_enable"); %>
try {
//	<% bandwidth("daily"); %>
}
catch (ex) {
	daily_history = [];
}
rstats_busy = 0;
if (typeof(daily_history) == 'undefined') {
	daily_history = [];
	rstats_busy = 1;
}

var weeks = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
var weeksShort = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
var startwk = 0;
var summary = 1;

function save()
{
	cookie.set('weekly', scale + ',' + startwk + ',' + summary, 31);
}

function changeStart(e)
{
	startwk = e.value * 1;
	redraw();
	save();
}

function changeMode(e)
{
	summary = e.value * 1;
	redraw();
	save();
}

function nth(n)
{
	n += '';
	switch (n.substr(n.length - 1, 1)) {
	case '1':
		return n + 'st';
	case '2':
		return n + 'nd';
	case '3':
		return n + 'rd';
	}
	return n + 'th';
}

function redraw()
{
	var h;
	var grid;
	var block;
	var rows;
	var dend;
	var dbeg;
	var dl, ul;
	var d, diff, ds;
	var tick, lastSplit;
	var yr, mo, da, wk;
	var gn;
	var swk;
	
	rows = 0;
	block = [];
	gn = 0;
	w = 0;
	lastSplit = 0;
	ul = dl = 0;
	dend = dbeg = '';
	
	swk	= startwk - 1;
	if (swk < 0) swk = 6;	

	if (summary) {
		grid = '<table class="bwmg" cellspacing="1">';
		grid += makeRow('header', 'Date', 'Download', 'Upload', 'Total');
	}
	else {
		grid = '';
	}

	function flush_block()
	{
		grid += '<b>' + dbeg + ' to ' + dend + '</b>' +
				'<table class="bwmg" cellspacing="1">' +
				makeRow('header', 'Date', 'Download', 'Upload', 'Total') +
				block.join('') +
				makeRow('footer', 'Total', rescale(dl), rescale(ul), rescale(dl + ul)) +
				'</table><br>';
	}

	for (i = 0; i < daily_history.length; ++i) {
		h = daily_history[i];
		yr = (((h[0] >> 16) & 0xFF) + 1900);
		mo = ((h[0] >>> 8) & 0xFF);
		da = (h[0] & 0xFF);
		d = new Date(yr, mo, da);
		wk = d.getDay();

		tick = d.getTime();
		diff = lastSplit - tick;

		ds = ymdText(yr, mo, da) + ' <small>(' + weeksShort[wk] + ')</small>';

/*	REMOVE-BEGIN

	Jan 2007
	SU MO TU WE TH FR SA
	   01 02 03 04 05 06
	07 08 09 10 11 12 13
	14 15 16 17 18 19 20
	21 22 23 24 25 26 27
	28 29 30 31

	Feb 2007
	SU MO TU WE TH FR SA
	            01 02 03
	04 05 06 07 08 09 10
	11 12 13 14 15 16 17
	18 19 20 21 22 23 24
	25 26 27 28

	Mar 2007
	SU MO TU WE TH FR SA
	            01 02 03
	04 05 06 07 08 09 10
	11 12 13 14 15 16 17
	18 19 20 21 22 23 24
	25 26 27 28 29 30 31
	
	REMOVE-END */

		if ((wk == swk) || (diff >= (7 * 86400000)) || (lastSplit == 0)) {
			if (summary) {
				if (i > 0) {
					grid += makeRow(((rows & 1) ? 'odd' : 'even'), 
						dend + '<br>' + dbeg, rescale(dl), rescale(ul), rescale(dl + ul));
					++rows;
					++gn;
				}
			}
			else {
				if (rows) {
					flush_block();
					++gn;
				}
				block = [];
				rows = 0;
			}
			dl = ul = 0;
			dend = ds;
			lastSplit = tick;
		}

		dl += h[1];
		ul += h[2];
		if (!summary) {
			block.unshift(makeRow(((rows & 1) ? 'odd' : 'even'), weeks[wk] + ' <small>' + (mo + 1) + '-' + da + '</small>', rescale(h[1]), rescale(h[2]), rescale(h[1] + h[2])))
			++rows;
		}
			
		dbeg = ds;
	}

	if (summary) {
		if (gn < 9) {
			grid += makeRow(((rows & 1) ? 'odd' : 'even'), 
				dend + '<br>' + dbeg, rescale(dl), rescale(ul), rescale(dl + ul));
		}
		grid += '</table>';
	}
	else {
		if ((rows) && (gn < 9)) {
			flush_block();
		}
	}
	E('bwm-weekly-grid').innerHTML = grid;
}

function init()
{
	var s;

	if (nvram.rstats_enable != '1') return;

	if ((s = cookie.get('weekly')) != null) {
		if (s.match(/^([0-2]),([0-6]),([0-1])$/)) {
			E('scale').value = scale = RegExp.$1 * 1;
			E('startwk').value = startwk = RegExp.$2 * 1
			E('shmode').value = summary = RegExp.$3 * 1;
		}
	}

	initDate('ymd');
	daily_history.sort(cmpHist);
	redraw();
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
                      <form>
                      <table id='container' cellspacing=0>
                      <tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
                      <td id='content'>
                      <div id='ident'><% ident(); %></div>
                      
                      <!-- / / / -->
                      
                      <div class='section-title'>WAN Bandwidth - Weekly</div>
                      <div id='bwm-weekly-grid' style='float:left'></div>
                      <div style="float:right;text-align:right">
                      <b>Show</b> <select onchange='changeMode(this)' id='shmode'><option value=1 selected>Summary<option value=0>Full</select><br>
                      <b>Date</b> <select onchange='changeDate(this, "ymd")' id='dafm'><option value=0>yyyy-mm-dd</option><option value=1>mm-dd-yyyy</option><option value=2>mmm dd, yyyy</option><option value=3>dd.mm.yyyy</option></select><br>
                      <b>Start</b> <select onchange='changeStart(this)' id='startwk'><option value=0 selected>Sun<option value=1>Mon<option value=2>Tue<option value=3>Wed<option value=4>Thu<option value=5>Fri<option value=6>Sat</select><br>
                      <b>Scale</b> <select onchange='changeScale(this)' id='scale'><option value=0>KB</option><option value=1>MB</option><option value=2 selected>GB</option></select><br>
                      <br>
                      &raquo; <a href="admin-bwm.asp">Configure</a>
                      <br><br><br>
                      </div>
                      <br>
                      
                      <script type='text/javascript'>checkRstats();</script>
                      
                      <!-- / / / -->
                      
                      </td></tr>
                      <tr><td id='footer' colspan=2>
                      <input type='button' value='Refresh' onclick='reloadPage()'>
                      </td></tr>
                      </table>
                      </form>
					
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
