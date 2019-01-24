<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    exclude-result-prefixes="i18n">

<xsl:template name="page">
<page status="">
<div id="main">


<xsl:if test="//page/payment">

		<table border="0" cellspacing="1" cellpadding="3">
			<form name="frmCardInfo" method="post" action="auth.jsp" onsubmit="return frmCardInfo_onsubmit()">
                <input type="hidden" id="oid" name="oid" value="{//page/payment/shop/@oid}"/>
                <input type="hidden" id="term" name="term" value="{//page/payment/shop/@merchantId}"/>

				<tr>
					<td colspan="2" height="20">
					</td>
				</tr>
				<tr>
					<td align="center" valign="middle">
						<img border="0">
							<xsl:attribute name="src">/images/logo/<xsl:value-of select="//page/payment/shop/@img"/></xsl:attribute>
						</img>
					</td>
					<td valign="top">
						<font size="3">Сумма заказа:<b>
								<xsl:text>
								</xsl:text>
								<font color="red">
									<xsl:apply-templates select="//page/payment/order/@amount"/>
								</font></b>

							<xsl:text>
							</xsl:text>
							<xsl:apply-templates select="//page/payment/order/@currency"/>
						</font><br/>
                        <xsl:if test="//page/payment/order/@showcurr[.='usd']">
											 (~<xsl:apply-templates select="//page/payment/order/@amount_usd"/> USD. Сумма может меняться в пределах 3% в зависимости от обменного курса валюты)
						</xsl:if>
						<br/>
						<br/>Продавец:<b>
								<xsl:text>
								</xsl:text>
							<xsl:apply-templates select="//page/payment/shop/@merchantName"/></b>
						<br/>Оплата на сайте<b>
								<xsl:text>
								</xsl:text>
							<xsl:apply-templates select="//page/payment/shop/@name"/></b>
						<br/>Номер заказа:
								<xsl:text>
								</xsl:text>
						<xsl:apply-templates select="//page/payment/order/@id"/>
						<br/>
						<br/>
					</td>
				</tr>
				<tr>
					<td height="1" colspan="2" bgcolor="Black">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<b>Вниманию покупателя:</b>
					</td>
				</tr>
				<tr>
					<td colspan="2">К оплате принимаются платежные карты систем American Express,  Visa и Master Card<br/><br/>
                        <br/>Поддерживается Visa 3-D Secure и Master Card Secure Code авторизация<br/>
                        <a href="#" onclick='window.open("/includes/kkb_info.jsp", "3ds_kkb", "height=310, width=350, scrollbar=0, resizable=0")'>Информация для владельцев платежных карт Казкоммерцбанка.</a><br/>
                        <br/><a href="#" onclick='window.open("/includes/hsbk_info.jsp", "cvv_win", "height=210, width=245, scrollbar=0, resizable=0")'>Информация для владельцев платежных карт Народного Банка.</a>

					</td>
				</tr>
				<tr>
					<td height="1" colspan="2" bgcolor="Black">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<br/>
						<b>Информация о платежной карте</b>
					</td>
				</tr>
				<tr>
					<td valign="top" width="50%">Поля помеченные звездочкой (<b>
							<font color="Red">*</font></b>)
            обязательны к заполнению.<br/><br/>Будьте внимательны. На проведение платежа выделяется 30 минут или 5 попыток.<br/>
                        <br/></td>
					<td>
						<b>
							<font color="Red">*</font>
						</b>Имя на
          карте<br/><input name="card_name" id="card_name" maxlength="32" class="txtControls">
							<xsl:attribute name="value">
								<xsl:value-of select="//page/payment/payer/@name"/>
							</xsl:attribute></input>
						<br/>
                        <br/>
                        <xsl:if test="//page/payment/shop/@AMEX[.='1']">
                            <font color="Red">*</font>У Вас карта:<br/>
                            <input type="radio" name="typecard" value="VAMC" CHECKED="1" onclick="return addflt();"/> Visa,MasterCard<br/>
                            <input type="radio" name="typecard" value="AMEKS" onclick="return rmflt(0);"/> American Express
                            <br/><br/>
                        </xsl:if>
                        <b>
							<font color="Red">*</font>
						</b>Номер карты<table border="0" cellspacing="2" cellpadding="0">
							<tr>
								<td class="sample" align="center"><span id="fltX">XXXXXXXXXXXXXXXX</span></td>
							</tr>
							<tr>
								<td>
									<input name="card_no_bin" id="card_no_bin" maxlength="16" size="16" class="txtControls" value=""  autocomplete="off"/>
								</td>
							</tr>

							</table>
						<br/>
						<b>
							<font color="Red">*</font>
						</b>Срок действия карты<br/><table width="80%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="sample">месяц</td>
								<td class="sample">год</td>
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
					<td align="left" valign="top">CVV2/CVC2<xsl:if test="//page/payment/shop/@AMEX[.='1']">/CID</xsl:if> --  код, напечатанный на обратной стороне вашей
            карты (3 цифры после номера карты<xsl:if test="//page/payment/shop/@AMEX[.='1']">, либо 4 для AmericanExpress</xsl:if>). Он помогает предотвратить использование
            номера вашей карты злоумышленниками.<br/><a href="#" title="See illustration"
                                       onclick='window.open("/includes/cvv.htm", "cvv_win", "height=180, width=245, scrollbar=0, resizable=0")'>
                                        <i18n:text>seeill</i18n:text>
                                    </a>
					</td>
					<td valign="top">
						<b>
							<font color="Red">*</font>
						</b>CVV2/CVC2<xsl:if test="//page/payment/shop/@AMEX[.='1']">/CID</xsl:if><br/><input type="password" name="sec_cvv2" id="sec_cvv2" class="txtControls" maxlength="4" size="4" value=""/><br/>
            </td>
				</tr>
				<tr>
					<td height="1" colspan="2" bgcolor="Black">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<b>Дополнительная информация</b>
					</td>
				</tr>
				<tr>
					<td valign="top">Дополнительная информация необходима для отправки уведомления.</td>
					<td valign="top">
						<b>
							<font color="Red">*</font>
						</b>Ваш действующий e-mail<br/><input name="email" class="txtControls" id="email" maxlength="64">
							<xsl:attribute name="value">
								<xsl:value-of select="//page/payment/payer/@email"/>
							</xsl:attribute></input>
						<br/>
						<input type="checkbox" class="txtControls" name="chSendNotify" value="yes">
							<xsl:if test="//page/payment/payer/@allnotify[.='yes']">
								<xsl:attribute name="checked">
								</xsl:attribute>
							</xsl:if>
						</input>Отправлять уведомления об ошибках</td>
				</tr>
				<tr>
					<td valign="top">
						<br/>Формат: (код города) номер</td>
					<td valign="top">Ваш контактный телефон<br/><input name="phone" class="txtControls" id="phone" maxlength="64">
							<xsl:attribute name="value">
								<xsl:value-of select="//page/payment/payer/@phone"/>
							</xsl:attribute></input>
						<br/>
					</td>
				</tr>
				                    <tr>
					<td align="center">
						<br/>
						<input type="reset" value="Очистить" style="BORDER:  1px outset; FONT-FAMILY: Verdana, Arial, sans-serif; FONT-SIZE: 7pt;" id="reset1" name="reset1"/>
					</td>
					<td valign="bottom">
						<input type="submit" value="Оплатить" style="BORDER:  1px outset; FONT-FAMILY: Verdana, Arial, sans-serif; FONT-SIZE: 9pt; FONT-WEIGHT: bold" id="submit1" name="submit1"/>
					</td>
                    <td  valign="center">
						<a>
						<xsl:attribute name="href">
							<xsl:value-of select="//page/payment/shop/@backLink"/>
						</xsl:attribute>Вернуться
					    </a>
                    </td>
                </tr>
                <tr><td align="center" colspan="2"><b>ВНИМАНИЕ После нажатия на кнопку "Оплатить", обязательно дождитесь ответа сервера!!!</b></td></tr>
				<tr>
					<td height="10" colspan="2">
					</td>
				</tr>
			</form>
		</table>

</xsl:if>
<xsl:if test="//page/result">
		<br/>
		<TABLE>
			<TR>
				<TD colSpan="2">
					<b>Результат авторизации</b>
				</TD>
			</TR>
			<TR>
				<TD colSpan="2">
					<BR/>
					<xsl:if test="//page/result/@code[.='00']">
						<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
							<TR>
								<TD colspan="2">Платеж принят<br/><br/></TD>
							</TR>
							<TR>
								<TD colspan="2">Магазин: <xsl:value-of select="//page/result/merchant/@shopname"/></TD>
							</TR>
							<TR>
								<TD colspan="2">Продавец: <xsl:value-of select="//page/result/merchant/@name"/></TD>
							</TR>
							<TR>
								<TD colspan="2">Терминал ID: <xsl:value-of select="//page/result/merchant/@id"/><br/><br/></TD>
							</TR>
							<TR>
								<TD colspan="2" align="center">
									<b>Торговый чек</b>
									<br/>
									<br/>
								</TD>
							</TR>

							<TR>
								<TD>Время транзакции</TD>
								<TD>
									<xsl:value-of select="//page/result/@date"/>
								</TD>
							</TR>
							<TR>
								<TD colspan="2">
									<b>Плательщик</b>
								</TD>
							</TR>
							<TR>
								<TD>Имя</TD>
								<TD>
									<xsl:value-of select="//page/result/payer/@name"/>
								</TD>
							</TR>
							<TR>
								<TD>E-mail</TD>
								<TD>
									<xsl:value-of select="//page/result/payer/@mail"/>
								</TD>
							</TR>
							<TR>
								<TD colspan="2">
									<b>Платежная карта</b>
								</TD>
							</TR>
							<TR>
								<TD>Номер карты</TD>
								<TD>
									<xsl:value-of select="//page/result/card/@number"/>
                                </TD>
							</TR>

							<TR>
								<TD colspan="2">
									<b>Платежные реквизиты</b>
								</TD>
							</TR>
							<TR>
								<TD>Референс транзакции</TD>
								<TD>
									<xsl:value-of select="//page/result/@reference"/>
								</TD>
							</TR>
							<TR>
								<TD>Код авторизации</TD>
								<TD>
									<xsl:value-of select="//page/result/@approval_code"/>
								</TD>
							</TR>
							<TR>
								<TD>Код ответа</TD>
								<TD>
									<xsl:value-of select="//page/result/@code"/>
								</TD>
							</TR>
							<TR>
								<TD>Сообщение</TD>
								<TD>
									<xsl:value-of select="//page/result/@message"/>
								</TD>
							</TR>
							<TR>
								<TD colspan="2">
									<b>Заказ</b>
								</TD>
							</TR>
							<TR>
								<TD>Номер заказа</TD>
								<TD>
									<xsl:value-of select="//page/result/order/@id"/>
								</TD>
							</TR>
							<TR>
								<TD>Тип валюты</TD>
								<TD>
									<xsl:value-of select="//page/result/order/@currency_code"/>-<xsl:value-of select="//page/result/order/@currency_name"/></TD>
							</TR>
							<TR>
								<TD>Сумма заказа</TD>
								<TD>
									<xsl:apply-templates select="//page/result/order/@amount"/>
								</TD>
							</TR>
                            <TR>
                                <TD colspan="2"><br/>
                                <i18n:text>savecheque</i18n:text>.
                                </TD>
                            </TR>
                            <TR>
                                <TD colspan="2"><br/>
                                    <xsl:if test="//page/result/merchant/@backLink[.!='']">
                                    <xsl:text> </xsl:text>
                                        <input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Verdana, Arial, sans-serif; FONT-SIZE: 9pt;" value="backtoshop" onclick='location.href="{//page/result/merchant/@backLink}"'  i18n:attr="value"/>
                                    </xsl:if>
                                </TD>
                            </TR>

						</TABLE>
                        
                        <xsl:if test="//page/result/@baner[.='1']">
                           <TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
                              <TR>
                                  <TD colspan="2">
                                  <br/><br/>
                                  <i18n:text>Congratulations</i18n:text>!
                                  <br/>
                                  <i18n:text>Now you are a user of KAZKOM’s internet banking portal Homebank.kz</i18n:text>!
                                  <br/>
                                  <i18n:text>Please remember your personal information for future entering into the portal</i18n:text>:
                                  <ul>
                                   <li><i18n:text>ID</i18n:text>: <xsl:value-of select="//page/result/@iHBID"/></li>
                                   <li><i18n:text>Password</i18n:text>: <xsl:value-of select="//page/result/@sPWD"/></li>
                                  </ul>
                                  <i18n:text>This allows to check the statements for all accounts, pay for various service providers through</i18n:text>:<br/>
                                  <br/>
                                  <a href="https://www.homebank.kz">https://www.homebank.kz</a>
                                  <br/>
                                  <i18n:text>It is safe, convenient and advantageous</i18n:text>!
                                  <br/><br/>
                                  <i18n:text>More information about the benefits and opportunities of Homebank.kz portal you can find by following the link</i18n:text>:<br/>
                                  <a href="http://wiki.homebank.kz/page/What_is_this">http://wiki.homebank.kz/page/What_is_this</a>
                                  <br/><br/>
                                      <i18n:text>Best regards,</i18n:text><br/>
                                      <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                  <br/><br/>
                                  </TD>
                              </TR>
                          </TABLE>
                        </xsl:if>
                        <xsl:if test="//page/result/@baner[.='2']">
                           <TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
                              <TR>
                                  <TD colspan="2">
                                  <br/><br/>
                                  <i18n:text>To ensure the security of Internet payments it is recommended to use KAZKOM’s virtual banking card.</i18n:text>
                                  <br/><br/>
                                  <i18n:text>Virtual card can be ordered for the 1580 tenge/year through Homebank.kz portal by following the links</i18n:text>:<br/>
                                  <br/>
                                  <i><i18n:text>Finance - Operations - Payment Cards - Issuing a virtual card</i18n:text></i> <i18n:text>dop1</i18n:text>.<br/>
                                  <br/><br/>
                                  <i18n:text>Learn more information about the benefits and opportunities of virtual card by following the link</i18n:text>:<br/>
                                  <a href="http://ru.kkb.kz/cards/page/Virtual_card">http://ru.kkb.kz/cards/page/Virtual_card</a>&#160;&#160;<i18n:text>dop2</i18n:text>.
                                  <br/><br/>
                                      <i18n:text>Best regards,</i18n:text><br/>
                                      <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                  <br/><br/>
                                  </TD>
                              </TR>
                          </TABLE>
                        </xsl:if>
                        <xsl:if test="//page/result/@baner[.='3']">
                           <TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
                              <TR>
                                  <TD colspan="2">
                                  <br/><br/>
                                  <i18n:text>To ensure the security of Internet payments it is recommended to use KAZKOM’s virtual banking card. This card can be replenished through Homebank for the definite amount of money that is needed for execution of a specific payment</i18n:text>.
                                  <br/><br/>
                                  <i18n:text>Learn more information about the benefits and opportunities of virtual card by following the link</i18n:text>:<br/>
                                  <a href="http://ru.kkb.kz/cards/page/Virtual_card">http://ru.kkb.kz/cards/page/Virtual_card</a>&#160;&#160;<i18n:text>dop2</i18n:text>.
                                  <br/><br/>
                                      <i18n:text>Best regards,</i18n:text><br/>
                                      <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                  <br/><br/>
                                  </TD>
                              </TR>
                           </TABLE>
                        </xsl:if>
                        <xsl:if test="//page/result/@baner[.='4']">
                           <TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
                              <TR>
                                  <TD colspan="2">
                                  <br/><br/>
                                  <i18n:text>Additionally, we remind you that you registered at internet banking portal of KAZKOM, but apparently, you have forgotten about it.</i18n:text>
                                  <br/><br/>
                                  <i18n:text>We would be glad to remind you the ID and password to the portal, at your telephone call to Call Center at tel. 58-53-34 (258-53-34 inside Almaty).</i18n:text>
                                  <br/><br/>
                                  <i18n:text>Today more than 270,000 cardholders use Homebank.kz for paying to all service providers! Join us</i18n:text>!
                                  <br/><br/>
                                  <i18n:text>More information about the benefits and opportunities of Homebank.kz can be obtained by following the link</i18n:text>:<br/>
                                  <a href="http://wiki.homebank.kz/page/What_is_this">http://wiki.homebank.kz/page/What_is_this</a>&#160;&#160;<i18n:text>dop3</i18n:text>.
                                  <br/><br/>
                                      <i18n:text>Best regards,</i18n:text><br/>
                                      <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                  <br/><br/>
                                  </TD>
                              </TR>
                           </TABLE>
                        </xsl:if>

                        <xsl:if test="//page/result/@baner[.='5']">
                           <TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
                             <TR>
                                <TD colspan="2">
                                <br/><br/>
                                <i18n:text>We suggest you to sign up for KAZKOM’s Internet banking portal</i18n:text>&#160;&#160;<a href="https://www.homebank.kz">https://www.homebank.kz</a>&#160;&#160;<i18n:text>for saving your time and money.</i18n:text>
                                <br/><br/>
                                <i18n:text>To register free for internet banking portal Homebank.kz, you have to be a holder of KAZKOM’s any payment card. You can order VISA Electron card by calling us by telephone number: +7 (727) 330-00-35.</i18n:text>
                                <br/><br/>
                                <i18n:text>Today more than 270,000 cardholders use Homebank.kz for paying to all service providers! Join us</i18n:text>
                                <br/><br/>
                                <i18n:text>More information about the benefits and opportunities of Homebank.kz can be obtained by following the link</i18n:text>:<br/>
                                <a href="http://wiki.homebank.kz/page/What_is_this">http://wiki.homebank.kz/page/What_is_this</a> <i18n:text>dop3</i18n:text>
                                <br/><br/>
                                    <i18n:text>Best regards,</i18n:text><br/>
                                    <i18n:text>JSC “Kazkommertsbank”</i18n:text>
                                <br/><br/>
                                </TD>
                             </TR>
                           </TABLE>
                        </xsl:if>


				</xsl:if>
					<xsl:if test="//page/result/@code[.!='00']">
						<TABLE border="0" cellPadding="3" cellSpacing="1">
							<TR>
								<TD colspan="2">
									<b>
										<font color="red">Ошибка авторизации</font>
									</b>
									<br/>
									<br/>
								</TD>
							</TR>

                            <TR>
                                <TD><i18n:text>OrderIDpl</i18n:text>:</TD>
                                <TD>
                                    <xsl:apply-templates select="//page/result/order/@id"/>
                                </TD>
                            </TR>                            
							<TR>
								<TD>Код ошибки:</TD>
								<TD>
									<xsl:apply-templates select="//page/result/@code"/>
								</TD>
							</TR>
							<TR>
								<TD>Причина:</TD>
								<TD>
									<xsl:apply-templates select="//page/result/@message"/>
								</TD>
							</TR>
							<TR>
								<TD>Референс:</TD>
								<TD>
									<xsl:apply-templates select="//page/result/@reference"/>
								</TD>
							</TR>
						</TABLE>
						<br/>
						<br/>
						<br/>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="//page/result/merchant/@retryLink[.!='']"/>
							</xsl:attribute>Повторить попытку</a>

							<xsl:if test="//page/result/merchant/@backLink[.!='']">
								<br/><br/>
								<a><xsl:attribute name="href">
								<xsl:value-of select="//page/result/merchant/@backLink"/>
								</xsl:attribute>Вернуться в магазин</a>
							</xsl:if>
					</xsl:if>
					<BR/>
					<BR/>
					<BR/>При возникновении вопросов обращайтесь к администратору системы: <A>
						<xsl:attribute name="href">
							mailto:<xsl:value-of select="//page/result/@adminmail"/>
						</xsl:attribute>
						<xsl:value-of select="result/@adminmail"/></A></TD>
			</TR>
		</TABLE>

    </xsl:if>
    <xsl:if test="//page/error">
		<TABLE border="0">
			<TR>
				<TD valign="top">
					<br/>
					<b>
						<font color="red">Внимание! Ошибка!</font>
					</b>
					<br/>
					<br/>
					<br/>
					<xsl:apply-templates select="//page/error/@message"/>
					<br/>
					<br/>
                    <i18n:text>trtime</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@time"/>
                    <br/><i18n:text>sessionid</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@sessionid"/>
                    <br/><i18n:text>ipadr</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@ip"/>
                    
					<br/>
					<br/>
					<br/>
					<br/>
					<xsl:if test="//page/error/pageinfo/@retryLink[.!='']">
						<BR/>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="//page/error/pageinfo/@retryLink"/>
							</xsl:attribute>Повторить попытку</a>
						<BR/>
						<BR/>
					</xsl:if>
					<xsl:if test="//page/error/pageinfo/@backLink[.!='']">
						<BR/>
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="//page/error/pageinfo/@backLink"/>
							</xsl:attribute>Вернуться в магазин</a>
						<BR/>
						<BR/>
					</xsl:if>
					<BR/>При возникновении вопросов обращайтесь к администратору системы: <A>
						<xsl:attribute name="href">mailto:<xsl:value-of select="//page/error/pageinfo/@adminmail"/>
                    </xsl:attribute>
                        <xsl:value-of select="//page/error/pageinfo/@adminmail"/></A></TD>
			</TR>
		</TABLE>
    </xsl:if>

</div>
</page>
	</xsl:template>
    <xsl:template match="/">
        <html>
            <head>
                <title>Kazkommertsbank's Authorization Server</title>
                <link rel="stylesheet" href="/includes/style.css" type="text/css"/>
            </head>
            <body leftmargin='0' topmargin='0' bottommargin='0' rightmargin='0'>

            <table border='0'>
            <tr>
            <td><img src='/images/homeshop/logo.gif' border='0'/></td>
            <td style='padding-left: 40px;'>
            	<div style='color: #7E8080; font-size: 12pt;font-weight: bold;padding-left:20px;'>
            		Ваш домашний супермаркет
            	</div>
            	<div style='padding-top: 5px;'>
            		<table border='0' cellpadding='0' cellspacing='0'>
            		<tr>
            		<td><img src='/images/homeshop/bg_say_left.gif'/></td>
            		<td style='border-top: #C9C9C9 1px solid;border-bottom: #C9C9C9 1px solid;'>
            			<font style='color: #000000; font-size: 10pt;font-weight: bold;'>
            				Для проведения платежа заполните поля ниже!
            			</font>
            		</td>
            		<td><img src='/images/homeshop/bg_say_right.gif'/></td>
            		</tr>
            		</table>
            	</div>
            </td>
            <td><img src='/images/homeshop/chuvak.jpg'/></td>
            </tr>
            </table>

            <table border='0' cellpadding='0' cellspacing='0' width='100%' height='28'>
            <tr>
            <td bgcolor="#F29000">
            	<table border='0'>
            	<tr>
            	<td style='color: #000000; font-size: 10pt;font-weight: bold;'>
            	Безопасность транзакций гарантирует
            	</td>
            	<td><img src='/images/homeshop/kkbeng_logo_small.gif'/></td>
            	</tr>
            	</table>
            </td>
            <td bgcolor="#F2A800" width='300'></td>
            <td bgcolor="#4C4948" width='170'></td>
            </tr>
            </table>

<br/><br/>

            <table border='0' cellpadding='0' cellspacing='0'>
            <tr>
            <td valign='top'>
  	            <table border='0' cellpadding='0' cellspacing='0' width='320'>
	            <tr>
	            <td bgcolor="#4C4948" style='padding-left: 30px;padding-right: 50px;'>
	            	<div style='color: #ffffff; font-size: 10pt;'>
	            		Служба поддержки
	            	</div>
	                <div>
	                	<font style='color: #F2A822; font-size: 14pt;font-weight: bold;'>+7 (727) </font>
	                	<font style='color: #ffffff; font-size: 16pt;font-weight: bold;'>330-00-22</font>
	            	</div>
	            	<div>
	            		<a href='mailto:info@homeshop.kz'
	            		style='color: #ffffff; font-size: 10pt;text-decoration: underline;'>info@homeshop.kz</a>
	            	</div>
	            </td>
	            <td><img src='/images/homeshop/support_left.jpg' border='0' /></td>
	            </tr>
	            </table>
            </td>
            <td>
  <xsl:call-template name="page"/>
            </td>
            </tr>
            </table>

                <script src="/includes/service/clientCheck_amex2_s.js"/>
               <br/>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
