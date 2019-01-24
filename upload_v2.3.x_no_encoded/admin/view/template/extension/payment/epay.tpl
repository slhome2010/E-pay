<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <button type="submit" form="form-epay" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a>
            </div>
            <h1><img src="view/image/payment.png" alt="" /> <?php echo $heading_title; ?></h1>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
                <?php } ?>
            </ul>
        </div>
    </div>

    <div class="container-fluid">
        <?php if ($error_warning) { ?>
            <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div>
        <?php } ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3>
            </div>
            <div class="panel-body">
                <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-epay" class="form-horizontal">
                    <div id="tabs">
                        <ul class="nav nav-tabs">
                            <li><a href="#tab-general" data-toggle="tab"><i class="fa fa-cog"></i> <?php echo $tab_general; ?> </a></li>
                            <li><a href="#tab-test" data-toggle="tab"><i class="fa fa-bank"></i> <?php echo $tab_test; ?> </a></li>
                            <li class="active"><a href="#tab-live" data-toggle="tab"><i class="fa fa-bank"></i> <?php echo $tab_live; ?></a> </li>
                            <li><a href="#tab-support" data-toggle="tab"><i class="fa fa-life-ring"></i> <?php echo $tab_support; ?></a> </li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane" id="tab-general">
                                <div class="form-group">
                                    <label class="col-sm-2 control-label">Режим </label>
                                    <div class="col-sm-10">
                                        <label class="radio-inline">
                                            <input type="radio" name="epay_mode" value="1" <?php
                                            if ($epay_mode) {
                                                echo 'checked';
                                            }
                                            ?> /> Боевой
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio" name="epay_mode" value="0" <?php
                                            if (!$epay_mode) {
                                                echo 'checked';
                                            }
                                            ?> /> Тестовый
                                        </label>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-total"><span data-toggle="tooltip" title="<?php echo $help_total; ?>"><?php echo $entry_total; ?></span></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_total" value="<?php echo $epay_total; ?>" placeholder="<?php echo $entry_total; ?>" id="input-total" class="form-control" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-check_status"><?php echo $entry_check_status; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_check_status_id" id="input-check_status" class="form-control">
                                            <?php foreach ($check_statuses as $check_status) { ?>
                                                <?php if ($check_status['order_status_id'] == $epay_check_status_id) { ?>
                                                    <option value="<?php echo $check_status['order_status_id']; ?>" selected="selected"><?php echo $check_status['name']; ?></option>
    <?php } else { ?>
                                                    <option value="<?php echo $check_status['order_status_id']; ?>"><?php echo $check_status['name']; ?></option>
    <?php } ?>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-declined_status"><?php echo $entry_declined_status; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_declined_status_id" id="input-declined_status" class="form-control">
                                            <?php foreach ($declined_statuses as $declined_status) { ?>
                                                <?php if ($declined_status['order_status_id'] == $epay_declined_status_id) { ?>
                                                    <option value="<?php echo $declined_status['order_status_id']; ?>" selected="selected"><?php echo $declined_status['name']; ?></option>
    <?php } else { ?>
                                                    <option value="<?php echo $declined_status['order_status_id']; ?>"><?php echo $declined_status['name']; ?></option>
    <?php } ?>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-error_status"><?php echo $entry_error_status; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_error_status_id" id="input-error_status" class="form-control">
                                            <?php foreach ($error_statuses as $error_status) { ?>
                                                <?php if ($error_status['order_status_id'] == $epay_error_status_id) { ?>
                                                    <option value="<?php echo $error_status['order_status_id']; ?>" selected="selected"><?php echo $error_status['name']; ?></option>
    <?php } else { ?>
                                                    <option value="<?php echo $error_status['order_status_id']; ?>"><?php echo $error_status['name']; ?></option>
    <?php } ?>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-canceled_status"><?php echo $entry_canceled_status; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_canceled_status_id" id="input-canceled_status" class="form-control">
                                            <?php foreach ($canceled_statuses as $canceled_status) { ?>
                                                <?php if ($canceled_status['order_status_id'] == $epay_canceled_status_id) { ?>
                                                    <option value="<?php echo $canceled_status['order_status_id']; ?>" selected="selected"><?php echo $canceled_status['name']; ?></option>
    <?php } else { ?>
                                                    <option value="<?php echo $canceled_status['order_status_id']; ?>"><?php echo $canceled_status['name']; ?></option>
    <?php } ?>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-order_status"><?php echo $entry_order_status; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_order_status_id" id="input-order_status" class="form-control">
                                            <?php foreach ($order_statuses as $order_status) { ?>
                                                <?php if ($order_status['order_status_id'] == $epay_order_status_id) { ?>
                                                    <option value="<?php echo $order_status['order_status_id']; ?>" selected="selected"><?php echo $order_status['name']; ?></option>
    <?php } else { ?>
                                                    <option value="<?php echo $order_status['order_status_id']; ?>"><?php echo $order_status['name']; ?></option>
    <?php } ?>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-visa_big_total"><?php echo $entry_visa_big_total; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_visa_big_total" value="<?php echo $epay_visa_big_total; ?>" placeholder="<?php echo $entry_visa_big_total; ?>" id="input-visa_big_total" class="form-control" />
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-geo_zone;"><?php echo $entry_geo_zone; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_geo_zone_id" id="input-geo_zone" class="form-control">
                                            <option value="0"><?php echo $text_all_zones; ?></option>
                                            <?php foreach ($geo_zones as $geo_zone) { ?>
                                                <?php if ($geo_zone['geo_zone_id'] == $epay_geo_zone_id) { ?>
                                                    <option value="<?php echo $geo_zone['geo_zone_id']; ?>" selected="selected"><?php echo $geo_zone['name']; ?></option>
    <?php } else { ?>
                                                    <option value="<?php echo $geo_zone['geo_zone_id']; ?>"><?php echo $geo_zone['name']; ?></option>
    <?php } ?>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-status"><?php echo $entry_status; ?></label>
                                    <div class="col-sm-10">
                                        <select name="epay_status" id="input-status" class="form-control">
<?php if ($epay_status) { ?>
                                                <option value="1" selected="selected"><?php echo $text_enabled; ?></option>
                                                <option value="0"><?php echo $text_disabled; ?></option>
<?php } else { ?>
                                                <option value="1"><?php echo $text_enabled; ?></option>
                                                <option value="0" selected="selected"><?php echo $text_disabled; ?></option>
<?php } ?>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-2 control-label" for="input-sort-order"><?php echo $entry_sort_order; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_sort_order" value="<?php echo $epay_sort_order; ?>" placeholder="<?php echo $entry_sort_order; ?>" id="input-sort-order" class="form-control" />
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab-test">
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-merchant_id0"><?php echo $entry_merchant_id; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_merchant_id0" value="<?php echo $epay_merchant_id0; ?>" placeholder="<?php echo $entry_merchant_id; ?>" id="input-merchant_id0" class="form-control" />
                                        <?php if ($error_merchant_id0) { ?>
                                            <div class="text-danger"><?php echo $error_merchant_id0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-merchant_name0"><?php echo $entry_merchant_name; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_merchant_name0" value="<?php echo $epay_merchant_name0; ?>" placeholder="<?php echo $entry_merchant_name; ?>" id="input-merchant_name0" class="form-control" />
                                        <?php if ($error_merchant_name0) { ?>
                                            <div class="text-danger"><?php echo $error_merchant_name0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-merchant_certificate_id0"><?php echo $entry_merchant_certificate_id; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_merchant_certificate_id0" value="<?php echo $epay_merchant_certificate_id0; ?>" placeholder="<?php echo $entry_merchant_certificate_id; ?>" id="input-merchant_certificate_id0" class="form-control" />
                                        <?php if ($error_merchant_certificate_id0) { ?>
                                            <div class="text-danger"><?php echo $error_merchant_certificate_id0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-private_key_fn0"><span data-toggle="tooltip" title="<?php echo $help_path; ?>"><?php echo $entry_private_key_fn; ?></span></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_private_key_fn0" value="<?php echo $epay_private_key_fn0; ?>" placeholder="<?php echo $entry_private_key_fn; ?>" id="input-private_key_fn0" class="form-control" />
                                        <?php if ($error_private_key_fn0) { ?>
                                            <div class="text-danger"><?php echo $error_private_key_fn0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-private_key_pass0"><?php echo $entry_private_key_pass; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_private_key_pass0" value="<?php echo $epay_private_key_pass0; ?>" placeholder="<?php echo $entry_private_key_pass; ?>" id="input-private_key_pass0" class="form-control" />
                                        <?php if ($error_private_key_pass0) { ?>
                                            <div class="text-danger"><?php echo $error_private_key_pass0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-public_key_fn0"><span data-toggle="tooltip" title="<?php echo $help_path; ?>"><?php echo $entry_public_key_fn; ?></span></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_public_key_fn0" value="<?php echo $epay_public_key_fn0; ?>" placeholder="<?php echo $entry_public_key_fn; ?>" id="input-public_key_fn0" class="form-control" />
                                        <?php if ($error_public_key_fn0) { ?>
                                            <div class="text-danger"><?php echo $error_public_key_fn0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-server_action0"><?php echo $entry_server_action; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_server_action0" value="<?php echo $epay_server_action0; ?>" placeholder="<?php echo $entry_server_action; ?>" id="input-server_action0" class="form-control" />
                                        <?php if ($error_server_action0) { ?>
                                            <div class="text-danger"><?php echo $error_server_action0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-server_checking0"><?php echo $entry_server_checking; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_server_checking0" value="<?php echo $epay_server_checking0; ?>" placeholder="<?php echo $entry_server_checking; ?>" id="input-server_checking0" class="form-control" />
                                        <?php if ($error_server_checking0) { ?>
                                            <div class="text-danger"><?php echo $error_server_checking0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-server_control0"><?php echo $entry_server_control; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_server_control0" value="<?php echo $epay_server_control0; ?>" placeholder="<?php echo $entry_server_control; ?>" id="input-server_control0" class="form-control" />
                                        <?php if ($error_server_control0) { ?>
                                            <div class="text-danger"><?php echo $error_server_control0 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane active" id="tab-live">
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-merchant_id1"><?php echo $entry_merchant_id; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_merchant_id1" value="<?php echo $epay_merchant_id1; ?>" placeholder="<?php echo $entry_merchant_id; ?>" id="input-merchant_id1" class="form-control" />
                                        <?php if ($error_merchant_id1) { ?>
                                            <div class="text-danger"><?php echo $error_merchant_id1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-merchant_name1"><?php echo $entry_merchant_name; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_merchant_name1" value="<?php echo $epay_merchant_name1; ?>" placeholder="<?php echo $entry_merchant_name; ?>" id="input-merchant_name1" class="form-control" />
                                        <?php if ($error_merchant_name1) { ?>
                                            <div class="text-danger"><?php echo $error_merchant_name1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-merchant_certificate_id1"><?php echo $entry_merchant_certificate_id; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_merchant_certificate_id1" value="<?php echo $epay_merchant_certificate_id1; ?>" placeholder="<?php echo $entry_merchant_certificate_id; ?>" id="input-merchant_certificate_id1" class="form-control" />
                                        <?php if ($error_merchant_certificate_id1) { ?>
                                            <div class="text-danger"><?php echo $error_merchant_certificate_id1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-private_key_fn1"><span data-toggle="tooltip" title="<?php echo $help_path; ?>"><?php echo $entry_private_key_fn; ?></span></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_private_key_fn1" value="<?php echo $epay_private_key_fn1; ?>" placeholder="<?php echo $entry_private_key_fn; ?>" id="input-private_key_fn1" class="form-control" />
                                        <?php if ($error_private_key_fn1) { ?>
                                            <div class="text-danger"><?php echo $error_private_key_fn1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-private_key_pass1"><?php echo $entry_private_key_pass; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_private_key_pass1" value="<?php echo $epay_private_key_pass1; ?>" placeholder="<?php echo $entry_private_key_pass; ?>" id="input-private_key_pass1" class="form-control" />
                                        <?php if ($error_private_key_pass1) { ?>
                                            <div class="text-danger"><?php echo $error_private_key_pass1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-public_key_fn1"><span data-toggle="tooltip" title="<?php echo $help_path; ?>"><?php echo $entry_public_key_fn; ?></span></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_public_key_fn1" value="<?php echo $epay_public_key_fn1; ?>" placeholder="<?php echo $entry_public_key_fn; ?>" id="input-public_key_fn1" class="form-control" />
                                        <?php if ($error_public_key_fn1) { ?>
                                            <div class="text-danger"><?php echo $error_public_key_fn1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-server_action1"><?php echo $entry_server_action; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_server_action1" value="<?php echo $epay_server_action1; ?>" placeholder="<?php echo $entry_server_action; ?>" id="input-server_action1" class="form-control" />
                                        <?php if ($error_server_action1) { ?>
                                            <div class="text-danger"><?php echo $error_server_action1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-server_checking1"><?php echo $entry_server_checking; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_server_checking1" value="<?php echo $epay_server_checking1; ?>" placeholder="<?php echo $entry_server_checking; ?>" id="input-server_checking1" class="form-control" />
                                        <?php if ($error_server_checking1) { ?>
                                            <div class="text-danger"><?php echo $error_server_checking1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                                <div class="form-group required">
                                    <label class="col-sm-2 control-label" for="input-server_control1"><?php echo $entry_server_control; ?></label>
                                    <div class="col-sm-10">
                                        <input type="text" name="epay_server_control1" value="<?php echo $epay_server_control1; ?>" placeholder="<?php echo $entry_server_control; ?>" id="input-server_control1" class="form-control" />
                                        <?php if ($error_server_control1) { ?>
                                            <div class="text-danger"><?php echo $error_server_control1 ?></div>
                                        <?php } ?>
                                    </div>
                                </div>
                            </div>
                            <div class="tab-pane" id="tab-support">
                                <fieldset>
                                    <legend>Служба поддержки</legend>
                                    <address>
                                        По всем вопросам, связаннымы с работой модуля обращайтесь:<br/>
                                        <i class="fa fa-skype"></i> sl271261414<br/>
                                        <strong>E-mail:</strong> <a href="mailto:#">comtronics@mail.ru</a><br/>
                                        <strong>Сайт-демо:</strong> <a href="http://demo.radiocity.kz">demo.radiocity.kz</a>
                                    </address>
                                </fieldset>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?php echo $footer; ?>