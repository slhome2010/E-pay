$(document).ready(function() {
    $('#code_slide').click(function(){$('#code_slide_text').slideToggle('slow',function(){});});
    $('#kkb_slide').click(function(){$('#kkb_slide_text').slideToggle('slow',function(){});});
    $('#hsbk_slide').click(function(){$('#hsbk_slide_text').slideToggle('slow',function(){});});
});

function frmSmt(){
    //

    $('#submit1').css('display', 'none');
    $('#smtLoader').css('display', 'block');

};