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

<script type='text/javascript'>

//	<% nvram("wl_macmode,wl_maclist,macnames"); %>

var smg = new TomatoGrid();

smg.verifyFields = function(row, quiet) {
	return v_mac(fields.getAll(row)[0], quiet);
}

smg.resetNewEditor = function() {
	var f, c, n;

	f = fields.getAll(this.newEditor);
	ferror.clearAll(f);
	
	if ((c = cookie.get('addmac')) != null) {
		cookie.set('addmac', '', 0);
		c = c.split(',');
		if (c.length == 2) {
			f[0].value = c[0];
			f[1].value = c[1];
			return;
		}
	}

	f[0].value = '00:00:00:00:00:00';
	f[1].value = '';
}

smg.setup = function() {
	var i, i, m, s, t, n;
	var macs, names;
	
	this.init('sm-grid', 'sort', 100, [
		{ type: 'text', maxlen: 17 },
		{ type: 'text', maxlen: 48 }
	]);
	this.headerSet(['MAC Address', 'Description']);
	macs = nvram.wl_maclist.split(/\s+/);
	names = nvram.macnames.split('>');
	for (i = 0; i < macs.length; ++i) {
		m = fixMAC(macs[i]);
		if ((m) && (!isMAC0(m))) {
			s = m.replace(/:/g, '');
			t = '';
			for (j = 0; j < names.length; ++j) {
				n = names[j].split('<');
				if ((n.length == 2) && (n[0] == s)) {
					t = n[1];
					break;
				}
			}
			this.insertData(-1, [m, t]);
		}
	}
	this.sort(0);
	this.showNewEditor();
	this.resetNewEditor();
}

function save()
{
	var fom;
	var d, i, macs, names, ma, na;
	
	if (smg.isEditing()) return;

	fom = E('_fom');
	
	macs = [];
	names = [];
	d = smg.getAllData();
	for (i = 0; i < d.length; ++i) {
		ma = d[i][0];
		na = d[i][1].replace(/[<>|]/g, '');
		
		macs.push(ma);
		if (na.length) {
			names.push(ma.replace(/:/g, '') + '<' + na);
		}
	}
	fom.wl_maclist.value = macs.join(' ');
	fom.wl_macmode.value = E('_f_disable').checked ? 'disabled' : (E('_f_deny').checked ? 'deny' : 'allow');
	fom.macnames.value = names.join('>');
	form.submit(fom, 1);
}

function earlyInit()
{
	smg.setup();
	if (nvram.wl_macmode == 'allow') E('_f_allow').checked = 1;
		else if (nvram.wl_macmode == 'deny') E('_f_deny').checked = 1;
		else E('_f_disable').checked = 1;
}

function init()
{
	smg.recolor();
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
                        
                        <input type='hidden' name='_nextpage' value='basic-wfilter.asp'>
                        <input type='hidden' name='_nextwait' value='10'>
                        <input type='hidden' name='_service' value='*'>
                        
                        <input type='hidden' name='wl_macmode'>
                        <input type='hidden' name='wl_maclist'>
                        <input type='hidden' name='macnames'>
                        
                        
                        <div class='section-title'>Wireless Client Filter</div>
                        <div class='section'>
                            <input type='radio' name='f_type' id='_f_disable' value='disabled'> Disable Filter<br>
                            <input type='radio' name='f_type' id='_f_allow' value='allow'> Permit Only The Following Clients<br>
                            <input type='radio' name='f_type' id='_f_deny' value='deny'> Block The Following Clients<br>
                            <br>
                            <table id='sm-grid' class='tomato-grid'></table>
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
                        <script type='text/javascript'>earlyInit()</script>
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
