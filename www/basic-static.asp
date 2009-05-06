<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style tyle='text/css'>
#bs-grid {
	width: 600px;
}
#bs-grid .co1,
#bs-grid .co2 {
	width: 130px;
}
#bs-grid .co3 {
	width: 340px;
}
</style>
<script type='text/javascript'>

//	<% nvram("lan_ipaddr,lan_netmask,dhcpd_static,dhcpd_startip"); %>

if (nvram.lan_ipaddr.match(/^(\d+\.\d+\.\d+)\.(\d+)$/)) ipp = RegExp.$1 + '.';
	else ipp = '?.?.?.';

autonum = aton(nvram.lan_ipaddr) & aton(nvram.lan_netmask);

var sg = new TomatoGrid();

sg.exist = function(f, v)
{
	var data = this.getAllData();
	for (var i = 0; i < data.length; ++i) {
		if (data[i][f] == v) return true;
	}
	return false;
}

sg.existMAC = function(mac)
{
	if (mac == "00:00:00:00:00:00") return false;
	return this.exist(0, mac);
}

sg.existName = function(name)
{
	return this.exist(2, name);
}

sg.inStatic = function(n)
{
	return this.exist(1, n);
}

sg.sortCompare = function(a, b) {
	var da = a.getRowData();
	var db = b.getRowData();
	var r = 0;
	switch (this.sortColumn) {
	case 0:
		r = cmpText(da[0], db[0]);
		break;
	case 1:
		r = cmpIP(da[1], db[1]);
		break;
	}
	if (r == 0) r = cmpText(da[2], db[2]);
	return this.sortAscending ? r : -r;
}

sg.verifyFields = function(row, quiet)
{
	var f, s;

	f = fields.getAll(row);

	if (!v_macz(f[0], quiet)) return 0;
	if (this.existMAC(f[0].value)) {
		ferror.set(f[0], 'Duplicate MAC address', quiet);
		return 0;
	}

	if (f[1].value.indexOf('.') == -1) {
		s = parseInt(f[1].value, 10)
		if (isNaN(s) || (s <= 0) || (s >= 255)) {
			ferror.set(f[1], 'Invalid IP address', quiet);
			return 0;
		}
		f[1].value = ipp + s;
	}

	if ((f[0].value != "00:00:00:00:00:00") && (this.inStatic(f[1].value))) {
		ferror.set(f[1], 'Duplicate IP address', quiet);
		return 0;
	}

	s = f[2].value.trim().replace(/\s+/g, ' ');
	if (s.length > 0) {
		if (s.search(/^[.a-zA-Z0-9_\- ]+$/) == -1) {
			ferror.set(f[2], 'Invalid name. Only characters "A-Z 0-9 . - _" are allowed.', quiet);
			return 0;
		}
		if (this.existName(s)) {
			ferror.set(f[2], 'Duplicate name.', quiet);
			return 0;
		}
		f[2].value = s;
	}

	if (f[0].value == '00:00:00:00:00:00') {
		if (s == '') {
			s = 'Both MAC address and name fields must not be empty.';
			ferror.set(f[0], s, 1);
			ferror.set(f[2], s, quiet);
			return 0;
		}
	}

	return 1;
}

sg.resetNewEditor = function() {
	var f, c, n;

	f = fields.getAll(this.newEditor);
	ferror.clearAll(f);

	if ((c = cookie.get('addstatic')) != null) {
		cookie.set('addstatic', '', 0);
		c = c.split(',');
		if (c.length == 3) {
			f[0].value = c[0];
			f[1].value = c[1];
			f[2].value = c[2];
			return;
		}
	}

	f[0].value = '00:00:00:00:00:00';
	f[2].value = '';

	n = 10;
	do {
		if (--n < 0) {
			f[1].value = '';
			return;
		}
		autonum++;
	} while (((c = fixIP(ntoa(autonum), 1)) == null) || (c == nvram.lan_ipaddr) || (this.inStatic(c)));

	f[1].value = c;
}

sg.setup = function()
{
	this.init('bs-grid', 'sort', 100,
		[{ type: 'text', maxlen: 17 }, { type: 'text', maxlen: 15 }, { type: 'text', maxlen: 32 }]);
	this.headerSet(['MAC Address', 'IP Address', 'Hostname']);
	var s = nvram.dhcpd_static.split('>');
	for (var i = 0; i < s.length; ++i) {
		var t = s[i].split('<');
		if (t.length == 3) {
			if (t[1].indexOf('.') == -1) t[1] = ipp + t[1];
			this.insertData(-1, t);
		}
	}
	this.sort(2);
	this.showNewEditor();
	this.resetNewEditor();
}

function save()
{
	if (sg.isEditing()) return;

	var data = sg.getAllData();
	var sdhcp = '';
	var i;

	for (i = 0; i < data.length; ++i) {
		sdhcp += data[i].join('<') + '>';
	}

	var fom = E('_fom');
	fom.dhcpd_static.value = sdhcp;
	form.submit(fom, 1);
}

function init()
{
	sg.recolor();
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
                        
                        <input type='hidden' name='_nextpage' value='basic-static.asp'>
                        <input type='hidden' name='_service' value='dhcpd-restart'>
                        
                        <input type='hidden' name='dhcpd_static'>
                        
                        <div class='section-title'>Static DHCP</div>
                        <div class='section'>
                        <table class='tomato-grid' id='bs-grid'></table>
                        </div>
                        
                        
                        <!-- / / / -->
                        
                        <span id='footer-msg'></span>
                        	<input type='button' value='Save' id='save-button' onclick='save()'>
                        	<input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
                        <script type='text/javascript'>sg.setup();</script>
					</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
            <h3>Brainy Bunch Help</h3>
            <p> Enter the  MAC address of the device you want to have a permanent ip address. </p>	
            <p> Enter the permenant IP address you wish to assign to your PC. </p>
            <p> Name of device  you are going to use permanate IP address with. </p>
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
