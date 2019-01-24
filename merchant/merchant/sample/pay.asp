	<%@ Language=VBScript %>
<%
  dim sum, ord
  ' сумма на оплату
  sum="0"
  'номер ордера. Сдесь надо поставить свой счетчик (внутренний учет магазина). Номер обязательно цифрами, без букв
  ord="001005"
  If Request.QueryString("sum")  <> "" Then 
	sum=Request.QueryString("sum") 
  End if
  
' создаем пакет
Set k= Server.CreateObject("KKBSign.Bean.1")
Base64Content=k.build64("C:\\mysite\\magazin\\kkbsign.cfg",sum,ord)

%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
<title>Подтверждение заказа!</title>
<body>
<h2><center>Оплата только кредитной картой</center></h2>
<h3><center>Доставка - самовывоз</h3>
<p>
<b>Итого к оплате:<b>&nbsp;&nbsp;&nbsp;<%=sum%> тенге
<%
'
'Для тестирования, форму отправить на свою страничку и посмотреть, чтоб кодированная строка передавалась
'
%>
<form name="SendOrder" method="post" action="https://3dsecure.kkb.kz/jsp/process/logon.jsp">
   <input type="hidden" name="Signed_Order_B64" value="<% =Base64Content %>">
   E-mail: <input type="text" name="email" size=50 maxlength=50><p>
   <input type="hidden" name="Language" value="rus">
   <input type="hidden" name="BackLink" value="bl.asp">
   <input type="hidden" name="PostLink" value="pl.asp">
   Со счетом согласен (-а)<br>
   <input type="submit" name="GotoPay"  value="Перейти к оплате" >&nbsp;
</form></center>
<p>

</body>
</html>
