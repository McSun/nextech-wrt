<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<script type='text/javascript'>

//	<% nvram("cifs1,cifs2"); %>

function v_nodelim(e, quiet, name)
{
	e.value = e.value.trim();
	if (e.value.indexOf('<') != -1) {
		ferror.set(e, 'Invalid ' + name, quiet);
		return 0;
	}
	ferror.clear(e);
	return 1;
}

function verifyFields(focused, quiet)
{
	var i, p, b;
	var unc, user, pass, dom, exec;

	for (i = 1; i <= 2; ++i) {
		p = '_f_cifs' + i;
		unc = E(p + '_unc');
		user = E(p + '_user');
		pass = E(p + '_pass');
		dom = E(p + '_dom');
		exec = E(p + '_exec');

		b = !E(p + '_enable').checked;
		unc.disabled = b;
		user.disabled = b;
		pass.disabled = b;
		exec.disabled = b;
		dom.disabled = b;
		if (!b) {
			if ((!v_nodelim(unc, quiet, 'UNC')) || (!v_nodelim(user, quiet, 'username')) || (!v_nodelim(pass, quiet, 'password')) ||
				 (!v_nodelim(dom, quiet, 'domain')) || (!v_nodelim(exec, quiet, 'exec path'))) return 0;
			if ((!v_length(user, quiet, 1)) || (!v_length(pass, quiet, 1))) return 0;
			unc.value = unc.value.replace(/\//g, '\\');
			if (!unc.value.match(/^\\\\.+\\/)) {
				ferror.set(unc, 'Invalid UNC', quiet);
				return 0;
			}
		}
		else {
			ferror.clear(unc, user, pass, dom, exec);
		}
	}

	return 1;
}

function save()
{
	var i, p;

	if (!verifyFields(null, 0)) return;

	for (i = 1; i <= 2; ++i) {
		p = '_f_cifs' + i;
		E('cifs' + i).value = (E(p + '_enable').checked ? '1' : '0') + '<' + E(p + '_unc').value + '<' +
			E(p + '_user').value + '<' + E(p + '_pass').value + '<' + E(p + '_dom').value + '<' + E(p + '_exec').value
	}
	form.submit('_fom', 0);
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
                        
                        <input type='hidden' name='_nextpage' value='admin-cifs.asp'>
                        <input type='hidden' name='_nextwait' value='10'>
                        <input type='hidden' name='_service' value='cifs-restart'>
                        
                        <input type='hidden' name='cifs1' id='cifs1'>
                        <input type='hidden' name='cifs2' id='cifs2'>
                        
                        <div class='section-title'>CIFS Client</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        a = b = [0, '\\\\192.168.1.5\\shared_example', '', '', '', ''];
                        
                        if (r = nvram.cifs1.match(/^(0|1)<(\\\\.+)<(.*)<(.*)<(.*)<(.*)$/)) a = r.splice(1, 6);
                        if (r = nvram.cifs2.match(/^(0|1)<(\\\\.+)<(.*)<(.*)<(.*)<(.*)$/)) b = r.splice(1, 6);
                        
                        //	<% statfs("/cifs1", "cifs1"); %>
                        //	<% statfs("/cifs2", "cifs2"); %>
                        
                        createFieldTable('', [
                            { title: '/cifs1' },
                            { title: 'Enable', indent: 2, name: 'f_cifs1_enable', type: 'checkbox', value: a[0]*1 },
                            { title: 'UNC', indent: 2, name: 'f_cifs1_unc', type: 'text', maxlen: 128, size: 64, value: a[1] },
                            { title: 'Username', indent: 2, name: 'f_cifs1_user', type: 'text', maxlen: 32, size: 34, value: a[2] },
                            { title: 'Password', indent: 2, name: 'f_cifs1_pass', type: 'password', maxlen: 16, size: 34, value: a[3] },
                            { title: 'Domain', indent: 2, name: 'f_cifs1_dom', type: 'text', maxlen: 32, size: 34, value: a[4] },
                            { title: 'Execute When Mounted', indent: 2, name: 'f_cifs1_exec', type: 'text', maxlen: 64, size: 34, value: a[5] },
                            { title: 'Total / Free Size', indent: 2, text: cifs1.size ? (scaleSize(cifs1.size) + ' / ' + scaleSize(cifs1.free)) : '(not mounted)' },
                            null,
                            { title: '/cifs2' },
                            { title: 'Enable', indent: 2, name: 'f_cifs2_enable', type: 'checkbox', value: b[0]*1 },
                            { title: 'UNC', indent: 2, name: 'f_cifs2_unc', type: 'text', maxlen: 128, size: 64, value: b[1] },
                            { title: 'Username', indent: 2, name: 'f_cifs2_user', type: 'text', maxlen: 64, size: 34, value: b[2] },
                            { title: 'Password', indent: 2, name: 'f_cifs2_pass', type: 'password', maxlen: 16, size: 34, value: b[3] },
                            { title: 'Domain', indent: 2, name: 'f_cifs2_dom', type: 'text', maxlen: 32, size: 34, value: b[4] },
                            { title: 'Execute When Mounted', indent: 2, name: 'f_cifs2_exec', type: 'text', maxlen: 64, size: 34, value: b[5] },
                            { title: 'Total / Free Size', indent: 2, text: cifs2.size ? (scaleSize(cifs2.size) + ' / ' + scaleSize(cifs2.free)) : '(not mounted)' }
                        ]);
                        </script>
                        </div>
                        
                        <script type='text/javascript'>show_notice1('<% notice("cifs"); %>');</script>
                        
                        
                        <!-- / / / -->
                        
                        </td></tr>
                        <tr><td id='footer' colspan=2>
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
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
