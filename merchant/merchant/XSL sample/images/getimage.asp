<%@ Language=VBScript %>
<%Response.Expires = 0%>
<%
Set db = Server.CreateObject("ADODB.Connection")
db.Open Application("Mconn_ConnectionString")


Set CM = Server.CreateObject("Persits.CryptoManager")

Sub DrawPix()	
	Set BlobPix = CM.CreateBlob	
	BlobPix.LoadFromFile Server.MapPath("pix.gif")
	str = ""
	Response.BinaryWrite BlobPix.Binary	
	Response.End	
End Sub

Set rs = Server.CreateObject("ADODB.Recordset")
rs.ActiveConnection = db
rs.Source = "Select ShopImage1 From tShops Where ShopID = " & Request.QueryString
rs.LockType = 3
rs.Open
If NOT rs.EOF Then			
	image = rs("ShopImage1")	
	If vartype(image) = 1 Then DrawPix()					
	Response.BinaryWrite image
	image = ""
Else
	DrawPix
End if	
rs.Close
Set rs = nothing
%>