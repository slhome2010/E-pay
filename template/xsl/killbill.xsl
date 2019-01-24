<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                exclude-result-prefixes="i18n">
    <xsl:output method="xml" encoding="UTF-8" doctype-system="about:legacy-compat" />



    <xsl:variable name="inc">/images/killbill/2013/</xsl:variable>

    <xsl:template name="page">
        <page status="">


            <xsl:if test="//page/payment">

                <form id="frmCardInfo" name="frmCardInfo" method="post" action="auth.jsp" onsubmit="return frmCardInfo_onsubmit()">
                    <div class="content-header">
                        <xsl:if test="//page/document">
                            <div>
                                <xsl:for-each select="//page/document/item">
                                    <xsl:value-of select="@name"/>&#160;&#160;&#160;
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                    </div>




                    <div class="content-title">
                        <i18n:text>orderam</i18n:text>: <strong><xsl:apply-templates select="//page/payment/order/@amount"/></strong>
                        &#160;<xsl:apply-templates select="//page/payment/order/@currency"/> (<i18n:text>OrderID</i18n:text>: <xsl:apply-templates select="//page/payment/order/@id"/>)
                    </div>
                    <input type="hidden" id="Language" name="Language" value="{//page/payment/shop/@lang}"/>
                    <input type="hidden" id="oid" name="oid" value="{//page/payment/shop/@oid}"/>
                    <input type="hidden" id="term" name="term" value="{//page/payment/shop/@merchantId}"/>




                    <div class="content-left">

                        <div class="row">
                            <div class="span3">
                                <label><i18n:text>cardname</i18n:text></label>
                                <input name="card_name" id="card_name" size="40" maxlength="32" class="span3 text-upper content-input">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="//page/payment/payer/@name"/>
                                    </xsl:attribute></input>
                            </div>
                        </div>
                        <p></p>
                        <div class="row">
                            <div class="span2">
                                <label><i18n:text>Card Number</i18n:text></label>
                                <input name="card_no_bin" id="card_no_bin" maxlength="16" size="20"  class="span2 text-upper content-input" value=""   autocomplete="off"/>
                            </div>
                            <div class="span1">
                                <label>CVC2/CVV2<xsl:if test="//page/payment/shop/@AMEX[.='1']">/CID</xsl:if></label>
                                <input type="password" name="sec_cvv2" id="sec_cvv2" class="span1 content-input" maxlength="4" size="5" value=""/>
                            </div>
                        </div>
                        <p></p>
                        <div class="row">
                            <div class="span3">
                                <label><i18n:text>Expiration Date</i18n:text></label>
                            </div>
                        </div>

                        <div class="row">
                            <div class="span1">
                                <label><i18n:text>month</i18n:text>:</label>
                                <select name="exp_month" id="exp_month" class="span1 content-input">
                                    <option selected="selected">01</option>
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
                            </div>
                            <div class="span2">
                                <label><i18n:text>year</i18n:text>:</label>
                                <select name="exp_year" id="exp_year" class="span2 content-input">
                                    <option selected="selected">2013</option>
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
                        </div>
                    </div>


                    <div class="content-right">
                        <div class="row">
                            <div class="span3">
                                <label><i18n:text>mailadd</i18n:text></label>
                                <input name="email" class="span3 text-upper content-input" id="email" maxlength="64">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="//page/payment/payer/@email"/>
                                    </xsl:attribute>
                                </input>
                            </div>
                        </div>

                            <label class="checkbox not-bold">
                                <input type="checkbox" class="txtControls" name="chSendNotify" value="yes">
                                    <xsl:if test="//page/payment/payer/@allnotify[.='yes']">
                                        <xsl:attribute name="checked">
                                        </xsl:attribute>
                                    </xsl:if>
                                </input>
                                <small><i18n:text>sendnotify</i18n:text></small>
                            </label>

                        <div class="row">
                            <div class="span3">
                                <label><i18n:text>cphone</i18n:text></label>
                                <input name="phone" class="span3 text-upper content-input" id="phone" size="35" maxlength="64">
                                    <xsl:attribute name="value">
                                        <xsl:value-of select="//page/payment/payer/@phone"/>
                                    </xsl:attribute>
                                </input>
                            </div>
                        </div>
                    </div>





                    <div class="clearfix">&#160;</div>


                    <div class="content-actions text-center">
                        <span>
                            <input type="button" value="back" class="button-back" onclick='location.href="{//page/payment/shop/@backLink}"' i18n:attr="value"/>
                        </span>
                        &#160;
                        <span>
                            <input type="submit" value="submdata" id="submit1" name="submit1" class="button-pay" i18n:attr="value"  />
                        </span>
                        <div class="content-warn">
                            <i18n:text>waitanswer</i18n:text>
                        </div>
                    </div>

                    <div align="center">
                        <img src="{$inc}example-gray.jpg" border="0" height="185" width="502"/>
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
                            <xsl:if test="//page/result/merchant/@backLink[.!='']">

                                <input type="button" class="button-back" value="pay for another service" onclick='location.href="{//page/result/merchant/@backLink}"'  i18n:attr="value"/>

                                &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                                <xsl:if test="//page/result/merchant/@id[.='98867204']">
                                    <input type="button" style="BORDER:  0px; FONT-SIZE: 12pt; COLOR:white; background-color: red; font-weight: bold; width:200px;" value="АВТООПЛАТА" onclick='location.href="http://autopay.kcell.kz"' />
                                </xsl:if>

                                <xsl:if test="//page/result/merchant/@id[.='98867205']">
                                    <input type="button" style="BORDER:  0px; FONT-SIZE: 12pt; COLOR:white; background-color: red; font-weight: bold; width:200px;" value="АВТООПЛАТА" onclick='location.href="http://autopay.activ.kz"' />
                                </xsl:if>

                            </xsl:if>
                        </span>
                    </div>

                    <div class="content_text">
                        <xsl:if test="//page/result/merchant/@id[.='98867204']">
                            <p style="COLOR: red;">
                                Устали каждый раз вносить реквизиты карты для оплаты?!
                                <br/>
                                АО «Кселл» представляет новую услугу - «Автооплата»!
                                <br/>
                                Удобно и быстро пополняйте баланс <span style="text-decoration:underline; font-weight: bold;">без комиссий</span> со стороны АО «Кселл» с платежной карты любого банка! Подключите Ваших родных и близких на Ваш счет! Оплачивайте за несколько номеров одновременно!
                                <br/>
                                Настроив однажды правило пополнения в своем <a href="http://my.kcell.kz">Личном Кабинете</a>, Вам не нужно будет больше терять время на заполнение реквизитов! Баланс будет пополняться автоматически, или же по запросу с помощью USSD-команды с Вашего телефона!
                                <br/>
                                Ознакомьтесь подробнее с данной услугой, нажав кнопку «Автооплата» или на <a href="http://autopay.kcell.kz">autopay.kcell.kz</a>, а так же по телефону call-центра 4098
                            </p>
                        </xsl:if>

                        <xsl:if test="//page/result/merchant/@id[.='98867205']">
                            <p style="COLOR: red;">
                                Устали каждый раз вносить реквизиты карты для оплаты?!
                                <br/>
                                АО «Кселл» представляет новую услугу - «Автооплата»!
                                <br/>
                                Удобно и быстро пополняйте баланс <span style="text-decoration:underline; font-weight: bold;">без комиссий</span> со стороны АО «Кселл» с платежной карты любого банка! Подключите Ваших родных и близких на Ваш счет! Оплачивайте за несколько номеров одновременно!
                                <br/>
                                Настроив однажды правило пополнения в своем <a href="http://my.activ.kz">Личном Кабинете</a>, Вам не нужно будет больше терять время на заполнение реквизитов! Баланс будет пополняться автоматически, или же по запросу с помощью USSD-команды с Вашего телефона!
                                <br/>
                                Ознакомьтесь подробнее с данной услугой, нажав кнопку «Автооплата» или на <a href="http://autopay.activ.kz">autopay.activ.kz</a>, а так же по телефону call-центра 4098
                            </p>
                        </xsl:if>
                    </div>
                    <br/>
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
                            <td colspan="2" height="20" align="left" valign="middle">&#160;
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

        </page>
    </xsl:template>



    <xsl:template match="/">

        <html lang="en">

                        <head>                  <script>if (top!=self) top.location.href=self.location.href</script>
                <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
                <meta charset="utf-8"/>
                <title>Kazkommertsbank's Authorization Server</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <meta name="description" content="Kazkommertsbank's Authorization Server"/>
                <meta name="author" content="Kazkommertsbank"/>

                <!-- styles -->
                <link href="{$inc}beeline.css" rel="stylesheet"/>
                <link href="{$inc}bootstrap.css" rel="stylesheet"/>
                <link href="{$inc}bootstrap-responsive.css" rel="stylesheet"/>
            </head>

            <body>
                <div class="container-narrow">
                    <div class="header">
                        <img src="{$inc}logo-killbill.png" />
                        <img src="{$inc}logo-epay.png" class="pull-right" />
                    </div>

                    <div class="content">

                        <xsl:call-template name="page"/>

                    </div>
                </div>
            </body>
            <script src="/includes/service/clientCheck_amex2_t.js" ><xsl:comment> Comment </xsl:comment></script>
        </html>


    </xsl:template>

</xsl:stylesheet>
