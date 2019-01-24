<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0" xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                exclude-result-prefixes="i18n">

    <LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
                  android:layout_width="match_parent"
                  android:layout_height="match_parent" >

        <WebView
                android:id="@+id/kazkomWebView"
                android:layout_width="match_parent"
                android:layout_height="match_parent" />

    </LinearLayout>


    <xsl:variable name="inc">/images/kazna_mobile/</xsl:variable>

    <xsl:template name="page">

        <div class="form-holder"><!-- form-holder starts -->


            <xsl:if test="//page/payment">
                <form id="frmCardInfo" name="frmCardInfo" method="post" action="{//page/payment/shop/@site}/jsp/process/auth.jsp" onsubmit="return frmCardInfo_onsubmit()">

                    <input type="hidden" id="Language" name="Language" value="{//page/payment/shop/@lang}"/>
                    <input type="hidden" id="oid" name="oid" value="{//page/payment/shop/@oid}"/>
                    <input type="hidden" id="term" name="term" value="{//page/payment/shop/@merchantId}"/>

                    <!--decided to remove the block. Please, do not remove it at all, because may be we will need it again-->
                    <!-- navigation container starts -->
                    <!-- <div class="msg_list">
                        <p class="msg_head">Подробности заказа</p>
                        <div class="msg_body">
                            <p><b><i18n:text>orderam</i18n:text>:</b> <xsl:apply-templates select="//page/payment/order/@amount"/>
                                <xsl:apply-templates select="//page/payment/order/@currency"/></p>
                            <p><b><i18n:text>addpay</i18n:text>::</b> <xsl:apply-templates select="//page/payment/shop/@merchantName"/></p>
                            <p><b><i18n:text>Kabinet</i18n:text>:</b> <xsl:apply-templates select="//page/payment/shop/@name"/></p>
                            <p><b><i18n:text>OrderID</i18n:text>:</b> <xsl:apply-templates select="//page/payment/order/@id"/></p>
                        </div>
                    </div>-->
                    <!-- navigation container ends -->

                    <div class="entry cards"><!-- 1 entry starts -->
                        <i18n:text>We accept</i18n:text>
                        <div>
                            <img src="{$inc}img/american-express-curved-32px.png" alt="american express" width="51" height="32" />
                            <img src="{$inc}img/mastercard-curved-32px.png" alt="mastercard" width="51" height="32" />
                            <img src="{$inc}img/visa-curved-32px.png" alt="visa" width="51" height="32" />
                            <img src="{$inc}img/visa-electron-curved-32px.png" alt="visa electron" width="51" height="32" />
                            <img src="{$inc}img/maestro-curved-32px.png" alt="maestro" width="52" height="32" />
                            <img src="{$inc}img/cirrus-curved-32px.png" alt="cirrus" width="51" height="32" /></div>
                        <i18n:text>Maestro and Cirrus</i18n:text>
                    </div><!-- 1 entry ends -->

                    <div class="entry"><!-- 2 entry starts -->
                        <label for="card_name"><i18n:text>cardname</i18n:text><b class="required">*</b></label>
                        <input type="text" name="card_name" id="card_name" placeholder="CARDHOLDER NAME" autocorrect="off" autocomplete="off"  class="required" tabindex="1" autofocus="true" ><!--deleted required attribute and set class-->
                            <xsl:attribute name="value">
                                <xsl:value-of select="//page/payment/payer/@name"/>
                            </xsl:attribute></input>

                        <!--<script type="text/javascript">$(document).trigger('autofocus_ready');</script>--><!-- JavaScript for autofocus -->
                    </div><!-- 2 entry ends -->

                    <div class="entry"><!-- 3 entry starts -->
                        <label for="card_no_bin"><i18n:text>Card Number</i18n:text><b class="required">*</b></label>
                        <input type="number" name="card_no_bin" id="card_no_bin" placeholder="XXXXXXXXXXXXXXXX"  class="required" autocorrect="off" autocomplete="off" autocapitalize="off" tabindex="2" maxlength="16" value=""/><!--deleted required attribute and set class-->
                    </div><!-- 3 entry ends -->

                    <div class="entry expDate clearfix"><!-- 4 entry starts --><!--added classes for float boxes-->
                        <label for="exp_month"><i18n:text>Expiration Date</i18n:text><b class="required">*</b></label>
                        <div><!--added additioanl block-->
                            <select name="exp_month" id="exp_month" tabindex="3"  class="required"><!--deleted required attribute -->
                                <option value=""><i18n:text>month</i18n:text></option><!--added default empty value for validation-->
                                <option value="01">01</option>
                                <option value="02">02</option>
                                <option value="03">03</option>
                                <option value="04">04</option>
                                <option value="05">05</option>
                                <option value="06">06</option>
                                <option value="07">07</option>
                                <option value="08">08</option>
                                <option value="09">09</option>
                                <option value="10">10</option>
                                <option value="11">11</option>
                                <option value="12">12</option>
                            </select>
                        </div>

                        <div><!--added additioanl block-->
                            <select name="exp_year" id="exp_year" tabindex="4"  class="required"><!--deleted required attribute -->
                                <option value=""><i18n:text>year</i18n:text></option><!--added default empty value for validation-->

                                <option value="2013">2013</option>
                                <option value="2014">2014</option>
                                <option value="2015">2015</option>
                                <option value="2016">2016</option>
                                <option value="2017">2017</option>
                                <option value="2018">2018</option>
                                <option value="2019">2019</option>
                                <option value="2020">2020</option>
                            </select>
                        </div>
                    </div><!-- 4 entry ends -->

                    <div class="entry"><!-- 6 entry starts -->
                        <div class="col-left span2">
                            <label for="sec_cvv2">CVV/CVC2/CID<b class="required">*</b></label>
                            <input type="number" name="sec_cvv2" id="sec_cvv2" autocorrect="off" autocomplete="off" autocapitalize="off" tabindex="5" maxlength="4" value=""  class="required"/>
                            <!--changed type for NUMBER-->
                            <!--deleted required attribute and set class-->
                        </div>
                        <div class="pad-this-12y cvv-code">
                            <img src="{$inc}img/cvv-code.png" width="66" height="40" alt="cvv" />
                            <img src="{$inc}img/cid-code.png" width="66" height="40" alt="cid" />
                        </div>
                    </div><!-- 6 entry ends -->

                    <div class="entry optional"><!-- 7 entry starts -->
                        <h3><i18n:text>persinfo</i18n:text> <span class="italic"><i18n:text>(optional)</i18n:text></span></h3>
                    </div><!-- 7 entry ends -->

                    <div class="entry optional"><!-- 8 entry starts -->
                        <label for="email"><i18n:text>Your email</i18n:text></label>
                        <input name="email" id="email" maxlength="64" autocorrect="off" autocomplete="off" autocapitalize="off" tabindex="6">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//page/payment/payer/@email"/>
                            </xsl:attribute>
                        </input>
                    </div><!-- 8 entry ends -->

                    <div class="entry optional"><!-- 9 entry starts --><div class="form-float">
                        <label for="checkbox" class="checkbox">

                            <input type="checkbox" class="txtControlsbtn" name="chSendNotify" value="yes" tabindex="7" id="checkbox">
                                <xsl:if test="//page/payment/payer/@allnotify[.='yes']">
                                    <xsl:attribute name="checked">
                                    </xsl:attribute>
                                </xsl:if>
                            </input><i18n:text>sendnotify</i18n:text>

                        </label>
                    </div></div><!-- 10 entry ends -->

                    <div class="entry optional"><!-- 11 entry starts -->
                        <label for="phone"><i18n:text>cphone</i18n:text></label>
                        <input name="phone" id="phone" maxlength="64" autocorrect="off" autocomplete="off" autocapitalize="off" tabindex="8">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//page/payment/payer/@phone"/>
                            </xsl:attribute>
                        </input>
                    </div><!-- 11 entry ends -->

                    <div class="entry"><!-- 12 entry starts -->
                        <input type="submit" value="pay" class="btn submit" tabindex="9" id="submit1" name="submit1" i18n:attr="value" />
                        <input type="reset" value="clear" class="btn cancel-btn" tabindex="10" i18n:attr="value" />

                    </div><!-- 12 entry ends -->
                    <i18n:text>waitanswer</i18n:text>


                </form>

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
                                <img src="{$inc}img/kkb_logo.png" width="105" height="105" alt="kazkom" /><!--changed logo for success page-->
                                <!--<img border="0">
                                    <xsl:attribute name="src">/images/logo/<xsl:value-of select="//page/complect/shop/@img"/></xsl:attribute>
                                </img>-->
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
                                        <TD align="left"><input type="submit" value="Accept pay" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; FONT-WEIGHT: bold" id="submit1" name="submit1"  i18n:attr="value"/></TD>
                                        <!-- removing backLink (please, don't remove it completely)
                       <TD align="center"><input type="button" style="BORDER:  1px outset; FONT-FAMILY: Tahoma, Arial, sans-serif; FONT-SIZE: 9pt; " value="back" onclick='location.href="{//page/complect/shop/@backlink}"'  i18n:attr="value"/></TD>-->

                                    </TR>
                                </table>
                            </td>
                        </tr>
                    </form>
                </table>
                <br/><br/><br/><br/><br/><br/><br/><br/><br/>
            </xsl:if>

        </div><!-- form-holder ends -->
    </xsl:template>
    <xsl:template match="/">

        <html xmlns="http://www.w3.org/1999/xhtml">

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

                <meta name="creator" content="" />
                <meta name="language" content="ru" />


                <meta name="viewport" content="initial-scale=1.0,  maximum-scale=1.0, user-scalable=no, width=device-width" /><!--returned orientation maximum-scale="1.0 back--><!-- minimum-scale=1.0, maximum-scale=1.0 are added to fix landscape orientation, prevents user zoom whatsoever -->

                <meta name="HandheldFriendly" content="true" />
                <!-- <meta name="viewport" content="target-densitydpi=device-dpi" /> --><!-- to adjust font and fields size in android -->

                <title><i18n:text>Kazkommertsbank's Authorization Server</i18n:text></title>

                <link rel="stylesheet" type="text/css" href="{$inc}css/form.css" />

                <!-- JavaScript for collapsing payment details-->
                <!--[if IE]><![endif]-->
                <!--[if lt IE 9]>
                <script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
                <![endif]-->
                <script src="{$inc}js/respond.min.js" type="text/javascript"><xsl:comment> Comment </xsl:comment></script>
                <script src="http://css3-mediaqueries-js.googlecode.com/files/css3-mediaqueries.js" type="text/javascript"><xsl:comment> Comment </xsl:comment></script>

                <script type="text/javascript" src="{$inc}js/jquery.js"><xsl:comment> Comment </xsl:comment></script>
                <script src="{$inc}js/jquery.validate.js" type="text/javascript"></script><!--form validation script-->
                <script type="text/javascript">
                    $(document).ready(function () {
                        //hide the all of the element with class msg_body
                        $(".msg_body").hide();
                        //toggle the componenet with class msg_body
                        $(".msg_head").click(function () {
                            $(this).next(".msg_body").slideToggle(300);
                        });
                        //please, add this function!
                        $("#frmCardInfo").validate();
                    });
                </script>

                <!-- JavaScript for autofocus -->
                <script src="{$inc}js/modernizr-2.5.3.js" type="text/javascript"><xsl:comment> Comment </xsl:comment></script>

                <script type="text/javascript">
                    if (Modernizr.input.autofocus) {
                        // autofocus works!
                    } else {
                        // no autofocus support :(
                        // fall back to a scripted solution
                    }

                    $(document).bind('autofocus_ready', function () {
                        if (!("autofocus" in document.createElement("input"))) {
                            $("#q").focus();
                        }
                    });

                </script>

            </head>

            <body>

                <div id="container"><!-- global container starts -->
                    <div class="title-thing"><!-- title container starts -->
                        <div class="title-holder">
                            <div class="left-thing span2">
                                <img src="{$inc}img/epay_logo.png" width="103" height="33" alt="epay logo" />
                            </div>
                            <div class="right-thing"><i18n:text>Payment Gateway E-Government</i18n:text></div>
                        </div>
                    </div><!-- title container ends -->


                    <xsl:call-template name="page"/>


                    <div class="form-holder attention"><!-- form-holder starts -->


                        <div class="entry"><!-- 13 entry starts -->
                            <span class="italic"><i18n:text>You have 30 minutes and 5 attempts for payments</i18n:text></span>
                        </div><!-- 13 entry ends -->

                        <div class="entry"><!-- 14 entry starts -->

                            <span>

                                <img src="{$inc}img/kkb_logo.png" width="24" height="24" alt=""/>
                                <i18n:text>Guarantee security transactions</i18n:text>

                            </span>
                        </div><!-- 14 entry ends -->
                    </div><!-- form-holder ends -->


                </div><!-- global container ends -->

            </body>
        </html>

    </xsl:template>


</xsl:stylesheet>
