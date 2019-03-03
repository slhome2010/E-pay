	<%@ Language=VBScript %>
<% Response.Buffer = false %> 
<% Response.Expires = 0 %> 
<% If Session("Customer") = "" Then Response.Redirect(session("shopURL")) End if %> 
<!--#include virtual="/includes/service/conn.asp" --> 
<%
  Dim intCost 'Объявление переменной суммы заказа
  

  
  'Если заказ еще не был оплачен и были продолжены покупки,
  'то при повторном оформлении заказа данные о предыдущем товаре будут удалены из БД
  If Request.Form("addressid") <> "" Then 
 	IF session("OrderID") = "" Then 
	session("OrderID") = 0 
	End if
	strSQL = "DELETE FROM OrderedProducts WHERE OrderID = " & Session("OrderID")
	db.Execute strSQL
	strSQL = "DELETE FROM Orders WHERE OrderID = " & Session("OrderID")
	db.Execute strSQL	
  End if
  
'Определение типа платежа
it = Request.Form("payment")
Select Case it
Case "before"
	payment="Банковский перевод"
	direction = session("shopURL") & "/order/bank.asp"
Case "cash"
    payment="Наличные курьеру"
	direction = session("shopURL") & "/order/cash.asp"
Case "after"
	payment="Наложенный платеж"
	direction = "http://" & session("shopURL") & "/order/post.asp"
Case "card"
	payment="Кредитная карта"
	direction = "https://www.kkb.kz/payment/payment.asp"
End select 
    
'Определение типа доставки и его стоимости

set rsss = server.CreateObject("Adodb.Recordset")
SQL = "Select * from Delivery where DeliveryID = '" & Request.Form("shipservice") & "'"
rsss.Open SQL, db
shipserv = rsss("DeliveryName")
rsss.Close
set rsss = nothing

'Запись информации о заказе в БД
  Session("OrderTime") = Now
  strSQL = "INSERT INTO Orders (OrderDate, CustomerID, AdressID, Status, ShippingType, PaymentType, OrderComment, ShopID)"', USD) "
  strSQL = strSQL & "VALUES ('" & Session("OrderTime") & "', " & Cdbl(Session("Customer")) & ", "
  strSQL = strSQL & Cdbl(Request.Form("addressid")) & ", 'Заказ в стадии формирования', '" & shipserv & "', '" & payment & "', '" & Request.Form("OrderComments") & "', " & session("shopID") & ")"
  db.Execute strSQL  
  
'Определение номера заказа
  Set rs = Server.CreateObject("ADODB.Recordset")
  strSQL = "SELECT OrderID FROM dbo.Orders WHERE (OrderDate = '" & Session("OrderTime") & "' AND CustomerID =" & CLng(Session("Customer")) 
  strSQL = strSQL & " AND ShopID = " & session("shopID") & ")"
  rs.Open strSQL, db
 	If rs.EOF Then 
 	' alert выводит сообщение  в случае ошибки системы при определении номера заказа
	%>
<SCRIPT LANGUAGE=javascript>
<!--
alert("Произошел сбой в ситеме. Проблема: отсутствует номер заказа.Пожалуйста свяжитесь с администратором магазина(e-mail ars@kkb.kz)");
//-->
</SCRIPT>
	<%
	Else
		session("OrderID") = Clng(rs("OrderID"))
	End if
	rs.Close
	Set rs = nothing 

  session("Payment") = "no"

 'Вывод данных из таблицы временных заказов и запись в таблицу "Заказанные товары"
  Set rs = Server.CreateObject("ADODB.Recordset")
  strSQL = "SELECT [Temp].TempProductID, [Temp].TempProductQuantity, [4search].CategoryName, [4search].ProductBrandName, [4search].ProductName, [4search].Price, [4search].ProductPIN, [4search].ProductWeight, [Temp].ShopID "
  strSQL = strSQL & "FROM [4search] RIGHT OUTER JOIN [Temp] ON [4search].ShopID = [Temp].ShopID AND [4search].ProductID = [Temp].TempProductID "
  strSQL = strSQL & "WHERE ([Temp].TempSessionID = '" & Session.SessionID & "' AND [Temp].ShopID = " & session("shopID") & ")"
  rs.Open strSQL, db
  Do While Not rs.EOF    
  
  Set rbs = Server.CreateObject("ADODB.Recordset")
	rbs.ActiveConnection = db
	rbs.CursorType = 2 ' DynamicCursor
	rbs.LockType = 3 ' LockOptimistic
	rbs.Source = "OrderedProducts"
  rbs.Open
  rbs.AddNew
	rbs("OrderID") = session("OrderID")
	rbs("ProductPIN") = rs("ProductPIN")
	rbs("ProductName") = "&quot;" & rs("ProductName") & "&quot; - " & rs("ProductBrandName")
	rbs("ProductPrice") = rs("Price")
	rbs("ProductWeight") = rs("ProductWeight")
	rbs("BaseProductID") = rs("TempProductID")
	rbs("ShopID") = session("shopID")
	rbs("ProductQuantity") = rs("TempProductQuantity")
  rbs.Update  
  rbs.Close
  Set rbs = nothing
  '!!!!!!!!!!!!!!!!!!Подсчет стоимости заказа, без учета стоимости доставки и скидок!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  intCost = intCost + CCur(Clng(rs("TempProductQuantity"))*CCur(rs("Price")))
  intShippingWeight = intShippingWeight + Cdbl(rs("ProductWeight"))*Cdbl(rs("TempProductQuantity"))
  
  '!!!!!!!!!!!!!!!!!!***************************************************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  rs.MoveNext
  Loop
  rs.Close
  Set rs = nothing 
  ' Debug 
  If intCost = "" Then intCost = 0 End if
'!!!!!!!!!!!!!!!!!!Подсчет стоимости заказа, без учета стоимости доставки и скидок!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
set rsss = server.CreateObject("Adodb.Recordset")
SQL = "Select * from Delivery where DeliveryID = '" & Request.Form("shipservice") & "'"
rsss.Open SQL, db
shipserv = rsss("DeliveryName")
rsss.Close
a = Request.Form("shipservice")
intShippingCost = Request.Form("deliveryprice"&a)

							
							TotalAmount = intShippingCost + intCost' + 1.2
							TotalAmountKZ = CCur(TotalAmount * CCur(session("USCourse")))
							  
'!!!!!!!!!!!!!!!!!!***************************************************************!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

strSQL = "UPDATE dbo.Orders SET OrderCost = " & ASP2DB(TotalAmount) & " WHERE OrderID = " & session("OrderID")
db.Execute strSQL

strSQL = "UPDATE dbo.[Temp] SET OrderID = " & session("OrderID") & " WHERE TempSessionID = " & Session.SessionID
db.Execute strSQL
       	




'Генерация XML и его подпись.
Set CM = Server.CreateObject("Persits.CryptoManager.1")
CM.LogonUser "", "CertReader", "card21"

Set Store = CM.OpenStore("MY", True)
Set Cert = Store.Certificates("00C182A199")

Set Context = Cert.PrivateKeyContext
Set Hash = Context.CreateHash

Set order = Server.CreateObject( "Microsoft.XMLDOM" )

Set depElem = order.createElement( "department" )
depElem.setAttribute "merchant_id", session("shopID")
depElem.setAttribute "amount", TotalAmount

Set orderElem = order.createElement( "order" )
orderElem.setAttribute "order_id", session("OrderID")
orderElem.setAttribute "amount", TotalAmount
orderElem.setAttribute "currency", 398
orderElem.appendChild depElem


Set merchantElem = order.createElement( "merchant" )
merchantElem.setAttribute "cert_id", Cert.SerialNumber
merchantElem.setAttribute "name", session("shopName")
merchantElem.appendChild orderElem



Hash.AddText merchantElem.xml
Set Blob = Hash.Sign( True )

Set merchant_signElem = order.createElement( "merchant_sign" )
merchant_signElem.setAttribute "type", "RSA"
merchant_signElem.text = Blob.Base64

Set docElem = order.createElement( "document" )
docElem.appendChild merchantElem
docElem.appendChild merchant_signElem

Blob.Binary = docElem.xml
Base64Content = Blob.Base64
%> 
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<title>Подтверждение заказа на <%=session("shopURL")%></title>
<!--#include virtual="/includes/service/browserdetect.asp" --> 
</HEAD>
<body bgcolor="#006331">
<!--#include virtual="/includes/headerDin.inc" -->
<!--=================================main======================================-->    
      <TABLE bgColor=#91d3bb border=0 cellPadding=5 cellSpacing=0 width="100%">
  <TR height=15>
    <TD bgColor=#91D3BB vAlign=top width=180>
    <!--#include virtual="/includes/catalogDin1.asp" -->
    <!--#include virtual="/includes/tocustomer.asp" -->
    <!--#include virtual="/includes/help.asp" -->
    <!--#include virtual="/includes/advert.asp" -->
    </td>
    <TD vAlign=top width="597" bgcolor="#CEE7DE">
     <table border="0" cellpadding="3" cellspacing="0" width="100%">
        <tr align="center"> 
          <td class="main"><img border="0" src="/images/1x1r.gif" width="10" height="10"> 
             Подтверждение заказа № <%=session("OrderID")%> <img border="0" src="/images/1x1r.gif" width="10" height="10"></td>
        </tr>
        <tr><td>
  
      <table width="100%" border="0" cellspacing="1" cellpadding="0" class="text1">
        <tr>
		 <td colspan="2">
		 
                  <table width="100%" border="0" cellspacing="0" cellpadding="2" class="text1">
                
                    <tr> 
                      <td width="5%" class="text1"><u>№</u></td>
                      <td width="55%" class="text1"><u>Наименование</u></td>
                      <td width="15%" class="text1"><u>Цена</u></td>
                      <td width="10%" class="text1"><u>Кол-во</u></td>
                      <td width="15%" class="text1"><u>Стоимость</u></td>
                    </tr>
<%
set rs = Server.CreateObject("ADODB.Recordset")
strSQL = "SELECT ProductName, ProductQuantity, ProductPrice FROM OrderedProducts WHERE (OrderID = " & session("OrderID") & " AND ShopID = " & session("shopID") & ")"
rs.Open strSQL, db

Dim num
Dim Sum
Num = 1


'txtOrderForAuth = "<table width=100% border=0>"
'txtOrderForAuth = txtOrderForAuth & "<tr><td colspan=4 align=right><hr size=1></td></tr>"
'txtOrderForAuth = txtOrderForAuth & "<tr><td><b>Наименование</b></td><td align=right><b>Кол-во</b></td><td align=right><b>Цена</b></td><td align=right><b>Стоимость</b></td></tr><tr>"

Do While Not rs.EOF
Sum = CCur(Ccur(rs.Fields.Item("ProductPrice").Value) * Clng(rs.Fields.Item("ProductQuantity").Value))
%> 
                    <tr> 
                      <td class="text1"><%=num%></td>
                      <td class="text1"><%=(rs.Fields.Item("ProductName").Value)%></td>
                      <td class="text1"><%=(rs.Fields.Item("ProductPrice").Value)%>&nbsp;<%=session("currency")%> </td>
                      <td align="center"  class="text1"><%=(rs.Fields.Item("ProductQuantity").Value)%></td>
                      <td  class="text1"><%=Sum%>&nbsp;<%=session("currency")%></td>
                    </tr>                                    
<%
'txtOrderForAuth = txtOrderForAuth & "<tr><td>" & rs.Fields.Item("ProductName").Value & "</td><td align=right valign=top>" & rs.Fields.Item("ProductQuantity").Value & "</td><td align=right valign=top>" & (rs.Fields.Item("ProductPrice").Value) & " " & session("currency") & "</td><td align=right valign=top>" & Sum & " " & session("currency") & "</td></tr>"
num = num + 1
rs.MoveNext
loop
rs.Close
set rs = nothing
'txtOrderForAuth = txtOrderForAuth & "<tr><td colspan=4 align=right><hr size=1></td></tr>"
'txtOrderForAuth = txtOrderForAuth & "<tr><td colspan=3 align=right><b>Доставка:</b></td><td align=right><b>" & intShippingCost & " " & session("currency") & "</b></td></tr>"
'txtOrderForAuth = txtOrderForAuth & "<tr><td colspan=3 align=right><b>Итого:</b></td><td align=right><b>" & TotalAmount & " " & session("currency") & "</b></td></tr>"
'txtOrderForAuth = txtOrderForAuth & "<tr><td colspan=3 align=right><b>Итого к оплате(в тенге):</b></td><td align=right><b>" & TotalAmountKZ & " KZT </b></td></tr>"
'txtOrderForAuth = txtOrderForAuth & "</table>"
%>
                    
                    <tr> 
                      <td colspan="5" align="right" class="text1">
                      <hr size="1" class="dark">
                      Сумма заказа: <b><%=intCost%> </b><%=session("currency")%></td>
                    </tr>
                    <tr> 
                      <td colspan="5" align="right"  class="text1">Стоимость доставки:&nbsp;&nbsp;&nbsp;<%=intShippingCost%>&nbsp; <%=session("currency")%></td>
                    </tr>
                    <tr> 
                      <td colspan="5" align="right"  class="text1">Итого к оплате: <b><%=(TotalAmount)%> </b><%=session("currency")%>
                      <hr size="1" class="dark">
                      </td>
                    </tr>
<%If session("currency") = "USD" Then%>                      
                      <tr> 
                        <td colspan="5" align="right"  class="text1">Итого к оплате(в тенге): <b><%=CCur(CCur(TotalAmount)*CCur(session("USCourse")))%>&nbsp;KZT</b></td>
                      </tr>
<%End if%>	                     
                    

                  </table>     
                  
			  </td>                               
			</tr>
            <tr> 
              <td colspan="2" class="text1" ><b>Параметры заказа:</b></td>        
            </tr>			
			<tr>
			  <td colspan="2">

		         <table border="0" width="100%" cellpadding="3" cellspacing="0" class="text1">            
	              <tr> 
	                <td width="35%" valign="top"  class="text1">1.Адрес доставки:</td>
		            <td width="65%%"  class="text1"> <%
set rs = Server.CreateObject("ADODB.Recordset")
strSQL = "SELECT CustomerAddresses.CustomerZIP, CustomerAddressee, CustomerAddresses.CustomerRegion, CustomerAddresses.CustomerCity, CustomerAddresses.CustomerStreet, CustomerAddresses.CustomerHouseNumber, CustomerAddresses.CustomerAppNumber, CustomerAddresses.CustomerAddressComments, Customers.CustomerEmail "
strSQL = strSQL & "FROM CustomerAddresses, Customers WHERE (AddressID=" & Clng(Request.Form("addressid"))
strSQL = strSQL & " AND Customers.CustomerID = CustomerAddresses.CustomerID"
strSQL = strSQL & " AND CustomerAddresses.ShopID = " & session("shopID")
strSQL = strSQL & " AND Customers.ShopID = " & session("shopID") & ")"
rs.Open strSQL, db
mailaddress = rs("CustomerEmail")
%> 
						  		
                          <% If rs("CustomerZIP") <> "" Then %>
                          <%=rs("CustomerZIP")%>&nbsp;
                          <%
                          End If
                          If rs("CustomerRegion") <> "" Then 
                          %>
                          <%=rs("CustomerRegion")%>&nbsp;
                          <%
                          End If
                          %>
                          г.<%=rs("CustomerCity")%>                          
                          &nbsp;ул.<%=rs("CustomerStreet")%>
                          &nbsp;д.<%=rs("CustomerHouseNumber")%>
                          <%' проверяет наличие номера квартиры
                          If rs("CustomerAppNumber") <> "" Then %> 
                          &nbsp;кв. <%=rs("CustomerAppNumber")%>
                          <%End if%><br>
                          Получатель: &nbsp;<%=rs("CustomerAddressee")%><br>
                          <%' проверяет наличие номера квартиры
                          If rs("CustomerAddressComments") <> "" Then %> 
                          Комментарий к адресу:<br><%=rs("CustomerAddressComments")%>
                          <%End if

rs.Close
Set rs = nothing
%></td>

              </tr>
              <tr> 
                <td  class="text1">2. Способ оплаты:</td>
                <td  class="text1"><%Response.Write(payment)%></td>        
              </tr>
              <tr> 
                <td  class="text1">3. Способ доставки:</td>
                <td  class="text1"><%=shipserv%></td>
              </tr>
              <tr> 
                <td valign="top"  class="text1">4. Комментарий к заказу:</td>
                <td valign="top" class="text1">
                <%If Request.Form("OrderComments")<> "" Then %>
                <%=Request.Form("OrderComments")%>
                <% Else
                Response.Write("отсутствует")
                End if
                %>
                <br>                <br>
                
				</td>
              </tr>              
               </table>
	              </td>
			  </tr>
              <tr><form id=form1 name=form1>                 
                  <td>&nbsp;
                    <input type="button" name="BackChange" value="Изменить"   class="text1" onClick="window.location.href='formorder.asp?back'">                  
                  </td></form>                  
<%if Request.Form("payment") = "cash" then%>
		<!-- ---------------------------- -->
				<form name="SendOrder" method="post" action="/order/cash.asp">                  
				<%else%>
                 <form name="SendOrder" method="post" action="https://3dsecure.kkb.kz/jsp/process/logon.asp">
                 <% end if %>
                  <td align="right">                    
                    <input type="hidden" name="Signed_Order_B64" value="<% =Base64Content %>">
                    <input type="hidden" name="email" value="<%=mailaddress%>">
                    <input type="hidden" name="htmOrder" value="<%=txtOrderForAuth%>">                                        
                    <input type="hidden" name="BackLink" value="<%=session("shopURL")%>/order/end.asp">
                    <input type="hidden" name="PostLink" value="<%=session("shopURL")%>/order/robot.asp">
					Со счетом согласен (-а)
                    <input type="submit" name="GotoPay" <%if Request.Form("payment") = "cash" then%> value="Подтвердить подачу заказа" <%else%> value="Перейти к оплате" <%end if%>  class="text1">&nbsp;
                    
                  </td>
                </form>
              </tr>        
      </table>
  
 </td>
                      </tr>
					                       
                    </table>
      </td>
    <TD bgColor=#91D3BB vAlign=top width=180>
    <!--#include virtual="/includes/new5.asp" -->
    <!--#include virtual="/includes/news.asp" -->
    <!--#include virtual="/includes/stat.asp" -->
    </td>
  </tr>
	 </table>
 			    
            
<!--=================================main======================================-->          
<!--#include virtual="/includes/footer.inc" -->
</body>
</html>
