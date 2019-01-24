<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
				exclude-result-prefixes="i18n">


	<xsl:template name="page">
		<page status="">
			<div id="main" class="main">
				<div class="epay-wrapper">

					<xsl:if test="//page/payment">
						<table border="0" cellspacing="1" cellpadding="3">
							<form name="frmCardInfo" id="frmCardInfo" method="post" action="auth.jsp" onsubmit="return frmCardInfo_onsubmit()">
								<input type="hidden" id="Language" name="Language" value="{//page/payment/shop/@lang}"/>
								<input type="hidden" id="oid" name="oid" value="{//page/payment/shop/@oid}"/>
								<input type="hidden" id="term" name="term" value="{//page/payment/shop/@merchantId}"/>


								<table width="100%" class="order">
									<tr>
										<td width="40%">
											<div class="commersant-logo">
												<img border="0">
													<xsl:attribute name="src">/images/logo/<xsl:value-of select="//page/payment/shop/@img"/></xsl:attribute>
												</img>
											</div>
										</td>
										<td width="60%">
											<div class="epay-order">
												<div class="epay-order-amount">
													<i18n:text>orderam</i18n:text>:
													<xsl:apply-templates select="//page/payment/order/@amount"/>
													<xsl:text> </xsl:text>
													<xsl:apply-templates select="//page/payment/order/@currency"/>
													<xsl:if test="//page/payment/order/@showcurr[.='usd']">
														(~<xsl:apply-templates select="//page/payment/order/@showamaunt"/> USD. <i18n:text>The sum can vary within the limits of 3% depending on the exchange rate of currency</i18n:text>)
													</xsl:if>
												</div>
												<dl class="dl-horizontal">
													<dt><b><i18n:text>merchant</i18n:text>: </b></dt>
													<dd class="order-padding"><i18n:text>
														<xsl:apply-templates select="//page/payment/shop/@merchantName"/>
													</i18n:text></dd>
													<!--<dt><i18n:text>payfrom</i18n:text></dt>
                                                    <dd> </dd>-->
													<dt><b><i18n:text>orderid</i18n:text>: </b></dt>
													<dd class="order-padding"><xsl:apply-templates select="//page/payment/order/@id"/></dd>
												</dl>
											</div>
										</td>
									</tr>
									<tr><td height="10px"></td></tr>
									<tr>
										<td colspan="2">
											<p id="triesInfo" class="text-blue"><i18n:text>payattempts</i18n:text></p>
										</td>
									</tr>
								</table>

								<div class="card-form">
									<div class="card-form-in gray-bg clearfix ">
										<div class="column pull-left">
											<i18n:text>KKBandHalyk3DInfo</i18n:text>
											<!--Информация о <b>Visa <nobr>3-D Secure</nobr></b> и <b>MasterCard SecureCode</b> владельцам платежных карт:-->
											<ul class="list-bullet-line">
												<li><a href="#" onclick="return kkbinfo()"> KAZKOM</a></li>
												<script language="javascript">

													function kkbinfo() {
													window.open('/includes/kkb_info.htm', '3ds_kkb', 'height=310, width=350, scrollbar=0, resizable=0');       }

												</script>
												<li><a href="#" onclick="return hsbkinfo()"> <i18n:text>halykbank</i18n:text></a></li>
												<script language="javascript">

													function hsbkinfo()
													{
													window.open('/includes/hsbk_info.htm', 'cvv_win', 'height=210, width=245, scrollbar=0, resizable=0');
													}

												</script>
											</ul>
											<div class="column pull-left">
												<img id="cexpiry" src="/images/default_new/cexpiry.png" class="img_hidden cexpiry" />
											</div>
										</div>
										<div class="column pull-right">
											<div class="cards">
												<img src="/images/default_new/small-visa.png" />
												<img src="/images/default_new/card-visa-e.png" />
												<img src="/images/default_new/card-mastercard.png" />
												<img src="/images/default_new/card-maestro.png" />
												<img src="/images/default_new/card-cirrus.png" />
												<img src="/images/default_new/card-ae.png" />
											</div>
											<div class="form-group required jsFormGroup pull-left">
												<b>
													<i18n:text>cardname</i18n:text>
													<font color="Red">*</font>
												</b>
												<br/>
												<input name="card_name" id="card_name" maxlength="32" size="34" required=""
													   onfocus="ShowTips(this.id);" class="txtControls" pattern="^[a-zA-Z ]+$">
													<xsl:attribute name="value">
														<xsl:value-of select="//page/payment/payer/@name"/>
													</xsl:attribute></input>

												<br/>
												<br/>

												<b>
													<!--<div style="float:left">-->
													<i18n:text>ncard</i18n:text>
													<font color="Red">*</font>
													<a id="forPWD" href="#" for="isPWD" onclick="changeShowBtnText(this);" class="forPWD" >скрыть номер</a>
													<!--</div>-->

												</b>

												<br/>
												<input name="card_no_bin" id="card_no_bin" autocomplete="off" maxlength="4" size="4" class="txtControls cardnum" pattern="^[0-9]+$"
													   onfocus="ShowTips(this.id);" required="" onkeyup="nextField(this, 'card_no_group1', event); "/>
												<input type="password" name="card_no_group1" id="card_no_group1" autocomplete="off" maxlength="4" size="4" class="txtControls cardnum" pattern="^[0-9]+$"
													   onfocus="ShowTips(this.id);" required="" onkeyup="nextField(this, 'card_no_group2', event);"/>
												<input type="password" name="card_no_group2" id="card_no_group2" autocomplete="off" maxlength="4" size="4"  class="txtControls cardnum" pattern="^[0-9]+$"
													   onfocus="ShowTips(this.id);" required="" onkeyup="nextField(this, 'card_no_group3', event);"/>
												<input name="card_no_group3" id="card_no_group3" autocomplete="off" maxlength="4" size="4"  class="txtControls cardnum" pattern="^[0-9]+$"
													   onfocus="ShowTips(this.id);" required=""/>
												<br/>
												<br/>

												<div class="pull-left">
													<b><i18n:text>expdate</i18n:text>
														<font color="Red">*</font>
													</b><br/>
													<select name="exp_month" id="exp_month" required="" class="txtControls" onFocus="ShowTips(this.id);">
														<option value="">MM</option>
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
													/
													<select name="exp_year" id="exp_year" required="" class="txtControls" onFocus="ShowTips(this.id);">
														<option value="">YYYY</option>
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
														<option>2025</option>

													</select>
												</div>
												<div class="pull-right">
													<b>CVV2<font color="Red">*</font>
													</b>
													<xsl:if test="//page/payment/shop/@AMEX[.='1']">/CID</xsl:if><br/>
													<input type="password" name="sec_cvv2" id="sec_cvv2" required=""  class="txtControls cvv2" pattern="^[0-9]+$"
														   maxlength="4" size="5" onfocus="ShowTips(this.id);"/>
													<!---<i18n:text>notused</i18n:text>-->
												</div>
											</div>

											<div class="pull-right">
												<img id="chname" src="/images/default_new/cname.png" class="img_hidden cname" />
												<img id="cnum" src="/images/default_new/cnum.png" class="img_hidden cnum" />
												<div id="ccvv" class="img_hidden ccvv">
													<img  src="/images/default_new/ccvv.png" class="ccvv" />
													<br/>
													<div class="cvv-tip">Три цифры (четыре для AMEX) <br/> на обратной стороне карты</div>
												</div>
											</div>
										</div>

									</div>



									<!--<div class="mail">-->
									<!--<b><i18n:text>mailadd</i18n:text><font color="Red">*</font></b>-->
									<!--<br/>-->
									<!--<input name="email" pattern="^[\s\w\.-]*@[\s\w\.-]*" class="txtControls" id="email" maxlength="64" size="23" onfocus="ShowTips(this.id);">-->
									<!--<xsl:attribute name="value">-->
									<!--<xsl:value-of select="//page/payment/payer/@email"/>-->
									<!--</xsl:attribute>-->
									<!--</input>-->
									<!--</div>-->

									<!--<div>-->
									<!--<b><i18n:text>cphone</i18n:text></b>-->
									<!--<br/>-->
									<!--<input name="phone"  id="phone" pattern="^[+]*[0-9()\- ]*$" maxlength="64" size="23" class="txtControls" onfocus="ShowTips(this.id);">-->
									<!--<xsl:attribute name="value">-->
									<!--<xsl:value-of select="//page/payment/payer/@phone"/>-->
									<!--</xsl:attribute>-->
									<!--</input>-->
									<!--</div>-->

									<div style="text-align:center">
										<table align="center" border="0" width="100%">
											<tr>
												<td align="right" width="40%">
													<div>
														<b><i18n:text>mailadd</i18n:text><font color="Red">*</font></b>
														<br/>
														<input name="email" pattern="^[\s\w\.-]*@[\s\w\.-]*" class="txtControls" id="email" maxlength="64" size="23" onfocus="ShowTips(this.id);">
															<xsl:attribute name="value">
																<xsl:value-of select="//page/payment/payer/@email"/>
															</xsl:attribute>
														</input>
													</div>
												</td>
												<td width="20%"></td>
												<td width="40%">
													<div>
														<b><i18n:text>cphone</i18n:text></b>
														<br/>
														<input name="phone"  id="phone" pattern="^[+]*[0-9()\- ]*$" maxlength="64" size="23" class="txtControls" onfocus="ShowTips(this.id);">
															<xsl:attribute name="value">
																<xsl:value-of select="//page/payment/payer/@phone"/>
															</xsl:attribute>
														</input>
													</div>
												</td>
											</tr>
										</table>
									</div>

									<div class="btns-area gray-bg">

										<!--<input type="reset" value="clform" class="btn btn-default btn-reset jsBtnReset" id="reset1" name="reset1" i18n:attr="value" onfocus="ShowTips(this.id);"/>-->

										<!--<input type="button" value="back" class="btn btn-default btn-reset jsBtnReset" id="reset1" name="reset1" i18n:attr="value" onfocus="ShowTips(this.id);"/>-->
										<!--<input type="submit" value="submdata" class="btn btn-orange btn-submit" id="submit1" name="submit1" i18n:attr="value" onfocus="ShowTips(this.id);"/>-->

										<table align="center" border="0"  width="100%">
											<tr>
												<td align="right" width="48%">
													<input type="button" value="back" class="btn btn-default btn-reset jsBtnReset" onclick='location.href="{//page/payment/shop/@failureBackLink}"' i18n:attr="value" onfocus="ShowTips(this.id);"/>
												</td>
												<td width="4%"></td>
												<td width="48%">
													<input type="submit" value="submdata" class="btn btn-orange btn-submit" id="submit1" name="submit1" i18n:attr="value" onfocus="ShowTips(this.id);"/>
												</td>
											</tr>
										</table>

									</div>

									<div class="form-alert">
										<b class="text-red"><i18n:text>waitanswer</i18n:text></b>
									</div>


								</div>
							</form>

						</table>
					</xsl:if>

					<xsl:if test="//page/result">

						<div style="text-align:center">
							<xsl:if test="(//page/result/@baner[.='1']) or (//page/result/@baner[.='4']) or //page/result/@baner[.='5']">
								<a href="https://www.homebank.kz/login/join/view.htm">
									<img src="/images/banner/hb_register.jpg" alt="" width="560" class="gray-bg"/>
								</a>
							</xsl:if>
						</div>

						<br/>

						<div class="form-controls gray-bg">
							<TABLE border="0" width="100%" class="result_table" >
								<TR>
									<TD colSpan="2">
										<i18n:text><b>Authorization result</b></i18n:text>
									</TD>
								</TR>
								<TR>
									<TD colSpan="2">
										<BR/>
										<xsl:if test="//page/result/@code[.='00']">
											<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="90%">
												<TR>
													<TD colspan="2"><font color="green"><i18n:text>payaccepted</i18n:text></font><br/><br/></TD>
												</TR>
												<TR>
													<TD colspan="2"><i18n:text>shop</i18n:text>: <xsl:value-of select="//page/result/merchant/@shopname"/></TD>
												</TR>
												<TR>
													<TD colspan="2"><i18n:text>merchant</i18n:text>: <xsl:value-of select="//page/result/merchant/@name"/></TD>
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
												<!--<TR>
                                                    <TD colspan="2">
                                                        <b><i18n:text>persinfo</i18n:text></b>
                                                    </TD>
                                                </TR>-->
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
												<!--<TR>
                                                    <TD colspan="2">
                                                        <b><i18n:text>cardinfo</i18n:text></b>
                                                    </TD>
                                                </TR>-->
												<TR>
													<TD><i18n:text>Card Number</i18n:text></TD>
													<TD>
														<xsl:value-of select="//page/result/card/@number"/>
													</TD>
												</TR>

												<TR>
													<TD colspan="2" height="10px">
														<!--<b><i18n:text>Order Info</i18n:text></b>-->
													</TD>
												</TR>
												<TR>
													<TD><i18n:text>OrderID</i18n:text></TD>
													<TD>
														<xsl:value-of select="//page/result/order/@id"/>
													</TD>
												</TR>
												<TR>
													<TD><i18n:text>Order Amount</i18n:text></TD>
													<TD>
														<b>
															<xsl:value-of select="//page/result/order/@amount"/>
															<xsl:text> </xsl:text>
															<xsl:value-of select="//page/result/order/@currency_code"/>
															<xsl:text> </xsl:text>
															<xsl:apply-templates select="response/order/@currency_name"/>
														</b>
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
													<TD colspan="2"><br/>
														<i18n:text>savecheque</i18n:text>.
													</TD>
												</TR>
												<xsl:if test="//page/result/merchant/@backLink[.!='']">
													<TR>
														<TD colspan="2"><br/>
															<xsl:if test="//page/result/merchant/@backLink[.!='']">
																<xsl:text> </xsl:text>
																<input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Verdana, Arial, sans-serif; FONT-SIZE: 9pt;" value="backtoshop" onclick='location.href="{//page/result/merchant/@backLink}"'  i18n:attr="value"/>
															</xsl:if>
														</TD>
													</TR>
												</xsl:if>
											</TABLE>
											<xsl:if test="//page/result/@baner[.='1']">
												<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="96%" class="footer">
													<TR>
														<TD colspan="2">
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
															<a href="https://www.homebank.kz">https://www.homebank.kz</a>
															<br/>
															<i18n:text>It is safe, convenient and advantageous</i18n:text>!
															<br/><br/>
															<i18n:text>More information about the benefits and opportunities of Homebank.kz portal you can find by following the link</i18n:text>:<br/>
															<a href="http://wiki.homebank.kz/page/What_is_this">http://wiki.homebank.kz/page/What_is_this</a>
															<br/><br/>
															<i18n:text>Best regards,</i18n:text><br/>
															<i18n:text>JSC “Kazkommertsbank”</i18n:text>
															<br/>
														</TD>
													</TR>
												</TABLE>
											</xsl:if>
											<xsl:if test="//page/result/@baner[.='2']">
												<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="96%" class="footer">
													<TR>
														<TD colspan="2">
															<br/><br/>
															<i18n:text>To ensure the security of Internet payments it is recommended to use KAZKOM’s virtual banking card.</i18n:text>
															<br/>
															<i18n:text>Virtual card can be ordered for the 1580 tenge/year through Homebank.kz portal by following the links</i18n:text>:<br/>
															<br/>
															<i><i18n:text>Finance - Operations - Payment Cards - Issuing a virtual card</i18n:text></i> <i18n:text>dop1</i18n:text>.<br/>
															<br/>
															<i18n:text>Learn more information about the benefits and opportunities of virtual card by following the link</i18n:text>:<br/>
															<a href="http://ru.kkb.kz/cards/page/Virtual_card">http://ru.kkb.kz/cards/page/Virtual_card</a>&#160;&#160;<i18n:text>dop2</i18n:text>.
															<br/><br/>
															<i18n:text>Best regards,</i18n:text><br/>
															<i18n:text>JSC “Kazkommertsbank”</i18n:text>
															<br/>
														</TD>
													</TR>
												</TABLE>
											</xsl:if>
											<xsl:if test="//page/result/@baner[.='3']">
												<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="96%" class="footer">
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
															<br/>
														</TD>
													</TR>
												</TABLE>
											</xsl:if>
											<xsl:if test="//page/result/@baner[.='4']">
												<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="96%" class="footer">
													<TR>
														<TD colspan="2">
															<br/><br/>
															<i18n:text>We remind you that you registered at internet banking portal of KAZKOM, but apparently, you have forgotten about it.</i18n:text>
															<br/>
															<i18n:text>We would be glad to remind you the ID to the portal, at your telephone call to Call Center at tel. (727) 258-53-34.</i18n:text>
															<br/><br/>
															<i18n:text>More information about the benefits and opportunities of Homebank.kz can be obtained by following the link</i18n:text>:<br/>
															<a href="http://wiki.homebank.kz/page/What_is_this">http://wiki.homebank.kz/page/What_is_this</a>&#160;&#160;<i18n:text>dop3</i18n:text>.
															<br/><br/>
															<i18n:text>Best regards,</i18n:text><br/>
															<i18n:text>JSC “Kazkommertsbank”</i18n:text>
															<br/>
														</TD>
													</TR>
												</TABLE>
											</xsl:if>

											<xsl:if test="//page/result/@baner[.='5']">
												<TABLE border="0" cellPadding="1" cellSpacing="2" align="center" width="96%" class="footer" >
													<TR>
														<TD colspan="2">
															<br/><br/>
															<i18n:text>We suggest you to sign up for KAZKOM’s Internet banking portal</i18n:text>&#160;&#160;<a href="https://www.homebank.kz">https://www.homebank.kz</a>&#160;&#160;<i18n:text>for saving your time and money.</i18n:text>
															<br/>
															<i18n:text>Register is free</i18n:text>
															<br/>
															<i18n:text>Today more than 270,000 cardholders use Homebank.kz for paying to all service providers! Join us</i18n:text>
															<br/>
															<i18n:text>More information about the benefits and opportunities of Homebank.kz can be obtained by following the link</i18n:text>:<br/>
															<a href="http://wiki.homebank.kz/page/What_is_this">http://wiki.homebank.kz/page/What_is_this</a> <xsl:text> </xsl:text> <i18n:text>dop3</i18n:text>
															<br/><br/>
															<i18n:text>Best regards,</i18n:text><br/>
															<i18n:text>JSC “Kazkommertsbank”</i18n:text>
															<br/>
														</TD>
													</TR>
												</TABLE>
											</xsl:if>

										</xsl:if>

										<xsl:if test="//page/result/@code[.!='00']">
											<div class="epay-secure-form">
												<TABLE border="0" cellPadding="3" cellSpacing="1" width="100%" style="">
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
														<TD width="25%"><i18n:text>OrderIDpl</i18n:text>:</TD>
														<TD width="75%">
															<xsl:apply-templates select="//page/result/order/@id"/>
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
														<TD><font color="red">
															<xsl:apply-templates select="//page/result/@message"/></font>
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
											</div>
											<br/>
											<br/>
											<br/>
											<xsl:if test="//page/result/merchant/@retryLink[.!='']">
												<xsl:text> </xsl:text>
												<input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Verdana, Arial, sans-serif; FONT-SIZE: 9pt;" value="tryagain" onclick='location.href="{//page/result/merchant/@retryLink}"'  i18n:attr="value"/>
											</xsl:if>
											<xsl:if test="//page/result/merchant/@backLink[.!='']">
												<xsl:text> </xsl:text>
												<input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Verdana, Arial, sans-serif; FONT-SIZE: 9pt;" value="back" onclick='location.href="{//page/result/merchant/@failureBackLink}"'  i18n:attr="value"/>
											</xsl:if>
											<br/>
										</xsl:if>
										<BR/>
										<center class="footer">
											<i18n:text>For additional information mail to</i18n:text>: <A>
											<xsl:attribute name="href">mailto:<xsl:value-of select="//page/result/@adminmail"/></xsl:attribute>
											<xsl:value-of select="//page/result/@adminmail"/></A>
										</center>
									</TD>
								</TR>
							</TABLE>
						</div>


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
									<xsl:apply-templates select="//page/error/@message"/>
									<br/>
									<br/>
									<i18n:text>trtime</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@time"/>
									<br/><i18n:text>sessionid</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@sessionid"/>
									<br/><i18n:text>ipadr</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@ip"/>
									<br/><i18n:text>Server</i18n:text>:&#160;&#160;<xsl:apply-templates select="//page/error/@Server"/>
									<br/>
									<br/>
									<br/>
									<br/>

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
									<xsl:attribute name="href">mailto:<xsl:value-of select="//page/error/pageinfo/@adminmail"/>
									</xsl:attribute>
									<xsl:value-of select="//page/error/pageinfo/@adminmail"/></A>

								</TD>
							</TR>
						</TABLE>

					</xsl:if>

				</div>
			</div>
		</page>
	</xsl:template>






	<xsl:template match="/">
		<html>
			<head>
				<title><i18n:text>Kazkommertsbank's Authorization Server</i18n:text></title>
				<link rel="stylesheet" href="/images/default_new/epay.css" type="text/css"/>
				<link rel="javascript" href="/images/default_new/inputTips.js" type="text/javascript"/>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
			</head>
			<body onload="changeShowBtnText();">
				<div class="epay-wrapper">

					<span class="line"/>
					<div class="epay-header clearfix">
						<div class="column col-left">
							<a href="https://epay.kkb.kz/about" class="logo pull-left">
								<img src="/images/default_new/epay-logo.png" class="img-responsive"/>
							</a>
						</div>
						<div class="column col-right">
							<div class="pull-right clearfix">
								<span class="logos">
									<img src="/images/default_new/visa-verif_62.png" class="img-responsive"/>
								</span>
								<span class="logos">
									<img src="/images/default_new/mastercard-securecode.png" class="img-responsive"/>
								</span>
							</div>
							<div class="kazkom-logo pull-right clearfix">
								<a href="http://www.kkb.kz/">
									<img src="/images/default_new/logo-kazkom3.png" class="img-responsive pull-left"/>
								</a>
								Безопасность транзакций гарантирует <b>Казком</b>
							</div>
						</div>
					</div>
				</div>

				<xsl:call-template name="page"/>

			</body>
			<script src="/images/default_new/inputTips.js" >&#160;</script>
			<script src="/includes/service/default_new/clientCheck_def.js" >&#160;</script>
		</html>
	</xsl:template>



</xsl:stylesheet>

