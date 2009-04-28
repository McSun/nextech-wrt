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
.color {
	width: 12px;
	height: 25px;
}
.title {
}
.count {
	text-align: right;
}
.pct {
	width:55px;
	text-align: right;
}
.thead {
	font-size: 90%;
	font-weight: bold;
}
.total {
	border-top: 1px dashed #bbb;
	font-weight: bold;
}
</style>
<script type='text/javascript'>
// <% nvram("web_svg,qos_enable"); %>

//<% qrate(); %>

var svgReady = 0;
var abc = ['Unclassified', 'Highest', 'High', 'Medium', 'Low', 'Lowest', 'Class A', 'Class B', 'Class C', 'Class D', 'Class E'];
var colors = [
	'c6e2ff',
	'b0c4de',
	'9ACD32',
	'3cb371',
	'6495ed',
	'8FBC8F',
	'a0522d',
	'deb887',
	'F08080',
	'ffa500',
	'ffd700'
];

function mClick(n)
{
	location.href = 'qos-detailed.asp?class=' + n;
}

function showData()
{
	var i, n, p;
	var ct, rt;
	
	ct = rt = 0;
	for (i = 0; i < 11; ++i) {
		if (!nfmarks[i]) nfmarks[i] = 0;
		ct += nfmarks[i];
		if (!qrates[i]) qrates[i] = 0;
		rt += qrates[i];
	}
	
	for (i = 0; i < 11; ++i) {
		n = nfmarks[i];
		E('ccnt' + i).innerHTML = n;
		if (ct > 0) p = (n / ct) * 100;
			else p = 0;
		E('cpct' + i).innerHTML = p.toFixed(2) + '%';
	}
	E('ccnt-total').innerHTML = ct;

	for (i = 1; i < 11; ++i) {
		n = qrates[i];
		E('bcnt' + i).innerHTML = (n / 1000).toFixed(2)
		E('bcntx' + i).innerHTML = (n / 8192).toFixed(2)
		if (rt > 0) p = (n / rt) * 100;
			else p = 0;
		E('bpct' + i).innerHTML = p.toFixed(2) + '%';
	}
	E('bcnt-total').innerHTML = (rt / 1000).toFixed(2)
	E('bcntx-total').innerHTML = (rt / 8192).toFixed(2)
}


var ref = new TomatoRefresh('update.cgi', 'exec=qrate', 2, 'qos_graphs');

ref.refresh = function(text)
{
	nfmarks = [];
	qrates = [];
	try {
		eval(text);
	}
	catch (ex) {
		nfmarks = [];
		qrates = [];
	}

	showData();	
	if (svgReady == 1) {
		updateCD(nfmarks);
		updateBD(qrates);
	}
}

function checkSVG()
{
	var i, e, d, w;

	try {
		for (i = 1; i >= 0; --i) {
			e = E('svg' + i);
			d = e.getSVGDocument();
			if (d.defaultView) w = d.defaultView;
				else w = e.getWindow();
			if (!w.ready) break;
			if (i == 0) updateCD = w.updateSVG;
				else updateBD = w.updateSVG;
		}
	}
	catch (ex) {
	}
	
	if (i < 0) {
		svgReady = 1;
		updateCD(nfmarks);
		updateBD(qrates);
	}
	else if (--svgReady > -5) {
		setTimeout(checkSVG, 500);
	}
}

function init()
{
	nbase = fixInt(cookie.get('qnbase'), 0, 1, 0);
	showData();
	checkSVG();
	ref.initPage(2000, 3);
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
                        <form id='_fom' action='javascript:{}'>
                        <table id='container' cellspacing=0>
                        <tr id='body'>
                        <td id='content'>
                        <div id='ident'><% ident(); %></div>
                        
                        <!-- / / / -->
                        
                        <div class="section-title">Connections Distribution</div>
                        <div class="section">
                        <table border=0 width="100%"><tr><td>
                            <table style="width:250px">
                        <script type='text/javascript'>
                        for (i = 0; i < 11; ++i) {
                            W('<tr style="cursor:pointer" onclick="mClick(' + i + ')">' +
                                '<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
                                '<td class="title" style="width:60px"><a href="qos-detailed.asp?class=' + i + '">' + abc[i] + '</a></td>' +
                                '<td id="ccnt' + i + '" class="count" style="width:90px"></td>' + 
                                '<td id="cpct' + i + '" class="pct"></td></tr>');
                        }
                        </script>
                            <tr><td>&nbsp;</td><td class="total">Total</a></td><td id="ccnt-total" class="total count"></td><td class="total pct">100%</td></tr>
                            </table>
                        </td><td style="margin-right:150px">
                        <script type='text/javascript'>
                        if (nvram.web_svg != '0') {
                            W('<embed src="qos-graph.svg?n=0&v=<% version(); %>" style="width:310px;height:310px;margin:0;padding:0" id="svg0" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>');
                        }
                        </script>
                        </td></tr>
                        </table>
                        </div>
                        
                        <div class="section-title">Bandwidth Distribution (Outbound)</div>
                        <div class="section">
                        <table border=0 width="100%"><tr><td>
                            <table style="width:250px">
                            <tr><td class='color' style="height:1em"></td><td class='title' style="width:45px">&nbsp;</td><td class='thead count'>kbit/s</td><td class='thead count'>KB/s</td><td class='pct'>&nbsp;</td></tr>
                        <script type='text/javascript'>
                        for (i = 1; i < 11; ++i) {
                            W('<tr style="cursor:pointer" onclick="mClick(' + i + ')">' +
                                '<td class="color" style="background:#' + colors[i] + '" onclick="mClick(' + i + ')">&nbsp;</td>' +
                                '<td class="title" style="width:45px"><a href="qos-detailed.asp?class=' + i + '">' + abc[i] + '</a></td>' +
                                '<td id="bcnt' + i + '" class="count" style="width:60px"></td>' + 
                                '<td id="bcntx' + i + '" class="count" style="width:50px"></td>' + 
                                '<td id="bpct' + i + '" class="pct"></td></tr>');
                        }
                        </script>
                            <tr><td>&nbsp;</td><td class="total">Total</a></td><td id="bcnt-total" class="total count"></td><td id="bcntx-total" class="total count"></td><td class="total pct">100%</td></tr>
                            </table>
                        </td><td style="margin-right:150px">
                        <script type='text/javascript'>
                        if (nvram.web_svg != '0') {
                            W('<embed src="qos-graph.svg?n=1&v=<% version(); %>" style="width:310px;height:310px;margin:0;padding:0" id="svg1" type="image/svg+xml" pluginspage="http://www.adobe.com/svg/viewer/install/"></embed>');
                        }
                        </script>
                        </td></tr>
                        </table>
                        </div>
                        
                        <script type='text/javascript'>
                        if (nvram.qos_enable != '1') {
                            W('<div class="note-disabled"><b>QoS disabled.</b> &nbsp; <a href="qos-settings.asp">Enable &raquo;</a></div>');
                        }
                        </script>
                        
                        <!-- / / / -->
                        
                        </td></tr>
                        <tr><td id='footer' colspan=2>
                            <script type='text/javascript'>genStdRefresh(1,0,'ref.toggle()');</script>
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
