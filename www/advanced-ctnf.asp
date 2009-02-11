<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<script type='text/javascript'>

//	<% nvram("ct_tcp_timeout,ct_udp_timeout,ct_max,nf_l7in,nf_ttl,nf_rtsp,nf_pptp,nf_h323,nf_ftp"); %>

var checker = null;
var timer = new TomatoTimer(check);
var running = 0;

function check()
{
	timer.stop();
	if ((checker) || (!running)) return;

	checker = new XmlHttp();
	checker.onCompleted = function(text, xml) {
		var conntrack, total, i;
		conntrack = null;
		total = 0;
		try {
			eval(text);
		}
		catch (ex) {
			conntrack = [];
		}
		for (i = 1; i < 13; ++i) {
			E('count' + i).innerHTML = '&nbsp; <small>('+ ((conntrack[i] || 0) * 1) + ' in this state)</small>';
		}
		E('count0').innerHTML = '(' + ((conntrack[0] || 0) * 1) + ' connections currently tracked)';
		checker = null;
		timer.start(3000);
	}
	checker.onError = function(x) {
		checker = null;
		timer.start(6000);
	}

	checker.post('update.cgi', 'exec=ctcount&arg0=0');
}

function clicked()
{
	running ^= 1;
	E('spin').style.visibility = running ? 'visible' : 'hidden';
	if (running) check();
}


var expireText;

function expireTimer()
{
	var e = E('expire');

	if (!expireText) expireText = e.value;

	if (--expireTime == 0) {
		e.disabled = false;
		e.value = expireText;
	}
	else {
		setTimeout(expireTimer, 1000);
		e.value = 'Expire Scheduled... ' + expireTime;
	}
}

function expireClicked()
{
	expireTime = 18;
	E('expire').disabled = true;
	(new XmlHttp()).post('expct.cgi', '');
	expireTimer();
}


function verifyFields(focused, quiet)
{
	var i, v;

	for (i = 0; i < 10; ++i) {
		if (!v_range('_f_tcp_' + i, quiet, 1, 432000)) return 0;
	}
	for (i = 0; i < 2; ++i) {
		if (!v_range('_f_udp_' + i, quiet, 1, 432000)) return 0;
	}
	return v_range('_ct_max', quiet, 128, 10240);
}

function save()
{
	var i, tcp, udp, fom;

	if (!verifyFields(null, false)) return;

	tcp = [];
	for (i = 0; i < 10; ++i) {
		tcp.push(E('_f_tcp_' + i).value);
	}
	
	udp = [];
	for (i = 0; i < 2; ++i) {
		udp.push(E('_f_udp_' + i).value);
	}
	
	fom = E('_fom');
	fom.ct_tcp_timeout.value = tcp.join(' ');
	fom.ct_udp_timeout.value = udp.join(' ');
	fom.nf_l7in.value = E('_f_l7in').checked ? 1 : 0;
	fom.nf_rtsp.value = E('_f_rtsp').checked ? 1 : 0;
	fom.nf_pptp.value = E('_f_pptp').checked ? 1 : 0;
	fom.nf_h323.value = E('_f_h323').checked ? 1 : 0;
	fom.nf_ftp.value = E('_f_ftp').checked ? 1 : 0;
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
                        <form id='_fom' method='post' action='tomato.cgi'>
                        <table id='container' cellspacing=0>
                        <tr><td colspan=2 id='header'>
                            <div class='title'>Tomato</div>
                            <div class='version'>Version <% version(); %></div>
                        </td></tr>
                        <tr id='body'><td id='navi'><script type='text/javascript'>navi()</script></td>
                        <td id='content'>
                        <div id='ident'><% ident(); %></div>
                        
                        <!-- / / / -->
                        
                        <input type='hidden' name='_nextpage' value='advanced-ctnf.asp'>
                        <input type='hidden' name='_service' value='ctnf-restart'>
                        
                        <input type='hidden' name='ct_tcp_timeout' value=''>
                        <input type='hidden' name='ct_udp_timeout' value=''>
                        <input type='hidden' name='nf_l7in' value=''>
                        <input type='hidden' name='nf_rtsp'>
                        <input type='hidden' name='nf_pptp'>
                        <input type='hidden' name='nf_h323'>
                        <input type='hidden' name='nf_ftp'>
                        
                        <div class='section-title'>Connections</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        createFieldTable('', [
                            { title: 'Maximum Connections', name: 'ct_max', type: 'text', maxlen: 5, size: 7,
                                suffix: '&nbsp; <a href="javascript:clicked()" id="count0">[ count current... ]</a> <img src="spin.gif" style="vertical-align:bottom;padding-left:10px;visibility:hidden" id="spin" onclick="clicked()">',
                                value: fixInt(nvram.ct_max || 4096, 128, 10240, 4096) }
                        ]);
                        </script>
                        <br>
                        <input type='button' value='Drop Idle' onclick='expireClicked()' id='expire'>
                        <br><br>
                        </div>
                        
                        
                        <div class='section-title'>TCP Timeout</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        if ((v = nvram.ct_tcp_timeout.match(/^(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)$/)) == null) {
                            v = [0,1800,14400,120,60,120,120,10,60,30,120];
                        }
                        titles = ['-', 'None', 'Established', 'SYN Sent', 'SYN Received', 'FIN Wait', 'Time Wait', 'Close', 'Close Wait', 'Last ACK', 'Listen'];
                        f = [{ title: ' ', text: '<small>(seconds)</small>' }];
                        for (i = 1; i < 11; ++i) {
                            f.push({ title: titles[i], name: ('f_tcp_' + (i - 1)),
                                type: 'text', maxlen: 6, size: 8, value: v[i],
                                suffix: '<span id="count' + i + '"></span>' });
                        }
                        createFieldTable('', f);
                        </script>
                        </div>
                        
                        <div class='section-title'>UDP Timeout</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        if ((v = nvram.ct_udp_timeout.match(/^(\d+)\s+(\d+)$/)) == null) {
                            v = [0,30,180];
                        }
                        createFieldTable('', [
                            { title: ' ', text: '<small>(seconds)</small>' },
                            { title: 'Unreplied', name: 'f_udp_0', type: 'text', maxlen: 6, size: 8, value: v[1], suffix: '<span id="count11"></span>' },
                            { title: 'Assured', name: 'f_udp_1', type: 'text', maxlen: 6, size: 8, value: v[2], suffix: '<span id="count12"></span>' }
                        ]);
                        </script>
                        </div>
                        
                        <div class='section-title'>Tracking / NAT Helpers</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        createFieldTable('', [
                            { title: 'FTP', name: 'f_ftp', type: 'checkbox', value: nvram.nf_ftp != '0' },
                            { title: 'GRE / PPTP', name: 'f_pptp', type: 'checkbox', value: nvram.nf_pptp != '0' },
                            { title: 'H.323', name: 'f_h323', type: 'checkbox', value: nvram.nf_h323 != '0' },
                            { title: 'RTSP', name: 'f_rtsp', type: 'checkbox', value: nvram.nf_rtsp != '0' }
                        ]);
                        </script>
                        </div>
                        
                        <div class='section-title'>Miscellaneous</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        v = [];
                        for (i = -5; i <= 5; ++i) {
                            v.push([i, i ? ((i > 0) ? '+' : '') + i : 'None']);
                        }
                        createFieldTable('', [
                            { title: 'TTL Adjust', name: 'nf_ttl', type: 'select', options: v, value: nvram.nf_ttl },
                            { title: 'Inbound Layer 7', name: 'f_l7in', type: 'checkbox', value: nvram.nf_l7in != '0' }
                        ]);
                        </script>
                        </div>
                        
                        <!-- / / / -->
                        
                        </td></tr>
                        <tr><td id='footer' colspan=2>
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
                        </td></tr>
                        </table>
                        </form>
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
          <td valign=bottom class="CopyRight" align=right nowrap colspan="2"
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
