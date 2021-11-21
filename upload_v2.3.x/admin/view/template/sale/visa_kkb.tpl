<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right"><a data-toggle="tooltip" title="<?php echo $button_refresh; ?>" class="btn btn-primary"><i onclick="window.location.reload(true);" class="fa fa-refresh"></i></a></div>
            <h1><img height="32" src="view/image/payment/logo-kazkom.png" alt="" /> <?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
                <?php } ?>
            </ul>
        </div>
    </div>

    <div class="container-fluid">
        <div class="panel panel-default">
            <div id="message" class="succes" style="position: fixed; width: 500px; min-height: 60px; top: 30%; left: 30%; clear:none"></div>

            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo $text_latest_10_orders; ?></h3>
            </div>

            <div class="panel-body">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="s">

                        <thead>
                            <tr>
                                <td class="text-right"><?php echo $column_visa; ?></td>
                                <td class="text-right"><?php echo $column_order; ?></td>
                                <td class="text-left"><?php echo $column_customer; ?></td>
                                <td class="text-left"><?php echo $column_status; ?></td>
                                <td class="text-left"><?php echo $column_date_added; ?></td>
                                <td class="text-right"><?php echo $column_total; ?></td>
                                <td class="text-right"><?php echo $column_action; ?></td>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($orders) { ?>
                                <?php $z = 0; ?>
                                <?php foreach ($orders as $order) { ?>
                                    <?php $z++; ?>
                                    <tr>
                                        <td class="text-right"><?php echo $order['visa_id']; ?></td>
                                        <td class="text-right"><?php echo $order['order_id']; ?></td>
                                        <td class="text-left"><?php echo $order['customer_reference']; ?></td>
                                        <td class="text-left"><?php echo $order['transaction_status']; ?></td>
                                        <td class="text-left"><?php echo $order['date_added']; ?></td>
                                        <td class="text-right"><?php echo $order['total']; ?></td>
                                        <td class="text-right"><?php foreach ($order['action'] as $action) { ?>
                                                <?php if ($order['transaction_status'] == $authorized_status) { ?>
                                                    <a onclick="confirm(<?php echo $order['visa_id']; ?>);" data-toggle="tooltip" title="<?php echo $action['text1']; ?>" class="btn btn-success"><i class="fa fa-plus-circle"></i></a>
                                                    <a onclick="cancel(<?php echo $order['visa_id']; ?>);" data-toggle="tooltip" title="<?php echo $action['text2']; ?>" class="btn btn-warning"><i class="fa fa-minus-circle"></i></a>
                                                <?php } ?>
                                                <a href="<?php echo $action['href']; ?>" data-toggle="tooltip" title="<?php echo $action['text3']; ?>" class="btn btn-info"><i class="fa fa-eye"></i></a>
                                                <a onclick="refresh(<?php echo $order['visa_id']; ?>);" data-toggle="tooltip" title="<?php echo $action['text']; ?>" class="btn btn-primary"><i class="fa fa-refresh"></i></a>
                                            <?php } ?>
                                        </td>
                                    </tr>
                                <?php } ?>
                            <?php } else { ?>
                                <tr>
                                    <td class="center" colspan="6"><?php echo $text_no_results; ?></td>
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<!--[if IE]>
<script type="text/javascript" src="view/javascript/jquery/flot/excanvas.js"></script>
<![endif]-->
<script type="text/javascript"><!--
var token = '<?php echo $token; ?>';

    function refresh(idd) {
        var tr = window.event.srcElement.parentElement;
        while ('TR' !== tr.tagName)
            tr = tr.parentElement;
        // подсчитываем номер строки
        for (var row = 0; tr !== null; tr = tr.previousSibling, row++)
            ;
        row = row / 2;

        $.ajax({
            type: 'GET',
            dataType: 'json',
            data: '&visa_id=' + idd,
            url: 'index.php?route=sale/visa_kkb/refresh&token=' + token,
            success: function (message) {
                if (message['success']) {
                     window.location.reload(true);
                } else { 
                    document.all.s.rows[row].cells[3].innerHTML = message['status'];                
                    creatMessage(message);
                }                
            }
        });
    }

    function confirm(id) {
        var tr = window.event.srcElement.parentElement;
        while ('TR' !== tr.tagName)
            tr = tr.parentElement;
        // подсчитываем номер строки
        for (var row = 0; tr !== null; tr = tr.previousSibling, row++)
            ;
        row = row / 2;
        //alert(row);
        console.log(id);
        $.ajax({
            type: 'GET',
            dataType: 'json',
            data: '&visa_id=' + id,
            url: 'index.php?route=sale/visa_kkb/confirm&token=' + token,
            success: function (message) {
                if (message['success']) {
                     window.location.reload(true);
                } else { 
                    document.all.s.rows[row].cells[3].innerHTML = message['status'];                
                    creatMessage(message);
                }                
            }
        });
    }

    function cancel(id) {
        var tr = window.event.srcElement.parentElement;
        while ('TR' != tr.tagName)
            tr = tr.parentElement;
        // подсчитываем номер строки
        for (var row = 0; tr != null; tr = tr.previousSibling, row++)
            ;
        row = row / 2;

        console.log(id);
        $.ajax({
            type: 'GET',
            dataType: 'json',
            data: '&visa_id=' + id,
            url: 'index.php?route=sale/visa_kkb/cancel&token=' + token,
            success: function (message) {
                if (message['success']) {
                     window.location.reload(true);
                } else { 
                    document.all.s.rows[row].cells[3].innerHTML = message['status'];                
                    creatMessage(message);
                }                
            }
        });
    }

    function creatMessage(message) {
        if (message['success']) {
            $('.alert').remove();
            //	$('#message').removeClass('warning').addClass('success').html(message['success']);
            $('#content > .container-fluid').prepend('<div class="alert alert-success"><i class="fa fa-check-circle"></i> ' + message['success'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
        } else {
            $('.alert').remove();
            $('#content > .container-fluid').prepend('<div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> ' + message['warning'] + ' <button type="button" class="close" data-dismiss="alert">&times;</button></div>');
            //	$('#message').removeClass('success').addClass('warning').html(message['warning']);
        }

        $('.alert').delay(4500).slideUp(600).fadeOut(2500);
    }
//--></script>
<?php echo $footer; ?>