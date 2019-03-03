using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

// ******************************************************************************************************************
// Модуль обеспечения работы функций ЭЦП сервиса https://epay.kkb.kz в среде C#
// Разработано в ТОО "SoftDeCo" специально для сервиса http://www.egfntd.kz
// ******************************************************************************************************************

namespace epay
{
    public partial class payKKB
    
    {

        //Эти параметры необходимо настроить под магазин
	    public static string KKBpfxFile = "C:\\kkb\\test_ser_all\\cert.pfx";        //Полный путь к pfx-файлу с ключами магазина (файл дает банк)
	    public static string KKBpfxPass = "nissan";								    //Пароль к pfx-файлу (дает банк)
	    public static string KKBCaFile = "C:\\kkb\\test_ser_all\\kkbca.cer";        //Полный путь к файлу с публичным ключом банка (файл дает банк)
	    public static string Cert_Id = "00C182B189";								//Номер сертификата  (дает банк)
	    public static string ShopName = "Test shop";								//Имя магазина (дает банк)
	    public static string merchant_id = "92061101";							    //номер терминала магазина, он же MerchantID  (дает банк)


        
        
	    //Эти параметры как правило не требуют изменения
        public static string currency = "398";										//Код валюты 398 - тенге, 840 - доллары 
        public static string KKBRequestStr = "<merchant cert_id=\"" + Cert_Id + "\" name=\"" + ShopName + "\"><order order_id=\"%ORDER%\" amount=\"%AMOUNT%\" currency=\"" + currency + "\"><department merchant_id=\"" + merchant_id + "\" amount=\"%AMOUNT%\"/></order></merchant>";
        
        static public byte[] ConvertStringToByteArray(string s)
        {
            // Задаем выбор кодировки
            //return new ASCIIEncoding().GetBytes(s);
            return new UTF8Encoding().GetBytes(s);
        }
        
        // Функция Build64 генерирует запрос который отправляется на https://epay.kkb.kz/jsp/process/logon.jsp
	    // В качестве входящих параметров ожидает idOrder (номер заказа в магазине) и Amount (сумма к оплате)
	    // Возвращает строку в Base64

        static public string Build64(string idOrder, double Amount) {
            
            string StrForSign = KKBRequestStr.Replace("%ORDER%", idOrder).Replace("%AMOUNT%", string.Format("{0:f}", Amount).Replace(",", "."));
            X509Certificate2 KKbCert = new X509Certificate2(KKBpfxFile, KKBpfxPass);
            RSACryptoServiceProvider rsaCSP = (RSACryptoServiceProvider)KKbCert.PrivateKey;
            byte[] SignData = rsaCSP.SignData(ConvertStringToByteArray(StrForSign), "SHA1");
            Array.Reverse(SignData);
            string ResultStr = "<document>" + StrForSign + "<merchant_sign type=\"RSA\">" + Convert.ToBase64String(SignData, Base64FormattingOptions.None) + "</merchant_sign></document>";
            return Convert.ToBase64String(ConvertStringToByteArray(ResultStr), Base64FormattingOptions.None);
        }
	
        // Функция  Verify проверяет корректность подписи, полученной от банка
	    // В качестве входящих параметров ожидает StrForVerify (строка, которую получили от банка) и Sign (ЭЦП к данной строке)
	
         static public bool Verify(string StrForVerify, string Sign) {
             X509Certificate2 KKbCert = new X509Certificate2(KKBCaFile);
             RSACryptoServiceProvider rsaCSP = (RSACryptoServiceProvider)KKbCert.PrivateKey;
             byte[] bStrForVerify = ConvertStringToByteArray(StrForVerify);
             byte[] bSign = Convert.FromBase64String(Sign);
             Array.Reverse(bSign);
             bool result;
             try
             {
                 result = rsaCSP.VerifyData(bStrForVerify, "SHA1", bSign);
             } 
             catch  
             {
                result = false;
             }
             return result;
         }

        // Функция Sign64 подписывает произвольную строку
	    // В качестве входящих параметров ожидает StrForSign (подписываемая строка)
	    // Возвращает ЭЦП кодированный в Base64

         static public string Sign64(string StrForSign) {
             X509Certificate2 KKbCert = new X509Certificate2(KKBpfxFile, KKBpfxPass);
             RSACryptoServiceProvider rsaCSP = (RSACryptoServiceProvider)KKbCert.PrivateKey;
             byte[] SignData = rsaCSP.SignData(ConvertStringToByteArray(StrForSign), "SHA1");
             Array.Reverse(SignData);
             return Convert.ToBase64String(SignData, Base64FormattingOptions.None);
        
         }


    }
}
