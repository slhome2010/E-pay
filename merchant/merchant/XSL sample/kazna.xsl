<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    exclude-result-prefixes="i18n">
<xsl:template name="page">
<page status="">
<div id="main">


<xsl:if test="//page/payment">

         <table border="0" cellspacing="1" cellpadding="3">
            <form id="frmCardInfo" name="frmCardInfo" method="post" action="{//page/payment/shop/@site}/jsp/process/auth.jsp" onsubmit="return frmCardInfo_onsubmit()">
                <tr>
                    <td colspan="2" height="20">
                        <input type="hidden" id="Language" name="Language" value="{//page/payment/shop/@lang}"/>
                        <input type="hidden" id="oid" name="oid" value="{//page/payment/shop/@oid}"/>
                        <input type="hidden" id="term" name="term" value="{//page/payment/shop/@merchantId}"/>
                    </td>
                </tr>
                <tr>
                    <td align="center" valign="middle" colspan="2">
                        <img border="0">
							<xsl:attribute name="src">/images/logo/<xsl:value-of select="//page/payment/shop/@img"/></xsl:attribute>
						</img>
                        <p/>
                    </td>
                </tr> <tr>
                    <td valign="top" colspan="2">
                        <font size="3"><i18n:text>orderam</i18n:text>:<b>
                                <xsl:text>
                                </xsl:text>
                                <font color="red">
                                    <xsl:apply-templates select="//page/payment/order/@amount"/>
                                </font></b>
                            <xsl:text>
                            </xsl:text>
                            <xsl:apply-templates select="//page/payment/order/@currency"/>
                        </font>

                        <br/>
                        <br/><i18n:text>addpay</i18n:text>: <b>
                            <xsl:apply-templates select="//page/payment/shop/@merchantName"/></b>
                        <br/><i18n:text>Kabinet</i18n:text>: <b>
                            <xsl:apply-templates select="//page/payment/shop/@name"/></b>
                        <br/><i18n:text>OrderID</i18n:text>:<xsl:text> </xsl:text>
                        <xsl:apply-templates select="//page/payment/order/@id"/>
                        <br/>
                        <br/>
                    </td>
                </tr>
                <xsl:if test="//page/document">
                    <tr>
                        <td colspan="2" height="20" align="center">
                            <TABLE border="1" cellspacing="1" cellpadding="3" with="100%">
                                <tr align="center">
                                    <td><i18n:text>id</i18n:text></td><td><i18n:text>the name</i18n:text></td><td><i18n:text>amount</i18n:text></td>
                                </tr>
                                <xsl:for-each select="//page/document/utilitiesItem">
                                    <tr>
                                        <td><xsl:value-of select="@serviceId"/></td>
                                        <td><xsl:value-of select="@serviceName"/></td>
                                        <td><xsl:value-of select="@paySum"/></td>
                                    </tr>
                                </xsl:for-each>
                            </TABLE>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <td height="1" colspan="2" bgcolor="Black">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <b><i18n:text>Attention</i18n:text></b>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><i18n:text>weaccept</i18n:text>.<br/>
                        <i18n:text>since</i18n:text>
                        <!--<br/><br/><a href="#" onclick="window.open('/includes/hsbk_info.htm', 'cvv_win', 'height=210, width=245, scrollbar=0, resizable=0')">РРЅС„РѕСЂРјР°С†РёСЏ РґР»СЏ РІР»Р°РґРµР»СЊС†РµРІ РїР»Р°С‚РµР¶РЅС‹С… РєР°СЂС‚ РќР°СЂРѕРґРЅРѕРіРѕ Р‘Р°РЅРєР°.</a>-->
                    </td>
                </tr>
                <tr>
                    <td height="1" colspan="2" bgcolor="Black">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <br/>
                        <b><i18n:text>cardinfo</i18n:text></b>
                    </td>
                </tr>
                <tr>
                    <td valign="top" width="45%"><i18n:text>Please, enter your card details</i18n:text>.<br/>
                        <i18n:text>Fields marked with</i18n:text><b>
                            <font color="Red">*</font></b><i18n:text>are requred</i18n:text>.<br/><br/>
                    <i18n:text>30min</i18n:text><br/><br/></td>
                    <td>
                        <b>
                            <font color="Red">*</font>
                        </b><i18n:text>cardname</i18n:text><br/><input name="card_name" id="card_name" maxlength="32" class="txtControls">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//page/payment/payer/@name"/>
                            </xsl:attribute></input>
                        <br/>
                        <br/>
                        <b>
                            <font color="Red">*</font>
                        </b><i18n:text>Card Number</i18n:text>
                        <table border="0" cellspacing="2" cellpadding="0">
                            <tr>
                                <td class="sample" align="center">XXXXXXXXXXXXXXXX</td>
                            </tr>
                            <tr>
                                <td>
                                    <input autocomplete="off" name="card_no_bin" id="card_no_bin" maxlength="16" size="20"  class="txtControls" value=""/>
                                </td>
                            </tr></table>
                        <br/>
                        <b>
                            <font color="Red">*</font>
                        </b><i18n:text>Expiration Date</i18n:text><br/><table width="80%" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                                <td class="sample"><i18n:text>month</i18n:text></td>
                                <td class="sample"><i18n:text>year</i18n:text></td>
                            </tr>
                            <tr>
                                <td>
                                    <select name="exp_month" id="exp_month" class="txtControls">
                                        <option>01</option>
                                        <option>02</option>
                                        <option>03</option>
                                        <option>04</option>
                                        <option>05</option>
                                        <option>06</option>
                                        <option>07</option>
                                        <option>08</option>
                                        <option>09</option>
                                        <option>10</option>
                                        <option>11</option>
                                        <option>12</option>
                                    </select>
                                </td>
                                <td>
                                    <select name="exp_year" id="exp_year" class="txtControls">

                                        <option>2013</option>
                                        <option>2014</option>
                                        <option>2015</option>
                                        <option>2016</option>
                                        <option>2017</option>
                                        <option>2018</option>
                                        <option>2019</option>
                                        <option>2020</option>
                                        <option>2021</option>
                                        <option>2022</option>
                                        <option>2023</option>
                                        <option>2024</option>
                                    </select>
                                </td>
                            </tr></table>
                    </td>
                </tr>
                <tr>
                    <td height="1" colspan="2" bgcolor="Black">
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top">CVV2/CVC2/CID - 3 (4-American Express) <i18n:text>last digits on the back side of your card</i18n:text>.<br/><a href="#" title="See illustration" onclick='window.open("/includes/cvv.htm", "cvv_win", "height=180, width=245, scrollbar=0, resizable=0")'><i18n:text>seeill</i18n:text></a>
                    </td>
                    <td valign="top">
                        <b>
                            <font color="Red">*</font>
                        </b>CVV2/CVC2/CID <input type="password" name="sec_cvv2" id="sec_cvv2" class="txtControls" maxlength="4" size="4" value="" onchange="checkCVV()"/><br/>
            <i18n:text>notused</i18n:text></td>
                </tr>
                <tr>
                    <td height="1" colspan="2" bgcolor="Black">
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <b><i18n:text>persinfo</i18n:text></b>
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="right">
                        <i18n:text>mailadd</i18n:text></td>
                    <td valign="top">
                        <input name="email" class="txtControls" id="email" maxlength="64">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//page/payment/payer/@email"/>
                            </xsl:attribute>
                        </input>
                        <xsl:text>
                        </xsl:text>
                        <input type="checkbox" class="txtControlsbtn" name="chSendNotify" value="yes">
                            <xsl:if test="//page/payment/payer/@allnotify[.='yes']">
                                <xsl:attribute name="checked">
                                </xsl:attribute>
                            </xsl:if>
                        </input><i18n:text>sendnotify</i18n:text></td>
                </tr>
                <tr>
                    <td valign="top" align="right"><i18n:text>cphone</i18n:text></td>
                    <td valign="top">
                        <input name="phone" class="txtControls" id="phone" maxlength="64">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//page/payment/payer/@phone"/>
                            </xsl:attribute>
                        </input>
                        <br/>
                    </td>
                </tr>
                                    <tr>
                    <td align="center" colspan="2">
                        <br/>
                        <table border="0" cellspacing="1" cellpadding="3" width="100%">
                            <tr>
                            <td align="left">
                            <input type="reset" value="clform" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; " id="reset1" name="reset1" i18n:attr="value"/>
                            </td>
                            <td align="center">
                            <input type="button" value="submdata" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; FONT-WEIGHT: bold" id="submit1" name="submit1" i18n:attr="value" onclick="submit1.disabled=true; frmCardInfo_onsubmit();" />
                            </td>
                            <td align="right">
                            <input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; " value="back" onclick='location.href="{//page/payment/shop/@backLink}"' i18n:attr="value"/>
                            </td></tr>
                        </table>
                    </td>
                </tr>
                <tr><td align="center" colspan="2"><b><i18n:text>waitanswer</i18n:text></b></td></tr>
                <tr>
                    <td height="10" colspan="2">
                    </td>
                </tr>
            </form>
        </table>

</xsl:if>
<xsl:if test="//page/result">




    <br/>
    <TABLE border="0" width="100%">
        <TR>
            <TD colSpan="2">
                <b><i18n:text>Authorization result</i18n:text></b>
            </TD>
        </TR>
        <TR>
            <TD colSpan="2">
                <BR/>
                <xsl:if test="//page/result/@code[.='00']">
                    <TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
                        <TR>
                            <TD colspan="2"><i18n:text>payaccepted</i18n:text><br/><br/></TD>
                        </TR>
                        <TR>
                            <TD colspan="2"><i18n:text>Kabinet</i18n:text>: <xsl:value-of select="//page/result/merchant/@shopname"/></TD>
                        </TR>
                        <TR>
                            <TD colspan="2"><i18n:text>addpay</i18n:text>: <xsl:value-of select="//page/result/merchant/@name"/></TD>
                        </TR>
                        <TR>
                            <TD colspan="2"><i18n:text>merchid</i18n:text>: <xsl:value-of select="//page/result/merchant/@id"/><br/><br/></TD>
                        </TR>
                        <TR>
                            <TD colspan="2" align="center">
                                <b><i18n:text>cheque</i18n:text></b>
                                <br/>
                                <br/>
                            </TD>
                        </TR>

                        <TR>
                            <TD><i18n:text>trtime</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/@date"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <b><i18n:text>persinfo</i18n:text></b>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Customer</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/payer/@name"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>mailadd</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/payer/@mail"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <b><i18n:text>cardinfo</i18n:text></b>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Card Number</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/card/@number"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <b><i18n:text>persinfo</i18n:text></b>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Reference</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/@reference"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Approval Code</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/@approval_code"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Response Code</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/@code"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Message</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/@message"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2">
                                <b><i18n:text>Order Info</i18n:text></b>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>OrderID</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/order/@id"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>curtype</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/order/@currency_code"/>-<xsl:apply-templates select="//page/result/order/@currency_name"/></TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Order Amount</i18n:text></TD>
                            <TD>
                                <xsl:value-of select="//page/result/order/@amount"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="2"><br/>
                            <i18n:text>savecheque</i18n:text>.
                            </TD>
                        </TR>
                        <xsl:if test="//page/result/merchant/@backLink[.!='']">
                        <TR>
                            <TD colspan="2"><br/>
                                <a><xsl:attribute name="href">
                                <xsl:value-of select="//page/result/merchant/@backLink"/>
                                </xsl:attribute><i18n:text>backtoshop</i18n:text></a>
                            </TD>
                        </TR>
                        </xsl:if>
                    </TABLE>
                    </xsl:if>

                <xsl:if test="//page/result/@code[.!='00']">
                    <TABLE border="0" cellPadding="3" cellSpacing="1">
                        <TR>
                            <TD colspan="2">
                                <b>
                                    <font color="red"><i18n:text>Authorization Error</i18n:text></font>
                                </b>
                                <br/>
                                <br/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Error Code</i18n:text>: </TD>
                            <TD>
                                <xsl:apply-templates select="//page/result/@code"/>
                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Message</i18n:text>: </TD>
                            <TD>
                                <xsl:apply-templates select="//page/result/@message"/>
                                <xsl:if test="//page/result/@sHtm[.!='']">
                                    &#160;&#160;
                                    <a href="#" onclick='window.open("{//page/result/@sHtm}", "Error", "height=400, width=600, scrollbar=0, resizable=1")'><i18n:text>More</i18n:text></a><br/>

                                </xsl:if>

                            </TD>
                        </TR>
                        <TR>
                            <TD><i18n:text>Reference</i18n:text>: </TD>
                            <TD>
                                <xsl:apply-templates select="//page/result/@reference"/>
                            </TD>
                        </TR>
                    </TABLE>
                    <br/>
                    <br/>
                    <br/>
            <xsl:if test="//page/result/merchant/@retryLink[.!='']">
            <xsl:text> </xsl:text>
                <input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt;" value="tryagain" onclick='location.href="{//page/result/merchant/@retryLink}"'  i18n:attr="value"/>
            </xsl:if>
            <xsl:if test="//page/result/merchant/@backLink[.!='']">
            <xsl:text> </xsl:text>
                <input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt;" value="back" onclick='location.href="{//page/result/merchant/@backLink}"' i18n:attr="value"/>
           </xsl:if>

                </xsl:if>
                <BR/>
                <BR/>
                <BR/>
                <center>
                <i18n:text>For additional information mail to</i18n:text>: <A>
                    <xsl:attribute name="href">
                        <xsl:value-of select="//page/result/@adminmail"/>
                    </xsl:attribute>
                    <xsl:value-of select="//page/result/@adminmail"/></A>
                </center>
            </TD>
        </TR>
    </TABLE>



</xsl:if>
<xsl:if test="//page/error">


        <TABLE border="0" width="100%">
            <TR>
                <TD valign="top">
                    <br/>
                    <b>
                        <font color="red"><i18n:text>Error</i18n:text>!</font>
                    </b>
                    <br/>
                    <br/>
                    <br/>
                    <xsl:apply-templates select="//page/error/message"/>
                    <br/>
                    <br/>
                    <i18n:text>trtime</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@time"/>
                    <br/><i18n:text>sessionid</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@sessionid"/>
                    <br/><i18n:text>ipadr</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@ip"/>
                    
                    <br/>
                    <br/>
                    <br/>
                    <br/>
                    <xsl:if test="//page/error/pageinfo/@resultLink[.!='']">
                        <BR/>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="//page/error/pageinfo/@resultLink"/>
                            </xsl:attribute><i18n:text>Go to result page</i18n:text></a>
                        <BR/>
                        <BR/>
                    </xsl:if>
                    <xsl:if test="//page/error/pageinfo/@retryLink[.!='']">
                        <BR/>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="//page/error/pageinfo/@retryLink"/>
                            </xsl:attribute><i18n:text>Try again</i18n:text></a>
                        <BR/>
                        <BR/>
                    </xsl:if>
                    <xsl:if test="//page/error/pageinfo/@backLink[.!='']">
                        <BR/>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="//page/error/pageinfo/@backLink"/>
                            </xsl:attribute><i18n:text>Back to the shop</i18n:text></a>
                        <BR/>
                        <BR/>
                    </xsl:if>
                    <BR/>
                    <i18n:text>For additional information mail to</i18n:text>: <A>
                        <xsl:attribute name="href">
                            <xsl:value-of select="//page/error/pageinfo/@adminmail"/>
                        </xsl:attribute>
                        <xsl:value-of select="//page/error/pageinfo/@adminmail"/></A>

                </TD>
            </TR>
        </TABLE>

</xsl:if>
<xsl:if test="//page/complect">


		<table border="0" cellspacing="1" cellpadding="3">
			<form name="frmCardInfo" method="post" action="{//page/complect/shop/@site}/jsp/process/mod.jsp">
                <tr>
                    <td colspan="2" height="20">
                        <input type="hidden" id="oid" name="oid" value="{//page/complect/shop/@oid}"/>
                        <input type="hidden" id="term" name="term" value="{//page/complect/shop/@merchantId}"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" height="20" align="left" valign="middle">
                        <img border="0">
                            <xsl:attribute name="src">/images/logo/<xsl:value-of select="//page/complect/shop/@img"/></xsl:attribute>
                        </img>
                    </td>
                </tr>
				<tr>
					<td with="50"><br/><br/><br/>
					</td>
					<td valign="top"><br/><br/><br/>
						<font size="3"><i18n:text>Order Amount</i18n:text>:<b>
								<xsl:text>
								</xsl:text>
								<font color="red">
									<xsl:apply-templates select="//page/complect/order/@amount"/>
								</font></b>
							<xsl:text>
							</xsl:text>
							<xsl:apply-templates select="//page/complect/order/@currency"/>
						</font><br/>
                        <font size="3"><i18n:text>feeamount</i18n:text>:<b>
                                <xsl:text>
                                </xsl:text>
                                <font color="red">
                                    <xsl:apply-templates select="//page/complect/order/@sKom"/>
                                </font></b>
                            <xsl:text>
                            </xsl:text>
                            <xsl:apply-templates select="//page/complect/order/@currency"/>
                        </font><br/>

                        <br/>
						<br/><i18n:text>addpay</i18n:text>:<b>
								<xsl:text>
								</xsl:text>
							<xsl:apply-templates select="//page/complect/shop/@merchantName"/></b>
						<br/><i18n:text>OrderID</i18n:text>:
								<xsl:text>
								</xsl:text>
						<xsl:apply-templates select="//page/complect/order/@id"/>
						<br/>
						<br/>
					</td>
				</tr>
				<tr>
					<td align="center">
						<br/>
					</td>
					<td valign="bottom">
                    <table border="0" cellspacing="1" cellpadding="3" width="100%">
                        <TR>
                            <TD align="left"><input type="button" value="Accept pay" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; FONT-WEIGHT: bold" id="submit1" name="submit1" onclick="submit1.disabled=true;submit();" i18n:attr="value"/></TD>
                            <TD align="center"><input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; " value="back" onclick='location.href="{//page/complect/shop/@backlink}"'  i18n:attr="value"/></TD>
                        </TR>
                    </table>
                    </td>
				</tr>
            </form>
       </table>
       <br/><br/><br/><br/><br/><br/><br/><br/><br/>
    </xsl:if>

</div>
</page>
	</xsl:template>
    <xsl:template match="/">
        <html>
            <head>
                <title><i18n:text>Kazkommertsbank's Authorization Server</i18n:text></title>
                <link rel="stylesheet" href="/includes/style_kazna.css" type="text/css"/>
            </head>
            <body>
                <table width="750" border="0" cellspacing="0" cellpadding="0" align="center">
                    <tr>
                        <td width="80" height="30">
                            <img src="/images/pix.gif" width="1" height="1"/>
                        </td>
                        <td rowspan="5" align="right" background="/images/1/topLeft.gif" width="2">
                        </td>
                        <td width="580" align="center">
                            <font size="2"><i18n:text>guarsec</i18n:text>&#160;&#160;<img src="/images/kkbeng_logo_small.gif" width="135" height="15"/></font>
                        </td>
                        <td rowspan="5" align="right" background="/images/1/topLeft.gif" width="2">
                        </td>
                        <td width="100">
                            <img src="/images/pix.gif" width="1" height="1"/>
                        </td>
                    </tr>
                    <tr>
                        <td background="/images/1/topLeft.gif" height="2">
                        </td>
                        <td colspan="2" background="/images/1/topLeft.gif" height="2">
                        </td>
                        <td background="/images/1/topLeft.gif" height="2">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" align="right">
                            <br/>
                            <img src="/images/design/Main_H_01.gif" width="59" height="134"/>
                            <img src="/images/pix.gif" width="15" height="1"/>
                            <br/>
                        </td>
                        <td>
                            <table cellpadding="5" width="100%" height="100%">
                                <tr>
                                    <td valign="top" bgcolor="#E1E4EA">
  <xsl:call-template name="page"/>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td valign="top" align="center">
                            <br/>
                            <img src="/images/pix.gif" width="1" height="1"/>
                            <img src="/images/cards/visa_small.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/visa_electron_small.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/ec_mc_small.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/maestro_small.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/cirrus_small.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/sm_amex.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/MC_62x34.gif"/>
                            <br/>
                            <br/>
                            <img src="/images/cards/vis62x34.gif"/>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td background="/images/1/topLeft.gif" height="2">
                        </td>
                        <td colspan="2" background="/images/1/topLeft.gif" height="2">
                        </td>
                        <td background="/images/1/topLeft.gif" height="2">
                        </td>
                    </tr>
                    <tr>
                        <td height="30">
                            <img src="/images/pix.gif" width="1" height="1"/>
                        </td>
                        <td align="center"> 2001-2014 <i18n:text>Kazkommertsbank JSC</i18n:text></td>
                        <td>
                            <img src="/images/pix.gif" width="1" height="1"/>
                        </td>
                    </tr>
                </table>
                <script src="/includes/service/kazna.js" type="text/javascript"/>
                <center>
                    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript" SRC="//smarticon.geotrust.com/si.js"></SCRIPT>
                </center>
                <br/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
