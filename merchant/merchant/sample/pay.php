<html>
<head>
<title>Pay</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
</head>
<?
$true=system("java -jar KKBSign.jar b kkbsign.cfg 10 000006> test.txt");
$filename=$_SERVER['DOCUMENT_ROOT']."/pay_process/test.txt";
$file=fopen($filename,"r");
$content=fread($file,filesize($filename));
?>
<body>
<form name="SendOrder" method="post" action="http://3dsecure.kkb.kz/jsp/process/logon.jsp">
   <input type="hidden" name="Signed_Order_B64" value="<?=$content?>">
   E-mail: <input type="text" name="email" size=50 maxlength=50  value="test@tes.kz">
   <p>
   <input type="hidden" name="Language" value="eng">
   <input type="hidden" name="BackLink" value="http://www.bl.test.kz">
   <input type="hidden" name="PostLink" value="http://www.pl.tes.kz/post_link.php">
   Со счетом согласен (-а)<br>
   <input type="submit" name="GotoPay"  value="Да, перейти к оплате" >&nbsp;
</form>
</body>
</html>
