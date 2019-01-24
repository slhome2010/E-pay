'
'This script is for registering KKBSign.jar as ActiveX component for Windows
'Run it without cmd line parameters. It will create reg file 
'and then import it into registry
'
'Этот скрипт предназначен для регистрации KKBSign.jar 
'как ActiveX компонента для Windows.
'Запустите его без всяких параметров. 
'Он создает reg-файл и импортирует его в реестр.
'
'(C) Sgibnev Alexandr
'
'
'
'
Set WS = WScript.CreateObject( "WScript.Shell" )
jv=WS.RegRead("HKEY_LOCAL_MACHINE\Software\JavaSoft\Java Runtime Environment\CurrentVersion")
jp=WS.RegRead("HKEY_LOCAL_MACHINE\Software\JavaSoft\Java Runtime Environment\"&jv&"\JavaHome")
sp=Replace(WScript.ScriptFullName,"\"&WScript.ScriptName,"")

wscript.echo("Java Runtime found at: "&jp&vbNewLine&_
"This program installed at: "&sp)

Set fso=CreateObject("Scripting.FileSystemObject")
Set tfile=fso.openTextFile("KKBSign.re_")
ttext=tfile.ReadAll()

jp=Replace(jp,"\","\\")
sp=Replace(sp,"\","\\")
ttext=Replace(ttext,"@JRE_HOME",jp)
ttext=Replace(ttext,"@PROGRAM_HOME",sp)

Set rfile=fso.createTextFile("KKBSign.reg",true)
rfile.write(ttext)
rfile.close

'WS.Run("regedit KKBSign.reg")
