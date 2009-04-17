<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
#survey-grid .brate {
	color: blue;
}
#survey-grid .grate {
	color: green;
}
#survey-grid .co4,
#survey-grid .co5 {
	text-align: right;
}
#survey-grid .co6,
#survey-grid .co7 {
	text-align: center;
}
#survey-msg {
	border: 1px dashed #f0f0f0;
	background: #fefefe;
	padding: 5px;
	width: 300px;
	position: absolute;
}
#survey-controls {
	text-align: right;
}
#expire-time {
	width: 120px;
}
</style>

<script type='text/javascript'>
//	<% nvram(''); %>	// http_id

var wlscandata = [];
var entries = [];
var dayOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

Date.prototype.toWHMS = function() {
	return dayOfWeek[this.getDay()] + ' ' + this.getHours() + ':' + this.getMinutes().pad(2)+ ':' + this.getSeconds().pad(2);
}

var sg = new TomatoGrid();

sg.sortCompare = function(a, b) {
	var col = this.sortColumn;
	var da = a.getRowData();
	var db = b.getRowData();
	var r;

	switch (col) {
	case 0:
		r = -cmpDate(da.lastSeen, db.lastSeen);
		break;
	case 3:
		r = cmpInt(da.rssi, db.rssi);
		break;
	case 4:
		r = cmpInt(da.noise, db.noise);
		break;
	case 5:
		r = cmpInt(da.qual, db.qual);
		break;
	case 6:
		r = cmpInt(da.channel, db.channel);
		break;
	default:
		r = cmpText(a.cells[col].innerHTML, b.cells[col].innerHTML);
	}
	if (r == 0) r = cmpText(da.bssid, db.bssid);

	return this.sortAscending ? r : -r;
}

sg.rateSorter = function(a, b)
{
	if (a < b) return -1;
	if (a > b) return 1;
	return 0;
}

sg.populate = function()
{
	var caps = ['infra', 'adhoc', 'poll', 'pollreq', 'wep', 'shortpre', 'pbcc', 'agility', 'X', 'Y', 'shortslot'];
	var added = 0;
	var removed = 0;
	var i, j, k, t, e, s;

	if ((wlscandata.length == 1) && (!wlscandata[0][0])) {
		setMsg("error: " + wlscandata[0][1]);
		return;
	}
	
	for (i = 0; i < wlscandata.length; ++i) {
		s = wlscandata[i];
		e = null;

		for (j = 0; j < entries.length; ++j) {
			if (entries[j].bssid == s[0]) {
				e = entries[j];
				break;
			}
		}
		if (!e) {
			++added;
			e = {};
			e.firstSeen = new Date();
			entries.push(e);
		}
		e.lastSeen = new Date();
		e.bssid = s[0];
		e.ssid = s[1];
		e.channel = s[2];
		e.rssi = s[4];
		e.noise = s[5];
		e.saw = 1;

		t = '';
		k = 0;
		for (j = 0; j < caps.length; ++j) {
			if ((s[3] & (1 << j)) && (caps[j])) {
				k += caps[j].length;
				if (k > 12) {
					t += '<br>';
					k = caps[j].length;
				}
				else t += ' ';
				t += caps[j];
			}
		}
		e.cap = t;

		t = '';
		var rb = [];
		var rg = [];
		for (j = 0; j < s[6].length; ++j) {
			var x = s[6][j];
			var r = (x & 0x7F) / 2;
			if (x & 0x80) rb.push(r);
				else rg.push(r);
		}
		rb.sort(this.rateSorter);
		rg.sort(this.rateSorter);

		t = '';
		if (rb.length) t = '<span class="brate">' + rb.join(',') + '</span>';
		if (rg.length) {
			if (rb.length) t += '<br>';
			t +='<span class="grate">' + rg.join(',') + '</span>';
		}
		e.rates = t;
	}

	t = E('expire-time').value;
	if (t > 0) {
		var cut = (new Date()).getTime() - (t * 1000);
		for (i = 0; i < entries.length; ) {
			if (entries[i].lastSeen.getTime() < cut) {
				entries.splice(i, 1);
				++removed;
			}
			else ++i;
		}
	}

	for (i = 0; i < entries.length; ++i) {
		var seen, m, mac;
		
		e = entries[i];

		if (!e.saw) {
			e.rssi = MAX(e.rssi - 5, -101);
			e.noise = MAX(e.noise - 2, -101);
			if ((e.rssi == -101) || (e.noise == -101))
				e.noise = e.rssi = -999;
		}
		e.saw = 0;

		e.qual = MAX(e.rssi - e.noise, 0);
		
		seen = e.lastSeen.toWHMS();
		if (useAjax()) {
			m = Math.floor(((new Date()).getTime() - e.firstSeen.getTime()) / 60000);
			if (m <= 10) seen += '<br> <b><small>NEW (' + -m + 'm)</small></b>';
		}

		mac = e.bssid;
		if (mac.match(/^(..):(..):(..)/))
			mac = '<a href="http://standards.ieee.org/cgi-bin/ouisearch?' + RegExp.$1 + '-' + RegExp.$2 + '-' + RegExp.$3 + '" target="_new" title="OUI search">' + mac + '</a>';

		sg.insert(-1, e, [
			'<small>' + seen + '</small>',
			'' + e.ssid,
			mac,
			(e.rssi == -999) ? '' : (e.rssi + ' <small>dBm</small>'),
			(e.noise == -999) ? '' : (e.noise + ' <small>dBm</small>'),
			'<small>' + e.qual + '</small> <img src="bar' + MIN(MAX(Math.floor(e.qual / 10), 1), 6) + '.gif">',
			'' + e.channel,
			'' + e.cap,
			'' + e.rates], false);
	}

	s = '';
	if (useAjax()) s = added + ' added, ' + removed + ' removed, ';
	s += entries.length + ' total.';

	s += '<br><br><small>Last updated: ' + (new Date()).toWHMS() + '</small>';
	setMsg(s);

	wlscandata = [];
}

sg.setup = function() {
	this.init('survey-grid', 'sort');
	this.headerSet(['Last Seen', 'SSID', 'BSSID', 'RSSI &nbsp; &nbsp; ', 'Noise &nbsp; &nbsp; ', 'Quality', 'Ch', 'Capabilities', 'Rates']);
	this.populate();
	this.sort(0);
}


function setMsg(msg)
{
	E('survey-msg').innerHTML = msg;
}


var ref = new TomatoRefresh('update.cgi', 'exec=wlscan', 0, 'tools_survey_refresh');

ref.refresh = function(text)
{
	try {
		eval(text);
	}
	catch (ex) {
		return;
	}
	sg.removeAllData();
	sg.populate();
	sg.resort();
}

function earlyInit()
{
	if (!useAjax()) E('expire-time').style.visibility = 'hidden';
	sg.setup();
}

function init()
{
	sg.recolor();
	ref.initPage();
}
</script>

</HEAD>
<body onload='init()' style="WIDTH: 100%; HEIGHT: 100%" bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0">
	<form action='javascript:{}'>
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
	
	
	
						<!-- / / / -->

						<div class='section-title'>Wireless Site Survey</div>
						<div class='section'>
							<table id='survey-grid' class='tomato-grid' cellspacing=0></table>
							<div id='survey-msg'></div>
							<div id='survey-controls'>
								<img src="spin.gif" id="refresh-spinner">
								<script type='text/javascript'>
								genStdTimeList('expire-time', 'Auto Expire', 0);
								genStdTimeList('refresh-time', 'Auto Refresh', 0);
								</script>
								<input type="button" value="Refresh" onClick="ref.toggle()" id="refresh-button">
							</div>

							<br><br><br><br>
							<script type='text/javascript'>
							if ('<% wlclient(); %>' == '0') {
								document.write('<small>Warning: Wireless connections to this router may be disrupted while using this tool.</small>');
							}
							</script>
						</div>

						<!-- / / / -->					
					
					
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
</form>
<script type='text/javascript'>earlyInit();</script>
</body>
</HTML>
