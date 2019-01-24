function frmCardInfo_onsubmit() {
	// Checking card_no
    lang=document.frmCardInfo.Language.value;
    var reg = /^[a-zA-Z\.\- ]+$/;
    var reg1 = /^[0-9 ]+$/;
    var reg2 = /^[\s\w\.-]*@[\s\w\.-]*$/;
    var reg3 = /^[+]*[0-9()\- ]*$/;
    var cardReg = /\d{15,16}/;

    card_no = document.frmCardInfo.card_no_bin.value;
    card_no1 = document.frmCardInfo.card_no_group1.value;
    card_no2 = document.frmCardInfo.card_no_group2.value;
    card_no3 = document.frmCardInfo.card_no_group3.value;

    if ((card_no.length < 4) || (!card_no.match(reg1)) || (card_no1.length < 4) || (!card_no1.match(reg1)) ||
        (card_no2.length < 4) || (!card_no2.match(reg1)) || (card_no3.length < 3) || (!card_no3.match(reg1)))
    {
        if (lang.indexOf("ru")==0){
            alert( "Заполните корректно номер карты!" );
        }else{
            if (lang.indexOf("kz")==0){
                alert( "Картаның нөмірін енгізіңіз!" );
            }else{
                alert( "Fill in Card field correctly! " );
            }
        }

        document.frmCardInfo.submit1.disabled=false;
        return false;
    };



    if ((document.frmCardInfo.card_name.value.length < 3) || (!document.frmCardInfo.card_name.value.match(reg)) || (document.frmCardInfo.card_name.value.match(cardReg))){
        if (lang.indexOf("ru")==0){
            alert( "Заполните поле Владелец карты, английскими буквами, без специальных символов!" );
        }else{
            if (lang.indexOf("kz")==0){
                alert( "Картаны ұстаушының дұрыс атын көрсетіңіз!" );
            }else{
                alert( "Fill in Cardholder name in English without special simbols!" );
            }
        }
        document.frmCardInfo.submit1.disabled=false;
        return false;
	};
    if ((  (document.frmCardInfo.sec_cvv2.value.length < 3) && (card_no.indexOf("6")!=0 )  ) ){
        if (lang.indexOf("ru")==0){
            alert( "Ошибка в CVV2/CVC2!" );
        }else{
            if (lang.indexOf("kz")==0){
                alert( "Кателік CVV2/CVC2!" );
            }else{
                alert( "Error of CVV2/CVC2!" );
            }
        }
        document.frmCardInfo.submit1.disabled=false;
        return false;
    };
    if (((!document.frmCardInfo.email.value.match(reg2))&& (document.frmCardInfo.email.value.length>0))  || (document.frmCardInfo.email.value.match(cardReg))){

        if (lang.indexOf("ru")==0){
            alert( "Ошибка в email!" );
        }else{
            if (lang.indexOf("kz")==0){
                alert( "Кателік email!" );
            }else{
                alert( "Error of email!" );
            }
        }
        document.frmCardInfo.submit1.disabled=false;
        return false;
    };

    if (((!document.frmCardInfo.phone.value.match(reg3)) && (document.frmCardInfo.phone.value.length>0))  || (document.frmCardInfo.phone.value.match(cardReg))){

        if (lang.indexOf("ru")==0){
            alert( "Ошибка в телефоне!" );
        }else{
            if (lang.indexOf("kz")==0){
                alert( "Кателік телефон!" );
            }else{
                alert( "Error of phone!" );
            }
        }
        document.frmCardInfo.submit1.disabled=false;
        return false;
    };

    document.frmCardInfo.submit1.disabled = true ;
    setTimeout(divv, 2000);
    return true;
}

function divv(){
    document.getElementById("box").style.display='block';
    document.getElementById("main").style.display='none';
}

function addflt()
{
    document.getElementById('fltX').innerHTML="XXXXXXXXXXXXXXX";
    return true; // чтобы не происходил переход по ссылке
}
function rmflt(q)
{
    document.getElementById('fltX').innerHTML="XXXXXXXXXXXXXX";
 

    return true;
}
