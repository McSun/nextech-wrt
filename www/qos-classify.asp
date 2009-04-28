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
#qg div {
	padding: 0 0 1px 0;
	margin: 0;
}

#qg .co1 {
	width: 370px;
}
#qg .co2 {
	width: 80px;
}
#qg .co3 {
	width: 300px;
}

#qg .x1a {
	width: 35%;
	float: left;
}
#qg .x1b {
	width: 64%;
	float: left;
}

#qg .x2a {
	width: 35%;
	float: left;
	clear: left;
}
#qg .x2b {
	width: 23%;
	float: left;
}
#qg .x2c {
	width: 41%;
	float: left;
}

#qg .x3a {
	width: 40%;
	float: left;
	clear: left;
}
#qg .x3b {
	width: 60%;
	float: left;
}

#qg .x4a {
	float: left;
	clear: left;
	width: 70px;
}
#qg .x4b {
	float: left;
	padding: 2px 8px 0 8px;
	width: 10px;
	text-align: center;
}
#qg .x4c {
	float: left;
	width: 70px;
}
#qg .x4d {
	float: left;
	padding: 2px 0 0 8px;
	width: 100px;
}

</style>
<script type='text/javascript'>

//	<% nvram("qos_enable,qos_orules"); %>

var abc = ['Highest', 'High', 'Medium', 'Low', 'Lowest', 'A','B','C','D','E'];

var ipp2p = [
	[0,'IPP2P (disabled)'],[0xFFF,'All IPP2P filters'],[1,'AppleJuice'],[2,'Ares'],[4,'BitTorrent'],[8,'Direct Connect'],
	[16,'eDonkey'],[32,'Gnutella'],[64,'Kazaa'],[128,'Mute'],[256,'SoulSeek'],[512,'Waste'],[1024,'WinMX'],[2048,'XDCC']]

// <% layer7(); %>
layer7.sort();
for (i = 0; i < layer7.length; ++i)
	layer7[i] = [layer7[i],layer7[i]];
layer7.unshift(['', 'Layer 7 (disabled)']);

var class1 = [[-1,'Disabled']];
for (i = 0; i < 10; ++i) class1.push([i, abc[i]]);
var class2 = class1.slice(1);

var qosg = new TomatoGrid();

qosg.dataToView = function(data) {
	var b = [];
	var s, i;

	if (data[0] != 0) {
		b.push(((data[0] == 1) ? 'To ' : 'From ') + data[1]);
	}
	if (data[2] >= -1) {
		if (data[2] == -1) b.push('TCP/UDP');
			else if (data[2] >= 0) b.push(protocols[data[2]] || data[2]);
		if (data[3] != 'a') {
			if (data[3] == 'd') s = 'Dst ';
				else if (data[3] == 's') s = 'Src ';
					else s = '';
			b.push(s + 'Port: ' + data[4].replace(/:/g, '-'));
		}
	}
	if (data[5] != 0) {
		for (i = 0; i < ipp2p.length; ++i)
			if (ipp2p[i][0] == data[5]) {
				b.push('IPP2P: ' + ipp2p[i][1])
				break;
			}

	}
	else if (data[6] != '') {
		b.push('L7: ' + data[6])
	}
	
	if (data[7] != '') {
		b.push('Transferred: ' + data[7] + ((data[8] == '') ? '<small>KB+</small>' : (' - ' + data[8] + '<small>KB</small>')));
	}
	return [b.join('<br>'), class1[(data[9] * 1) + 1][1], escapeHTML(data[10])];
}

qosg.fieldValuesToData = function(row) {
	var f = fields.getAll(row);
	var proto = f[2].value;
	var dir = f[3].value;
	if ((proto != -1) && (proto != 6) && (proto != 17)) dir = 'a';
	return [f[0].value, f[0].selectedIndex ? f[1].value : '',
			proto, dir, (dir != 'a') ? f[4].value : '',
			f[5].value, f[6].value, f[7].value, f[8].value, f[9].value, f[10].value];
}

qosg.resetNewEditor = function() {
	var f = fields.getAll(this.newEditor);
	f[0].selectedIndex = 0;
	f[1].value = '';
	f[2].selectedIndex = 1;
	f[3].selectedIndex = 0;
	f[4].value = '';
	f[5].selectedIndex = 0;
	f[6].selectedIndex = 0;
	f[7].value = '';
	f[8].value = '';
	f[9].selectedIndex = 5;
	f[10].value = '';
	this.enDiFields(this.newEditor);
	ferror.clearAll(fields.getAll(this.newEditor));
}

qosg._disableNewEditor = qosg.disableNewEditor;
qosg.disableNewEditor = function(disable) {
	qosg._disableNewEditor(disable);
	if (!disable) {
		this.enDiFields(this.newEditor);
	}
}

qosg.enDiFields = function(row) {
	var f = fields.getAll(row);
	var x;

	f[1].disabled = (f[0].selectedIndex == 0);
	x = f[2].value;
	x = ((x != -1) && (x != 6) && (x != 17));
	f[3].disabled = x;
	if (f[3].selectedIndex == 0) x = 1;
	f[4].disabled = x;

	f[6].disabled = (f[5].selectedIndex != 0);
	f[5].disabled = (f[6].selectedIndex != 0);
}

qosg.verifyFields = function(row, quiet) {
	var f = fields.getAll(row);
	var a, b, e;

	this.enDiFields(row);
	ferror.clearAll(f);

	a = f[0].value * 1;
	if ((a == 1) || (a == 2)) {
		if (!v_iptip(f[1], quiet)) return 0;
	}
	else if ((a == 3) && (!v_mac(f[1], quiet))) return 0;

	b = f[2].selectedIndex;
	if ((b > 0) && (b <= 3) && (f[3].selectedIndex != 0) && (!v_iptport(f[4], quiet))) return 0;

	var BMAX = 1024 * 1024;

	e = f[7];
	a = e.value = e.value.trim();
	if (a != '') {
		if (!v_range(e, quiet, 0, BMAX)) return 0;
		a *= 1;
	}
		
	e = f[8];
	b = e.value = e.value.trim();
	if (b != '') {
		b *= 1;
		if (b >= BMAX) e.value = '';
			else if (!v_range(e, quiet, 0, BMAX)) return 0;
		if (a == '') f[7].value = a = 0;
	}
	else if (a != '') {
		b = BMAX;
	}
	
	if ((b != '') && (a >= b)) {
		ferror.set(f[7], 'Invalid range', quiet);
		return 0;
	}
	
	return v_length(f[10], quiet);
}

qosg.setup = function() {
	var i, a, b;
	a = [[-2, 'Any Protocol'],[-1,'TCP/UDP'],[6,'TCP'],[17,'UDP']];
	for (i = 0; i < 256; ++i) {
		if ((i != 6) && (i != 17)) a.push([i, protocols[i] || i]);
	}

	// what a mess...
	this.init('qg', 'move', 50, [
		{ multi: [
			{ type: 'select', options: [[0,'Any Address'],[1,'Dst IP'],[2,'Src IP'],[3,'Src MAC']],
				prefix: '<div class="x1a">', suffix: '</div>' },
			{ type: 'text', prefix: '<div class="x1b">', suffix: '</div>' },
			{ type: 'select', prefix: '<div class="x2a">', suffix: '</div>', options: a },
			{ type: 'select', prefix: '<div class="x2b">', suffix: '</div>',
				options: [['a','Any Port'],['d','Dst Port'],['s','Src Port'],['x','Src or Dst']] },
            { type: 'text', prefix: '<div class="x2c">', suffix: '</div>' },
			{ type: 'select', prefix: '<div class="x3a">', suffix: '</div>', options: ipp2p },
			{ type: 'select', prefix: '<div class="x3b">', suffix: '</div>', options: layer7 },
			
			{ type: 'text', prefix: '<div class="x4a">', suffix: '</div>' },
			{ type: 'text', prefix: '<div class="x4b"> - </div><div class="x4c">', suffix: '</div><div class="x4d">KB Transferred</div>' }
			
		] },
		{ type: 'select', options: class1, vtop: 1 },
		{ type: 'text', maxlen: 32, vtop: 1 }
	]);

	this.headerSet(['Match Rule', 'Class', 'Description']);

// addr_type < addr < proto < port_type < port < ipp2p < L7 < bcount < class < desc
	
	a = nvram.qos_orules.split('>');
	for (i = 0; i < a.length; ++i) {
		b = a[i].split('<');
		if (b.length == 9) {
			// fixup < 0.08		!!! temp
			b.splice(7, 0, '', '');
		}
		else if (b.length == 10) {
			c = b[7].split(':');
			b.splice(7, 1, c[0], (c.length == 1) ? '' : c[1]);
			b[10] = unescape(b[10]);
		}
		else continue;
		b[4] = b[4].replace(/:/g, '-');
		qosg.insertData(-1, b);
	}

	this.showNewEditor();
	this.resetNewEditor();
}

function verifyFields(focused, quiet)
{
	return 1;
}

function save()
{
	if (qosg.isEditing()) return;

	var fom = E('_fom');
	var i, a, b, c;

	c = qosg.getAllData();
	a = [];
	for (i = 0; i < c.length; ++i) {
		b = c[i].slice(0);
		b[4] = b[4].replace(/-/g, ':');
		b.splice(7, 2, (b[7] == '') ? '' : [b[7],b[8]].join(':'));
		b[9] = escapeD(b[9]);
		a.push(b.join('<'));
	}
	fom.qos_orules.value = a.join('>');

	form.submit(fom, 1);
}

function init()
{
	qosg.recolor();
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
                      <table id='container' cellspacing=0>
                      <tr id='body'>
                      <td id='content'>
                      <div id='ident'><% ident(); %></div>
                      
                      <!-- / / / -->
                      
                      <input type='hidden' name='_nextpage' value='qos-classify.asp'>
                      <input type='hidden' name='_service' value='qos-restart'>
                      <input type='hidden' name='qos_orules'>
                      
                      <div class='section-title'>Outbound Direction</div>
                      <div class='section'>
                          <table class='tomato-grid' cellspacing=1 id='qg'></table>
                      </div>
                      
                      <script type='text/javascript'>
                      if (nvram.qos_enable != '1') {
                          W('<div class="note-disabled"><b>QoS disabled.</b> &nbsp; <a href="qos-settings.asp">Enable &raquo;</a></div>');
                      }
                      </script>
                      
                      <!-- / / / -->
                      
                      </td></tr>
                      <tr><td id='footer' colspan=2>
                          <span id='footer-msg'></span>
                          <input type='button' value='Save' id='save-button' onclick='save()'>
                          <input type='button' value='Cancel' id='cancel-button' onclick='reloadPage();'>
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
