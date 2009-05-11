<!DOCTYPE HTML PUBLIC '-//w3c//dtd html 4.0 transitional//en'>
<html>
<head>
<link rel="shortcut icon" href="favicon.ico">
<title>Nex-Tech Lightning Jack Internet</title>
<link rel="stylesheet" href="gray.css" type="text/css" />
<script type='text/javascript' src='wrt.js'></script>
<style type='text/css'>
textarea {
	width: 98%;
	height: 15em;
}
</style>
<script type='text/javascript'>

//	<% nvram("dhcpd_dmdns,dns_addget,dns_intcpt,dhcpd_slt,dhcpc_minpkt,dnsmasq_custom,dnsmasq_norw,dhcpd_lmax"); %>

if ((isNaN(nvram.dhcpd_lmax)) || ((nvram.dhcpd_lmax *= 1) < 1)) nvram.dhcpd_lmax = 255;

function verifyFields(focused, quiet)
{
	var b = (E('_f_dhcpd_sltsel').value == 1);
	elem.display('_dhcpd_sltman', b);
	if ((b) && (!v_range('_f_dhcpd_slt', quiet, 1, 43200))) return 0;
	if (!v_length('_dnsmasq_custom', quiet, 0, 2048)) return 0;
	if (!v_range('_dhcpd_lmax', quiet, 1, 0xFFFF)) return 0;
	return 1;
}

function save()
{
	if (!verifyFields(null, false)) return;

	var a;
	var fom = E('_fom');

	fom.dhcpd_dmdns.value = E('_f_dhcpd_dmdns').checked ? 1 : 0;
	a = E('_f_dhcpd_sltsel').value;
	fom.dhcpd_slt.value = (a != 1) ? a : E('_f_dhcpd_slt').value;
	fom.dns_addget.value = E('_f_dns_addget').checked ? 1 : 0;
	fom.dns_intcpt.value = E('_f_dns_intcpt').checked ? 1 : 0;
	fom.dhcpc_minpkt.value = E('_f_dhcpc_minpkt').checked ? 1 : 0;
	
	if (fom.dhcpc_minpkt.value != nvram.dhcpc_minpkt) {
		nvram.dhcpc_minpkt = fom.dhcpc_minpkt.value;
		fom._service.value = '*';
	}
	else {
		fom._service.value = 'dnsmasq-restart';
	}
	
	if (fom.dns_intcpt.value != nvram.dns_intcpt) {
		nvram.dns_intcpt = fom.dns_intcpt.value;
		if (fom._service.value != '*') fom._service.value += ',firewall-restart';
	}	

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
                        
                        <input type='hidden' name='_nextpage' value='advanced-dhcpdns.asp'>
                        <input type='hidden' name='_service' value=''>
                        
                        <input type='hidden' name='dhcpd_dmdns'>
                        <input type='hidden' name='dhcpd_slt'>
                        <input type='hidden' name='dns_addget'>
                        <input type='hidden' name='dns_intcpt'>
                        <input type='hidden' name='dhcpc_minpkt'>
                        
                        <div class='section-title'>DHCP / DNS Server</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        createFieldTable('', [
                            { title: 'Use Internal Caching DNS Forwarder', name: 'f_dhcpd_dmdns', type: 'checkbox', value: nvram.dhcpd_dmdns == '1' },
                            { title: 'Use Received DNS With Static DNS', name: 'f_dns_addget', type: 'checkbox', value: nvram.dns_addget == '1' },
                            { title: 'Intercept DNS Port<br>(UDP 53)', name: 'f_dns_intcpt', type: 'checkbox', value: nvram.dns_intcpt == '1' },
                            { title: 'Maximum Active DHCP Leases', name: 'dhcpd_lmax', type: 'text', maxlen: 5, size: 8, value: nvram.dhcpd_lmax },
                            { title: 'Static Lease Time', multi: [
                                { name: 'f_dhcpd_sltsel', type: 'select', options: [[0,'Same as normal lease time'],[-1,'Infinite'],[1,'Custom']],
                                    value: (nvram.dhcpd_slt < 1) ? nvram.dhcpd_slt : 1 },
                                { name: 'f_dhcpd_slt', type: 'text', maxlen: 5, size: 8, prefix: '<span id="_dhcpd_sltman"> ', suffix: ' <i>(minutes)</i></span>',
                                    value: (nvram.dhcpd_slt >= 1) ? nvram.dhcpd_slt : 3600 } ] },
                            { title: '<a href="http://www.thekelleys.org.uk/" target="_new">Dnsmasq</a><br>Custom Configuration', name: 'dnsmasq_custom', type: 'textarea', value: nvram.dnsmasq_custom }
                        ]);
                        </script>
                        <br>
                        Note: The file /etc/dnsmasq.custom is also added to the end of Dnsmasq's configuration file if it exists.
                        </div>
                        <br>
                        
                        <div class='section-title'>DHCP Client (WAN)</div>
                        <div class='section'>
                        <script type='text/javascript'>
                        createFieldTable('', [
                            { title: 'Reduce Packet Size', name: 'f_dhcpc_minpkt', type: 'checkbox', value: nvram.dhcpc_minpkt == '1' }
                        ]);
                        </script>
                        </div>
                        
                        
                        <!-- / / / -->
                        
                            <span id='footer-msg'></span>
                            <input type='button' value='Save' id='save-button' onclick='save()'>
                            <input type='button' value='Cancel' id='cancel-button' onclick='javascript:reloadPage();'>
                        <script type='text/javascript'>verifyFields(null, true);</script>				
					</td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
          <td id="ContentRightCell" valign="Top" style="WIDTH: 164px; HEIGHT: 100%"><div id="RightColumn">
            <h3>Brainy Bunch Help</h3>
            <p id="f_dns_dmdns" style="display:none"> Check this to cache DNS information for quick DNS lookup</p>
            <p id="f_dns_addget" style="display:none"> Check this to use a permanent DNS service</p>
            <p id="f_dns_intcpt" style="display:none"> Prevents intruders from access your network by preventing fake DNS lookups</p>
            <p id="f_dns_lmax" style="display:none"> Sets  the number of maximum IP address able to be given out</p>
            <p id="f_dhcpd_slt" style="display:none"> Sets a static time for how long a device will hold a address before requesting verification of address</p>
			<p id="f_dhcpd_sltsel" style="display:none"> Sets a static time for how long a device will hold a address before requesting verification of address</p>
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
