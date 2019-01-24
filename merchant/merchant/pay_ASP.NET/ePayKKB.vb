Option Compare Text
Option Explicit On
Option Strict On
Imports System.Text
Imports System.Security.Cryptography
Imports System.Security.Cryptography.X509Certificates

' *************************************************************************
'Модуль обеспечения работы функций ЭЦП сервиса https://epay.kkb.kz в среде .NET Framework 2.0 и выше
'Разработано в ТОО "Таулинк" специально для сервиса http://www.oplata.kz
' *************************************************************************

Module ePayKKB
	'Эти параметры необходимо настроить под магазин
	Const KKBpfxFile As String = "C:\kkb\test_ser_all\cert.pfx"	'Полный путь к pfx-файлу с ключами магазина (файл дает банк)
	Const KKBpfxPass As String = "password"											'Пароль к pfx-файлу (дает банк)
	Const KKBCaFile As String = "C:\kkb\test_ser_all\kkbca.cer"	'Полный путь к файлу с публичным ключом банка (файл дает банк)
	Const Cert_Id As String = "00C182B189"											'Номер сертификата  (дает банк)
	Const ShopName As String = "Test shop"											'Имя магазина (дает банк)
	Const merchant_id As String = "92061101"										'номер терминала магазина, он же MerchantID  (дает банк)

	'Эти параметры как правило не требуют изменения
	Const currency As String = "398"														'Код валюты 398 - тенге
	Const KKBRequestStr As String = "<merchant cert_id=""" + Cert_Id + """ name=""" + ShopName + """><order order_id=""%ORDER%"" amount=""%AMOUNT%"" currency=""" + currency + """><department merchant_id=""" + merchant_id + """ amount=""%AMOUNT%""/></order></merchant>"


	Private Function ConvertStringToByteArray(ByVal s As [String]) As [Byte]()
		Return (New ASCIIEncoding).GetBytes(s)
	End Function

	'Функция Build64 генерирует запрос который отправляется на https://epay.kkb.kz/jsp/process/logon.jsp
	'В качестве входящих параметров ожидает idOrder (номер заказа в магазине) и Amount (сумма к оплате)
	'Возвращает строку в Base64
	Function Build64(ByVal idOrder As String, ByVal Amount As Double) As String
		Dim StrForSign As String = KKBRequestStr.Replace("%ORDER%", idOrder).Replace("%AMOUNT%", Format(Amount, "0.00").Replace(",", "."))
		Dim KKbCert As X509Certificate2 = New X509Certificate2(KKBpfxFile, KKBpfxPass)
		Dim rsaCSP As RSACryptoServiceProvider = CType(KKbCert.PrivateKey, RSACryptoServiceProvider)
		Dim SignData As Byte() = rsaCSP.SignData(ConvertStringToByteArray(StrForSign), "SHA1")
		Array.Reverse(SignData)
		Dim ResultStr As String = "<document>" + StrForSign + "<merchant_sign type=""RSA"">" + Convert.ToBase64String(SignData, Base64FormattingOptions.None) + "</merchant_sign></document>"
		Return Convert.ToBase64String(ConvertStringToByteArray(ResultStr), Base64FormattingOptions.None)
	End Function

	'Функция  Verify проверяет корректность подписи, полученной от банка
	'В качестве входящих параметров ожидает StrForVerify (строка, которую получили от банка) и Sign (ЭЦП к данной строке)
	Function Verify(ByVal StrForVerify As String, ByVal Sign As String) As Boolean
		Dim KKbCert As X509Certificate2 = New X509Certificate2(KKBCaFile)
		Dim rsaCSP As RSACryptoServiceProvider = CType(KKbCert.PublicKey.Key, RSACryptoServiceProvider)
		Dim bStrForVerify As Byte() = ConvertStringToByteArray(StrForVerify)
		Dim bSign As Byte() = Convert.FromBase64String(Sign)
		Array.Reverse(bSign)
		Dim Result As Boolean
		Try
			Result = rsaCSP.VerifyData(bStrForVerify, "SHA1", bSign)
		Catch ex As Exception
			Result = False
		End Try
		Return Result
	End Function

	'Функция Build64 подписывает произвольную строку
	'В качестве входящих параметров ожидает StrForSign (подписываемая строка)
	'Возвращает ЭЦП кодированный в Base64
	Function Sign64(ByVal StrForSign As String) As String
		Dim KKbCert As X509Certificate2 = New X509Certificate2(KKBpfxFile, KKBpfxPass)
		Dim rsaCSP As RSACryptoServiceProvider = CType(KKbCert.PrivateKey, RSACryptoServiceProvider)
		Dim SignData As Byte() = rsaCSP.SignData(ConvertStringToByteArray(StrForSign), "SHA1")
		Array.Reverse(SignData)
		Return Convert.ToBase64String(SignData, Base64FormattingOptions.None)
	End Function

End Module
