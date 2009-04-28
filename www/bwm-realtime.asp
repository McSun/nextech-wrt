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
#txt {
	width: 550px;
	white-space: nowrap;
}
#bwm-controls {
	text-align: right;
	margin-right: 5px;
	margin-top: 5px;
	float: right;
	visibility: hidden;
}
</style>
<script type='text/javascript' src='debug.js'></script>
<script type='text/javascript' src='bwm-common.js'></script>

<script type='text/javascript'>
//	<% nvram("wan_ifname,lan_ifname,wl_ifname,wan_proto,web_svg,rstats_colors"); %>

var cprefix = 'bw_r';
var updateInt = 2;
var updateDiv = updateInt;
var updateMaxL = 300;
var updateReTotal = 1;
var prev = [];
var debugTime = 0;
var avgMode = 0;
var wdog = null;
var wdogWarn = null;


var ref = new TomatoRefresh('update.cgi', 'exec=netdev', 2);

ref.stop = function() {
	this.timer.start(1000);
}

ref.refresh = function(text) {
	var c, i, h, n, j, k;

	watchdogReset();

	++updating;
	try {
		netdev = null;
		eval(text);

		n = (new Date()).getTime();
		if (this.timeExpect) {
			if (debugTime) E('dtime').innerHTML = (this.timeExpect - n) + ' ' + ((this.timeExpect + 2000) - n);
			this.timeExpect += 2000;
			this.refreshTime = MAX(this.timeExpect - n, 500);
		}
		else {
			this.timeExpect = n + 2000;
		}

		for (i in netdev) {
			c = netdev[i];
			if ((p = prev[i]) != null) {
				h = speed_history[i];

				h.rx.splice(0, 1);
				h.rx.push((c.rx < p.rx) ? (c.rx + (0xFFFFFFFF - p.rx)) : (c.rx - p.rx));

				h.tx.splice(0, 1);
				h.tx.push((c.tx < p.tx) ? (c.tx + (0xFFFFFFFF - p.tx)) : (c.tx - p.tx));
			}
			else if (!speed_history[i]) {
				speed_history[i] = {};
				h = speed_history[i];
				h.rx = [];
				h.tx = [];
				for (j = 300; j > 0; --j) {
					h.rx.push(0);
					h.tx.push(0);
				}
				h.count = 0;
			}
			prev[i] = c;
		}
		loadData();
	}
	catch (ex) {
	}
	--updating;
}

function watchdog()
{
	watchdogReset();
	ref.stop();
	wdogWarn.style.display = '';
}

function watchdogReset()
{
	if (wdog) clearTimeout(wdog)
	wdog = setTimeout(watchdog, 10000);
	wdogWarn.style.display = 'none';
}

function init()
{
	speed_history = [];

	initCommon(2, 1, 1);

	wdogWarn = E('warnwd');
	watchdogReset();

	ref.start();
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
                      <tr id='body'>
                      <td id='content'>
                      <div id='ident'><% ident(); %></div>
                      
                      <!-- / / / -->
                      
                      <div id='rstats'>
                          <div id='tab-area'></div>
                      
                          <script type='text/javascript'>
                          if (nvram.web_svg != '0') {
                              // without a div, Opera 9 moves svgdoc several pixels outside of <embed> (?)
                              W("<div style='border-top:1px solid #f0f0f0;border-bottom:1px solid #f0f0f0;visibility:hidden;padding:0;margin:0' id='graph'><embed src='bwm-graph.svg?<% version(); %>' style='width:760px;height:300px;margin:0;padding:0' type='image/svg+xml' pluginspage='http://www.adobe.com/svg/viewer/install/'></embed></div>");
                          }
                          </script>
                      
                          <div id='bwm-controls'>
                              <small>(10 minute window, 2 second interval)</small><br>
                              <br>
                              Avg:&nbsp;
                                  <a href='javascript:switchAvg(1)' id='avg1'>Off</a>,
                                  <a href='javascript:switchAvg(2)' id='avg2'>2x</a>,
                                  <a href='javascript:switchAvg(4)' id='avg4'>4x</a>,
                                  <a href='javascript:switchAvg(6)' id='avg6'>6x</a>,
                                  <a href='javascript:switchAvg(8)' id='avg8'>8x</a><br>
                              Max:&nbsp;
                                  <a href='javascript:switchScale(0)' id='scale0'>Uniform</a>,
                                  <a href='javascript:switchScale(1)' id='scale1'>Per IF</a><br>
                              Display:&nbsp;
                                  <a href='javascript:switchDraw(0)' id='draw0'>Solid</a>,
                                  <a href='javascript:switchDraw(1)' id='draw1'>Line</a><br>
                              Color:&nbsp; <a href='javascript:switchColor()' id='drawcolor'>-</a><br>
                              <small><a href='javascript:switchColor(1)' id='drawrev'>[reverse]</a></small><br>
                      
                              <br><br>
                              &nbsp; &raquo; <a href="admin-bwm.asp">Configure</a>
                          </div>
                      
                          <br><br>
                          <table border=0 cellspacing=2 id='txt'>
                          <tr>
                              <td width='8%' align='right' valign='top'><b style='border-bottom:blue 1px solid' id='rx-name'>RX</b></td>
                                  <td width='15%' align='right' valign='top'><span id='rx-current'></span></td>
                              <td width='8%' align='right' valign='top'><b>Avg</b></td>	
                                  <td width='15%' align='right' valign='top' id='rx-avg'></td>
                              <td width='8%' align='right' valign='top'><b>Peak</b></td>	
                                  <td width='15%' align='right' valign='top' id='rx-max'></td>
                              <td width='8%' align='right' valign='top'><b>Total</b></td>	
                                  <td width='14%' align='right' valign='top' id='rx-total'></td>
                              <td>&nbsp;</td>
                          </tr>
                          <tr>
                              <td width='8%' align='right' valign='top'><b style='border-bottom:blue 1px solid' id='tx-name'>TX</b></td>
                                  <td width='15%' align='right' valign='top'><span id='tx-current'></span></td>
                              <td width='8%' align='right' valign='top'><b>Avg</b></td>	
                                  <td width='15%' align='right' valign='top' id='tx-avg'></td>
                              <td width='8%' align='right' valign='top'><b>Peak</b></td>	
                                  <td width='15%' align='right' valign='top' id='tx-max'></td>
                              <td width='8%' align='right' valign='top'><b>Total</b></td>	
                                  <td width='14%' align='right' valign='top' id='tx-total'></td>
                              <td>&nbsp;</td>
                          </tr>
                          </table>
                      </div>
                      <br>
                      <br>
                      
                      <!-- / / / -->
                      
                      </td></tr>
                      <tr><td id='footer' colspan=2>
                          <span id='warnwd' style='display:none'>Warning: 10 second timeout, restarting...&nbsp;</span>
                          <span id='dtime'></span>
                          <img src='spin.gif' id='refresh-spinner' onclick='javascript:debugTime=1'>
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
