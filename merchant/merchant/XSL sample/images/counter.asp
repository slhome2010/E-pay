<%@ Language=JavaScript%>
<%

Response.ContentType = "image/x-png";
var img = Server.CreateObject( "ASPImage.Image" );

imgTemplateFile = Server.MapPath( '/images/card3.png' );
img.LoadImage( imgTemplateFile );
img.ImageFormat = 3;
img.FontName = "Arial";
img.FontSize = 7;

//try{		hbcounter2
iToday = Application("iTotal");
iTotal = Application("iMes");
//iTotal = Application("iUsd");






//	iTotal = 10;
//	iToday =500;

	sTotal = iTotal.toString();
	iTotalLen = img.TextWidth( sTotal );
	img.TextOut( sTotal, 125 - 8 - iTotalLen, 32, false );
	 
	sToday = iToday.toString();
	iTodayLen = img.TextWidth( sToday );
	img.TextOut( sToday, 125 - 8 - iTodayLen, 20, false );
	 

	Response.Clear(); 
	Response.BinaryWrite( img.Image );
	// Response.Write( img.Expires );
//}catch(e){}	
%>