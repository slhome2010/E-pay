
/* variables for show help tips/images */
var chname = document.getElementById("chname").style.display;
var cnum = document.getElementById("cnum").style.display;
var cexpiry = document.getElementById("cexpiry").style.display;
var ccvv = document.getElementById("ccvv").style.display;
/* *********************** */
var cemail = document.getElementById("email").style.display;


var lang = document.getElementById("Language").value;


/* show/hide help pictures */
function ShowTips(inId){

    inId == "card_name" ? chname = "inline" : chname = "none";
    (inId == "exp_month" || inId == "exp_year") ? cexpiry = "inline" : cexpiry = "none";
    inId == "sec_cvv2" ? ccvv = "inline" : ccvv = "none";

    if (inId == "card_no_bin" || inId == "card_no_group1" || inId == "card_no_group2" || inId == "card_no_group3")
    {
        cnum = "inline";
    }
    else { cnum = "none"; }

    document.getElementById("chname").style.display = chname;
    document.getElementById("cnum").style.display = cnum;
    document.getElementById("cexpiry").style.display = cexpiry;
    document.getElementById("ccvv").style.display = ccvv;

}



/* for auto moving pointer to the next text field during typing card number */
function nextField(contr, next_contr, ev){

    var defLen=4;

    if (ev.keyCode != 9)
    {
        if (contr.value.length < defLen) return;
        else document.getElementById(next_contr).focus();
    }

}


/* for show/hide card number and setting language of show/hide card number link*/
function changeShowBtnText (){

    var current = document.getElementById("card_no_group1").type;

    var ttext;

    var showrus = "показать номер";
    var showkaz = "нөмірді көрсету";
    var showen = "show number";

    var hiderus = "скрыть номер";
    var hidekaz = "нөмірді жасыру";
    var hideen = "hide number";

    if (current == "text") {

        document.getElementById("card_no_group1").type = "password";
        document.getElementById("card_no_group2").type = "password";

        switch (lang)
        {
            case "ru": ttext = showrus;
                break;
            case "kz": ttext = showkaz;
                break;
            default : ttext = showen;
        }
    }
    else {

        document.getElementById("card_no_group1").type = "text";
        document.getElementById("card_no_group2").type = "text";

        switch (lang)
        {
            case "ru": ttext = hiderus;
                break;
            case "kz": ttext = hidekaz;
                break;
            default : ttext = hideen;
        }
    }

    document.getElementById('forPWD').innerHTML = ttext;

}

//function TriesLang(){
//
//    var ttext = "There are 20 minutes or 3 attempts for the payment.";
//
//    switch (lang)
//    {
//        case "ru": ttext = "На проведение платежа выделяется <b>20 минут</b> или <b>3 попытки</b>.";
//            break;
//        case "kz": ttext = "Төлемге өткізуге <b>20 минуттардың</b> немесе <b>3 талпынысты</b> адырайып жатыр.";
//            break;
//        default : ttext = "There are <b>20 minutes</b> or <b>3 attempts</b> for the payment.";
//    }
//
//    document.getElementById('triesInfo').innerHTML = ttext;
//
//}


