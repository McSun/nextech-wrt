<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
#ttr-grid .co1, #ttr-grid .co3 {
	text-align: right;
}
#ttr-grid .co1 {
	width: 30px;
}
#ttr-grid .co2 {
	width: 410px;
}
#ttr-grid .co4, #ttr-grid .co5, #ttr-grid .co6 {
	text-align: right;
	width: 70px;
}
#ttr-grid .header .co1 {
	text-align: left;
}
</style>

<script type='text/javascript'>
//	<% nvram(''); %>	// http_id

var tracedata = '';

var tg = new TomatoGrid();
tg.setup = function() {
	this.init('ttr-grid');
	this.headerSet(['Hop', 'Address', 'Min (ms)', 'Max (ms)', 'Avg (ms)', '+/- (ms)']);
}
tg.populate = function() {
	var seq = 1;
	var buf = tracedata.split('\n');
	var i, j, k;
	var s, f;
	var addr, emsg, min, max, avg;
	var time;
	var last = -1;

	this.removeAllData();
	for (i = 0; i < buf.length; ++i) {
		if (!buf[i].match(/^\s*(\d+)\s+(.+)$/)) continue;
		if (RegExp.$1 != seq) continue;

		s = RegExp.$2;

		if (s.match(/^([\w\.-]+)\s+\(([\d\.]+)\)/)) {
			addr = RegExp.$1;
			if (addr != RegExp.$2) addr += ' (' + RegExp.$2 + ')';
		}
		else addr = '*';

		min = max = avg = '';
		change = '';
		if (time = s.match(/(\d+\.\d+) ms/g)) {		// odd: captures 'ms'
			min = 0xFFFF;
			avg = max = 0;
			k = 0;
			for (j = 0; j < time.length; ++j) {
				f = parseFloat(time[j]);
				if (isNaN(f)) continue;
				if (f < min) min = f;
				if (f > max) max = f;
				avg += f;
				++k
			}
			if (k) {
				avg /= k;
				if (last >= 0) {
					change = avg - last;
					change = change.toFixed(2);
				}
				last = avg;
				min = min.toFixed(2);
				max = max.toFixed(2);
				avg = avg.toFixed(2);
			}
			else {
				min = max = avg = '';
				last = -1;
			}
		}
		else last = -1;

		if (s.match(/ (![<>\w+-]+)/)) emsg = RegExp.$1;
			else emsg = null;

		this.insertData(-1, [seq, addr, min, max, avg, change])
		++seq;
	}

	E('debug').value = tracedata;
	tracedata = '';
	spin(0);
}

function verifyFields(focused, quiet)
{
	var s;
	var e;

	e = E('_f_addr');
	s = e.value.trim();
	if (!s.match(/^[\w\.-]+$/)) {
		ferror.set(e, 'Invalid address', quiet);
		return 0;
	}
	ferror.clear(e);

	return v_range('_f_hops', quiet, 2, 40) && v_range('_f_wait', quiet, 2, 10);
}

var tracer = null;

function spin(x)
{
	E('traceb').disabled = x;
	E('_f_addr').disabled = x;
	E('_f_hops').disabled = x;
	E('_f_wait').disabled = x;
	E('wait').style.visibility = x ? 'visible' : 'hidden';
	if (!x) tracer = null;
}

function trace()
{
	// Opera 8 sometimes sends 2 clicks
	if (tracer) return;

	if (!verifyFields(null, 0)) return;
	spin(1);
	E('trace-error').style.visibility = 'hidden';

	tracer = new XmlHttp();
	tracer.onCompleted = function(text, xml) {
		eval(text);
		tg.populate();
	}
	tracer.onError = function(x) {
		spin(0);
		E('trace-error').innerHTML = 'ERROR: ' + E('_f_addr').value + ' - ' + x;
		E('trace-error').style.visibility = 'visible';
	}

	var addr = E('_f_addr').value;
	var hops = E('_f_hops').value;
	var wait = E('_f_wait').value;
	tracer.post('trace.cgi', 'addr=' + addr + '&hops=' + hops + '&wait=' + wait);

	cookie.set('traceaddr', addr);
	cookie.set('tracehops', hops);
	cookie.set('tracewait', wait);
}

function init()
{
	var s;

	if ((s = cookie.get('traceaddr')) != null) E('_f_addr').value = s;
	if ((s = cookie.get('tracehops')) != null) E('_f_hops').value = s;
	if ((s = cookie.get('tracewait')) != null) E('_f_wait').value = s;

	E('_f_addr').onkeypress = function(ev) { if (checkEvent(ev).keyCode == 13) trace(); }
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
	
	
						<!-- / / / -->

						<div class='section-title'>Traceroute</div>
						<div class='section'>
						<script type='text/javascript'>
						createFieldTable('', [
							{ title: 'Address', name: 'f_addr', type: 'text', maxlen: 64, size: 32, value: '', suffix: ' <input type="button" value="Trace" onclick="trace()" id="traceb">' },
							{ title: 'Maximum Hops', name: 'f_hops', type: 'text', maxlen: 2, size: 4, value: '20' },
							{ title: 'Maximum Wait Time', name: 'f_wait', type: 'text', maxlen: 2, size: 4, value: '3', suffix: ' <small>(seconds per hop)</small>' }
						]);
						</script>
						</div>

						<div style='visibility:hidden' id='trace-error'></div>

						<div style='visibility:hidden;text-align:right' id='wait'>Please wait... <img src='spin.gif' style='vertical-align:top'></div>

						<table id='ttr-grid' class='tomato-grid' cellspacing=1></table>

						<div style='height:10px;' onclick='javascript:E("debug").style.display=""'></div>
						<textarea id='debug' style='width:99%;height:300px;display:none'></textarea>

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
<script type='text/javascript'>tg.setup();</script>
</body>
</HTML>
