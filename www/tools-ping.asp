<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
#tp-grid .co1 {
	text-align: right;
	width: 30px;
}
#tp-grid .co2 {
	width: 440px;
}
#tp-grid .co3, #tp-grid .co4, #tp-grid .co5, #tp-grid .co6 {
	text-align: right;
	width: 70px;
}
#tp-grid .header .co1 {
	text-align: left;
}
</style>

<script type='text/javascript'>

//	<% nvram(''); %>	// http_id

var pingdata = '';

var pg = new TomatoGrid();
pg.setup = function() {
	this.init('tp-grid');
	this.headerSet(['Seq', 'Address', 'RX Bytes', 'TTL', 'RTT (ms)', '+/- (ms)']);
}
pg.populate = function()
{
	var buf = pingdata.split('\n');
	var i;
	var r, s, t;
	var last = -1;
	var resolv = [];
	var stats = '';

/* REMOVE-BEGIN
1.9
PING 192.168.1.3 (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=1.165 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.675 ms
64 bytes from 192.168.1.3: seq=2 ttl=64 time=0.683 ms
64 bytes from 192.168.1.3: seq=3 ttl=64 time=0.663 ms
64 bytes from 192.168.1.3: seq=4 ttl=64 time=0.682 ms

--- 192.168.1.3 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 0.663/0.773/1.165 ms


1.2
PING 192.168.5.5 (192.168.1.5): 56 data bytes
64 bytes from 192.168.1.5: icmp_seq=0 ttl=64 time=1.2 ms
64 bytes from 192.168.1.5: icmp_seq=1 ttl=64 time=0.7 ms
64 bytes from 192.168.1.5: icmp_seq=2 ttl=64 time=0.7 ms
64 bytes from 192.168.1.5: icmp_seq=3 ttl=64 time=0.7 ms
64 bytes from 192.168.1.5: icmp_seq=4 ttl=64 time=0.8 ms

--- 192.168.5.5 ping statistics ---
5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max = 0.7/0.8/1.2 ms
REMOVE-END */

	this.removeAllData();
	for (i = 0; i < buf.length; ++i) {
		if (r = buf[i].match(/^(\d+) bytes from (.+): .*seq=(\d+) ttl=(\d+) time=(\d+\.\d+) ms/)) {
			r.splice(0, 1);
			t = r[0];
			r[0] = r[2];
			r[2] = t;
			if (resolv[r[1]]) r[1] = resolv[r[1]] + ' (' + r[1] + ')';
			r[4] *= 1;
			r[5] = (last > 0) ? (r[4] - last).toFixed(2) : '';
			r[4] = r[4].toFixed(2);
			this.insertData(-1, r)
			last = r[4];
		}
		else if (buf[i].match(/^PING (.+) \((.+)\)/)) {
			resolv[RegExp.$2] = RegExp.$1;
		}
		else if (buf[i].match(/^(\d+) packets.+, (\d+) packets.+, (\d+%)/)) {
			stats = '   Packets: ' + RegExp.$1 + ' transmitted, ' + RegExp.$2 + ' received, ' + RegExp.$3 + ' lost<br>';
		}
		else if (buf[i].match(/^round.+ (\d+\.\d+)\/(\d+\.\d+)\/(\d+\.\d+)/)) {
			stats = 'Round-Trip: ' + RegExp.$1 + ' min, ' + RegExp.$2 + ' avg, ' + RegExp.$3 + ' max (ms)<br>' + stats;
		}
	}

	E('stats').innerHTML = stats;
	E('debug').value = pingdata;
	pingdata = '';
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

	return v_range('_f_count', quiet, 1, 50) && v_range('_f_size', quiet, 1, 10240);
}


var pinger = null;

function spin(x)
{
	E('pingb').disabled = x;
	E('_f_addr').disabled = x;
	E('_f_count').disabled = x;
	E('_f_size').disabled = x;
	E('wait').style.visibility = x ? 'visible' : 'hidden';
	if (!x) pinger = null;
}

function ping()
{
	// Opera 8 sometimes sends 2 clicks
	if (pinger) return;

	if (!verifyFields(null, 0)) return;

	spin(1);

	pinger = new XmlHttp();
	pinger.onCompleted = function(text, xml) {
		eval(text);
		pg.populate();
	}
	pinger.onError = function(x) {
		alert('error: ' + x);
		spin(0);
	}

	var addr = E('_f_addr').value;
	var count = E('_f_count').value;
	var size = E('_f_size').value;
	pinger.post('ping.cgi', 'addr=' + addr + '&count=' + count + '&size=' + size);

	cookie.set('pingaddr', addr);
	cookie.set('pingcount', count);
	cookie.set('pingsize', size);
}

function init()
{
	var s;

	if ((s = cookie.get('pingaddr')) != null) E('_f_addr').value = s;
	if ((s = cookie.get('pingcount')) != null) E('_f_count').value = s;
	if ((s = cookie.get('pingsize')) != null) E('_f_size').value = s;

	E('_f_addr').onkeypress = function(ev) { if (checkEvent(ev).keyCode == 13) ping(); }
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

						<div class='section-title'>Ping</div>
						<div class='section'>
						<script type='text/javascript'>
						createFieldTable('', [
							{ title: 'Address', name: 'f_addr', type: 'text', maxlen: 64, size: 32, value: '',
								suffix: ' <input type="button" value="Ping" onclick="ping()" id="pingb">' },
							{ title: 'Ping Count', name: 'f_count', type: 'text', maxlen: 2, size: 7, value: '5' },
							{ title: 'Packet Size', name: 'f_size', type: 'text', maxlen: 5, size: 7, value: '56', suffix: ' <small>(bytes)</small>' }
						]);
						</script>
						</div>

						<div style="visibility:hidden;text-align:right" id="wait">Please wait... <img src='spin.gif' style="vertical-align:top"></div>

						<table id='tp-grid' class='tomato-grid' cellspacing=1></table>
						<pre id='stats'></pre>

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
<script type='text/javascript'>pg.setup()</script>
</body>
</HTML>
