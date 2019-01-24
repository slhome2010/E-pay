<%@ page
 import="java.sql.DriverManager,
                 java.sql.Connection,
                 java.sql.Statement,
                 java.sql.ResultSet,
                 java.util.GregorianCalendar,
                 java.util.TimeZone,
                 java.util.Calendar,
                 components.fsb,
                 org.dom4j.Document,
                 org.dom4j.DocumentHelper,
                 org.dom4j.Element,
         java.net.URLDecoder,
         comp.KKBSign"
%>
<%@ include file="../include/inc.jsp"%>
 <%
try{
    GregorianCalendar date=new GregorianCalendar();
            date.setTimeZone(TimeZone.getTimeZone("GMT+6"));
            String tActionTime=date.get(Calendar.YEAR)+"-"+
                    fsb.insSim(2,"0",((date.get(Calendar.MONTH)+1)+""))+"-"+
                    fsb.insSim(2,"0",(date.get(Calendar.DAY_OF_MONTH)+""))+" "+
                    fsb.insSim(2,"0",(date.get(Calendar.HOUR_OF_DAY)+""))+":"+
                    fsb.insSim(2,"0",(date.get(Calendar.MINUTE)+""))+":"+
                    fsb.insSim(2,"0",(date.get(Calendar.SECOND)+""));


    Class.forName("oracle.jdbc.driver.OracleDriver");
    DriverManager.setLogStream(System.out);
    Connection con = DriverManager.getConnection (session.getValue("webbase").toString(), session.getValue("user").toString(), session.getValue("pass").toString());
    Statement stmt = con.createStatement();
    ResultSet rs;
    Statement stmtS = con.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE );

    //Вот что ВАЖНО !!!!!!!!!!! //Вот что ВАЖНО !!!!!!!!!!! //Вот что ВАЖНО !!!!!!!!!!!
    request.setCharacterEncoding("Cp1251"); //Вот что ВАЖНО !!!!!!!!!!!
     //Вот что ВАЖНО !!!!!!!!!!! //Вот что ВАЖНО !!!!!!!!!!! //Вот что ВАЖНО !!!!!!!!!!!


    String logs=request.getParameter("response");
    logs=URLDecoder.decode(logs);
             //снова в ХМЛ
    Document confXml=DocumentHelper.parseText(logs);
    Element eBank=(Element)confXml.getRootElement().selectSingleNode("//bank");
    Element order= (Element)eBank.selectSingleNode("//order");
    String orderID=order.attributeValue("order_id");
    String reference =   ((Element)confXml.getRootElement().selectSingleNode("//payment")).attributeValue("reference");
    String merchant_id =   ((Element)confXml.getRootElement().selectSingleNode("//payment")).attributeValue("merchant_id");
    String  sSQL="";
    KKBSign ksig=new KKBSign();
    String textXml= eBank.asXML();
    String textSign =  ((Element)confXml.getRootElement().selectSingleNode("//bank_sign")).getText();
    String ks= "C:\\host\\epayn.kkb.kz\\WEB-INF\\include\\klient\\ski.jks" ;
    textSign=textSign.replaceAll(" ", "+");

    String res=ksig.verify(textXml,textSign, ks,  "kkbca", "km778vx") +"";
    if(res.indexOf("true")==0){
        out.print("0");      //0
        sSQL= "INSERT INTO demo_tKlientLogs ( MerchantID, Name, LogDate, SessionID, Status) VALUES ('"+ merchant_id +"','"+  reference  +"', to_date('" + tActionTime + "','yyyy-mm-dd hh24:mi:ss'), '"+session.getId()+"', '"+orderID+" -order good' )";
    }else{

        out.print("1");
     //    out.print("<hr>1: ="+ textXml +"=<hr>");
        sSQL= "INSERT INTO demo_tKlientLogs ( MerchantID, Name, LogDate, SessionID, Status) VALUES ('"+ merchant_id +"','"+  reference  +"', to_date('" + tActionTime + "','yyyy-mm-dd hh24:mi:ss'), '"+session.getId()+"', 'err.sert order"+orderID+"' )";
    }

   stmt.executeQuery(sSQL);


    try{

         if (comp.sesClob.updClob("tKlientLogs","LogAction", session.getId()+"",logs+"" )){
              //out.print("<br>TRUE "+ "<p>");
         }else{
             out.print("<br>error_pl_0 "+ "<p>");
         }

    }catch(Exception e) {
         out.print("<br>error_pl_1: "+ e + "<p>");
    }
         /*   */
 }catch(Exception e) {
      out.print("<br>error_pl_2: "+ e + "<p>");
 }
%>