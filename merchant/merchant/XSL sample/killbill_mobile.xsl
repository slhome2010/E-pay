<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                exclude-result-prefixes="i18n">



    <xsl:variable name="inc">/images/killbill/</xsl:variable>

    <xsl:template name="page">
        <page status="">
            <div id="main">


                <xsl:if test="//page/payment">

                    <form id="payment_form" name="frmCardInfo" method="post" action="auth.jsp" onSubmit="frmSmt();"   >
                        <input type="hidden" id="oid" name="oid" value="{//page/payment/shop/@oid}"/>
                        <input type="hidden" id="term" name="term" value="{//page/payment/shop/@merchantId}"/>

                        <div class="content_header"><i18n:text>service info</i18n:text></div>
                        <div class="content_text">
                            <!---->

                            <xsl:if test="//page/document">
                                <div><i18n:text>the name</i18n:text>:&#160;
                                    <xsl:for-each select="//page/document/item">
                                        <xsl:value-of select="@name"/>&#160;&#160;&#160;
                                    </xsl:for-each>
                                </div>
                            </xsl:if>

                            <div><i18n:text>orderam</i18n:text>: <span class="amount"><xsl:apply-templates select="//page/payment/order/@amount"/>
                             </span>  &#160;<xsl:apply-templates select="//page/payment/order/@currency"/></div>
                            <div><i18n:text>OrderID</i18n:text>: <xsl:apply-templates select="//page/payment/order/@id"/></div>
                        </div>
                        <div class="content_header"><i18n:text>cardinfo</i18n:text></div>
                        <div class="content_text">
                            <div>
                                <div class="content_desc">
                                    <i18n:text>Please, enter your card details</i18n:text>.<br/>
                                    <i18n:text>Fields marked with</i18n:text>&#160;<b>
                                    <font color="Red">*</font></b>, &#160;<i18n:text>are requred</i18n:text>.<br/><br/>
                                    <i18n:text>30min</i18n:text>
                                </div>
                                <div>
                                    <em>*</em> <i18n:text>cardname</i18n:text>:<br/>
                                    <input name="card_name" id="card_name" size="40" maxlength="32" class="text_upper">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="//page/payment/payer/@name"/>
                                        </xsl:attribute></input>
                                </div>
                                <div>
                                    <em>*</em> <i18n:text>Card Number</i18n:text>:<br/>
                                    <input name="card_no_bin" id="card_no_bin" maxlength="16" size="20"  class="txtControls" value=""  autocomplete="off"/>
                                </div>
                                <div>
                                    <em>*</em> <i18n:text>Expiration Date</i18n:text><br/>
                                    <i18n:text>month</i18n:text>:
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
                                    <i18n:text>year</i18n:text>:
                                    <select name="exp_year" id="exp_year" class="txtControls">

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

                                </div>
                                <div class="content_desc">
                                    CVV2/CVC2/CID - 3 (4-American Express) <i18n:text>last digits on the back side of your card</i18n:text>.
                                </div>
                                <div>
                                    <em>*</em> CVV2/CVC2<xsl:if test="//page/payment/shop/@AMEX[.='1']">/CID</xsl:if>:
                                    <input type="password" name="sec_cvv2" id="sec_cvv2" class="txtControls" maxlength="4" size="5" value=""/>
                                </div>
                                <div><br/><strong><i18n:text>persinfo</i18n:text></strong></div>
                                <div>
                                    <em>*</em> <i18n:text>mailadd</i18n:text>:<br/>
                                    <input name="email" class="txtControls" id="email" maxlength="64">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="//page/payment/payer/@email"/>
                                        </xsl:attribute>
                                    </input><br/>

                                    <input type="checkbox" class="txtControls" name="chSendNotify" value="yes">
                                        <xsl:if test="//page/payment/payer/@allnotify[.='yes']">
                                            <xsl:attribute name="checked">
                                            </xsl:attribute>
                                        </xsl:if>
                                    </input> <i18n:text>sendnotify</i18n:text>
                                </div>
                                <div>
                                    <i18n:text>cphone</i18n:text>:<br/>
                                    <input name="phone" class="txtControls" id="phone" maxlength="64">
                                        <xsl:attribute name="value">
                                            <xsl:value-of select="//page/payment/payer/@phone"/>
                                        </xsl:attribute>
                                    </input>
                                </div>
                            </div>
                        </div>
                        <div class="buttons">
                            <img src="/images/killbill/ajax-loader.gif" style="display:none"  id="smtLoader" />
                            <span>
                                <input type="submit" value="submdata" id="submit1" name="submit1" class="button-pay" i18n:attr="value" style="d" /></span>
                            <span><input type="button" value="back" class="button-back" onclick='location.href="{//page/payment/shop/@backLink}"'  i18n:attr="value"/></span>
                            <div class="content_desc">
                                <br/>
                                <i18n:text>waitanswer</i18n:text>
                            </div>
                        </div>
                    </form>

                </xsl:if>
                <xsl:if test="//page/result">

                    <div class="content_header"><i18n:text>result</i18n:text></div>


                    <xsl:if test="//page/result/@code[.='00']">

                        <div class="content_text">
                            <div>
                                <i18n:text>shop</i18n:text>: <xsl:value-of select="//page/result/merchant/@shopname"/><br/>
                                <i18n:text>merchant</i18n:text>: <xsl:value-of select="//page/result/merchant/@name"/><br/>
                                <i18n:text>merchid</i18n:text>: <xsl:value-of select="//page/result/merchant/@id"/>
                            </div>
                            <div><strong><i18n:text>payaccepted</i18n:text></strong></div>
                            <table border="0" width="100%">
                                <tr>
                                    <td width="50%"><i18n:text>trtime</i18n:text></td>
                                    <td width="50%"><xsl:value-of select="//page/result/@date"/></td>
                                </tr>
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
                                        <xsl:value-of select="//page/result/order/@currency_code"/>-<xsl:apply-templates select="response/order/@currency_name"/></TD>
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

                            </table>
                        </div>
                        <br/>
                        <div>
                            <span>
                                <TR>
                                    <TD colspan="2"><br/>
                                        <xsl:text> </xsl:text>
                                        <input type="button" class="button-back" value="pay for another service" onclick='location.href="{//page/result/merchant/@backLink}"'  i18n:attr="value"/>

                                    </TD>
                                </TR>
                            </span>
                        </div>


                        <div class="content_text">
                            <xsl:if test="//page/result/@baner[.='1']">
                                            <br/><br/>
                                            <i18n:text>Congratulations</i18n:text>!
                                            <br/>
                                            <i18n:text>Now you are a user of KAZKOM’s internet banking portal Homebank.kz</i18n:text>!
                                            <br/>
                                            <i18n:text>Please remember your personal information for future entering into the portal</i18n:text>:
                                            <ul>
                                                <li><i18n:text>ID</i18n:text>:<xsl:value-of select="//page/result/@iHBID"/></li>
                                                <li><i18n:text>Password</i18n:text>: <xsl:value-of select="//page/result/@sPWD"/></li>
                                            </ul>
                                            <i18n:text>This allows to check the statements for all accounts, pay for various service providers through</i18n:text>:<br/>
                                            <br/>
                                            <a href="https://www.homebank.kz" target="_blank">https://www.homebank.kz</a>
                                            <br/>
                                            <i18n:text>It is safe, convenient and advantageous</i18n:text>!
                                            <br/><br/>
                                            <i18n:text>More information about the benefits and opportunities of Homebank.kz portal you can find by following the link</i18n:text>:
                                            <a href="http://wiki.homebank.kz/page/What_is_this" target="_blank">http://wiki.homebank.kz/page/What_is_this</a>
                                            <br/><br/>
                                            <i18n:text>Best regards,</i18n:text><br/>
                                            <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                            <br/><br/>
                            </xsl:if>
                            <xsl:if test="//page/result/@baner[.='2']">
                                            <br/><br/>
                                            <i18n:text>To ensure the security of Internet payments it is recommended to use KAZKOM’s virtual banking card.</i18n:text>
                                            <br/><br/>
                                            <i18n:text>Virtual card can be ordered for the 1580 tenge/year through Homebank.kz portal by following the links</i18n:text>:<br/>
                                            <br/>
                                            <i><i18n:text>Finance - Operations - Payment Cards - Issuing a virtual card</i18n:text></i> <i18n:text>dop1</i18n:text>.<br/>
                                            <br/><br/>
                                            <i18n:text>Learn more information about the benefits and opportunities of virtual card by following the link</i18n:text>:
                                            <a href="http://ru.kkb.kz/cards/page/Virtual_card" target="_blank">http://ru.kkb.kz/cards/page/Virtual_card</a>.
                                            <br/><br/>
                                            <i18n:text>Best regards,</i18n:text><br/>
                                            <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                            <br/><br/>
                            </xsl:if>
                            <xsl:if test="//page/result/@baner[.='3']">
                                            <br/><br/>
                                            <i18n:text>To ensure the security of Internet payments it is recommended to use KAZKOM’s virtual banking card. This card can be replenished through Homebank for the definite amount of money that is needed for execution of a specific payment</i18n:text>.
                                            <br/><br/>
                                            <i18n:text>Learn more information about the benefits and opportunities of virtual card by following the link</i18n:text>:
                                            <a href="http://ru.kkb.kz/cards/page/Virtual_card" target="_blank">http://ru.kkb.kz/cards/page/Virtual_card</a>.
                                            <br/><br/>
                                            <i18n:text>Best regards,</i18n:text><br/>
                                            <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                            <br/><br/>
                            </xsl:if>
                            <xsl:if test="//page/result/@baner[.='4']">
                                            <br/><br/>
                                            <i18n:text>Additionally, we remind you that you registered at internet banking portal of KAZKOM, but apparently, you have forgotten about it.</i18n:text>
                                            <br/><br/>
                                            <i18n:text>We would be glad to remind you the ID and password to the portal, at your telephone call to Call Center at tel. 58-53-34 (258-53-34 inside Almaty).</i18n:text>
                                            <br/><br/>
                                            <i18n:text>Today more than 270,000 cardholders use Homebank.kz for paying to all service providers! Join us</i18n:text>!
                                            <br/><br/>
                                            <i18n:text>More information about the benefits and opportunities of Homebank.kz can be obtained by following the link</i18n:text>:
                                            <a href="http://wiki.homebank.kz/page/What_is_this" target="_blank">http://wiki.homebank.kz/page/What_is_this</a>.
                                            <br/><br/>
                                            <i18n:text>Best regards,</i18n:text><br/>
                                            <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                            <br/><br/>
                            </xsl:if>

                            <xsl:if test="//page/result/@baner[.='5']">
                                            <br/><br/>
                                            <i18n:text>We suggest you to sign up for KAZKOM’s Internet banking portal</i18n:text>&#160;&#160;<a href="https://www.homebank.kz" target="_blank">https://www.homebank.kz</a>&#160;&#160;<i18n:text>for saving your time and money.</i18n:text>
                                            <br/><br/>
                                            <i18n:text>register free</i18n:text>
                                            <br/><br/>
                                            <i18n:text>Today more than 270,000 cardholders use Homebank.kz for paying to all service providers! Join us</i18n:text>
                                            <br/><br/>
                                            <i18n:text>More information about the benefits and opportunities of Homebank.kz can be obtained by following the link</i18n:text>:
                                            <a href="http://wiki.homebank.kz/page/What_is_this" target="_blank">http://wiki.homebank.kz/page/What_is_this</a>
                                            <br/><br/>
                                            <i18n:text>Best regards,</i18n:text><br/>
                                            <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                            <br/><br/>
                            </xsl:if>
                        </div>

                    </xsl:if>

                    <xsl:if test="//page/result/@code[.!='00']">

                        <div class="content_header"><i18n:text>Authorization Error</i18n:text></div>
                        <div class="content_text">
                            <table border="0" width="100%">
                                <tr>
                                    <td width="50%"><i18n:text>OrderIDpl</i18n:text>:</td>
                                    <td width="50%"><xsl:apply-templates select="//page/result/order/@id"/></td>
                                </tr>
                                <TR>
                                    <TD><i18n:text>Error Code</i18n:text>: </TD>
                                    <TD>
                                        <xsl:apply-templates select="//page/result/@code"/>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD><i18n:text>Message</i18n:text>: </TD>
                                    <TD><font color="red">
                                        <xsl:apply-templates select="//page/result/@message"/></font>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD><i18n:text>Reference</i18n:text>: </TD>
                                    <TD>
                                        <xsl:apply-templates select="//page/result/@reference"/>
                                    </TD>
                                </TR>
                            </table>
                        </div>
                        <br/>
                        <div>
                            <span>
                                <xsl:if test="//page/result/merchant/@retryLink[.!='']">
                                    <xsl:text> </xsl:text>
                                    <input type="button" class="button-back" value="tryagain" onclick='location.href="{//page/result/merchant/@retryLink}"'  i18n:attr="value"/>
                                </xsl:if>
                                <xsl:if test="//page/result/merchant/@backLink[.!='']">
                                    <xsl:text> </xsl:text>
                                    <input type="button" class="button-back" value="back" onclick='location.href="{//page/result/merchant/@backLink}"'  i18n:attr="value"/>
                                </xsl:if>
                            </span>
                        </div>

                    </xsl:if>



                </xsl:if>
                <xsl:if test="//page/error">

                    <div class="content_header"><i18n:text>Error</i18n:text>!</div>
                    <div class="content_text">

                        <div><xsl:apply-templates select="//page/error/@message"/></div>
                        <table border="0" width="100%">
                            <tr>
                                <td width="50%"><i18n:text>trtime</i18n:text>:</td>
                                <td width="50%"><xsl:apply-templates select="//page/error/@time"/></td>
                            </tr>
                            <tr>
                                <td width="50%"><i18n:text>sessionid</i18n:text>:</td>
                                <td width="50%"><xsl:apply-templates select="//page/error/@sessionid"/></td>
                            </tr>
                            <tr>
                                <td width="50%"><i18n:text>ipadr</i18n:text>:</td>
                                <td width="50%"><xsl:apply-templates select="//page/error/@ip"/></td>
                            </tr>
                        </table>
                    </div>
                    <br/>
                    <div>
                        <span>
                            <xsl:if test="//page/error/pageinfo/@retryLink[.!='']">
                                <xsl:text> </xsl:text>
                                <input type="button" class="button-back" value="tryagain" onclick='location.href="{//page/error/pageinfo/@retryLink}"'  i18n:attr="value"/>
                            </xsl:if>
                            <xsl:if test="//page/error/pageinfo/@backLink[.!='']">
                                <xsl:text> </xsl:text>
                                <input type="button" class="button-back" value="back" onclick='location.href="{//page/error/pageinfo/@backLink}"'  i18n:attr="value"/>
                            </xsl:if>
                        </span>
                    </div>


                    <div>
                        <i18n:text>For additional information mail to</i18n:text>: <A>
                        <xsl:attribute name="href">
                            <xsl:value-of select="//page/error/pageinfo/@adminmail"/>
                        </xsl:attribute>
                        <xsl:value-of select="//page/error/pageinfo/@adminmail"/></A>
                    </div>
                </xsl:if>

            </div>
        </page>
    </xsl:template>



    <xsl:template match="/">
        <html>
            <head>
                <title><i18n:text>Kazkommertsbank's Authorization Server</i18n:text></title>
                <meta http-equiv="Content-Type" content="text/xml; charset=UTF-8" />
                <link rel="stylesheet" type="text/css" href="{$inc}styles_mobile.css" />
                <script type="text/javascript" src="{$inc}jquery-1.7.2.js"><xsl:comment> Comment </xsl:comment></script>
                <xsl:comment><![CDATA[[if IE]><![if lt IE 7]><![endif]]]></xsl:comment>
                <script type="text/javascript">var images_path_ = '/images/killbill/';</script>
                <script type="text/javascript" src="{$inc}jquery.unitpngfix.js"><xsl:comment> Comment </xsl:comment></script>
                <xsl:comment><![CDATA[[if IE]><![endif]><![endif]]]></xsl:comment>
                <script type="text/javascript" src="{$inc}script.js"><xsl:comment> Comment </xsl:comment></script>
            </head>
            <body>
                <div class="wrapper">
                    <div id="min_width">&#160;</div>
                    <div class="container">
                        <div class="header">
                            <div class="logo_killbill">
                                <img src="{$inc}logo.png" width="190" height="79" />
                            </div>
                            <div class="logo_epay">
                                <img src="{$inc}logo-epay.png" width="142" height="59" />
                            </div>
                            <div class="clear">&#160;</div>
                        </div>
                        <div class="content">

                            <xsl:call-template name="page"/>
                        </div>

                    </div>
                    <div class="clear">&#160;</div>
                </div>
            </body>
        </html>


    </xsl:template>

</xsl:stylesheet>
