  <%@page
  contentType="text/html; charset=utf-8"
  import=" java.io.*, java.security.*,
           comp.*,
           comp.KKBSign,
           comp.Base64,
           "
 %>
<html>

<head><title>JSP demo</title></head>

<body>
Пример:<br>
Купить?

  <%


String ord="500025";
String sum="1";
   KKBSign test=new KKBSign();
   String Base64Content=test.build64("c:\\host\\epayn.kkb.kz\\WEB-INF\\include\\klient\\kkbsign.cfg",sum, ord);

String ticket="<document><item number=\"1\" name=\"Телефонный аппарат\" quantity=\"2\" amount=\"1000\"/>" +
"<item number=\"2\" name=\"Шнур 2м.\" quantity=\"2\" amount=\"200\"/>" +
"</document>";

  String send = new String( comp.Base64.encode((  ticket ).getBytes()));


  %>
  <br>Номер счета: <%=ord%><br>
  <br>Сумма: <%=sum%><br>
 Base64Content<%=Base64Content%>  <p>


<form name="SendOrder" method="post" action="http://3dsecure.kkb.kz/jsp/process/logon.jsp">
   <input type="hidden" name="Signed_Order_B64" value="<%=Base64Content%>"><br>
   E-mail: <input type="text" name="email" size=50 maxlength=50  value="SeFrolov@kkb.kz"><br>
   <input type="hidden" name="Language" value="eng"><br>
   <input type="hidden" name="BackLink" value="http://3dsecure.kkb.kz/jsp/klient/pay.jsp"><br>
   <input type="hidden" name="PostLink" value="http://3dsecure.kkb.kz/jsp/klient/pl.jsp"><br>
   <input type="hidden" name="FailureBackLink" value="3dsecure://epay.kkb.kz/jsp/klient/pay.jsp"><br>
   <input type="hidden" name="appendix" size=50 maxlength=50 value="<%=send%>"/><br>

   Со счетом согласен (-а)<br>
   <input type="submit" name="GotoPay"  value="Да, перейти к оплате" >&nbsp;
</form></center>
<p>


</body>

</html>

