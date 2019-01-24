<?php

require_once(DIR_SYSTEM . 'library/epay/kkb.utils.php');
@include_once(DIR_SYSTEM . 'license/sllic.lic');

class ControllerExtensionPaymentEpay extends Controller {

    private $error = array();

    public function index() {
        $this->load->language('extension/payment/epay');

        $data['button_confirm'] = $this->language->get('button_confirm');
        $data['button_back'] = $this->language->get('button_back');
        $data['text_note'] = $this->language->get('text_note');
        $data['error_text_danger'] = $this->language->get('error_text_danger');

        $this->load->model('checkout/order');
        $order_info = $this->model_checkout_order->getOrder($this->session->data['order_id']);
        $mode = $this->config->get('epay_mode');

        $data['action'] = $this->config->get('epay_server_action' . (string) $mode);
        $data['email'] = $order_info['email'];
        $data['language'] = 'ru';
        $data['backlink'] = HTTPS_SERVER . 'index.php?route=extension/payment/epay/success';
        $data['postlink'] = HTTPS_SERVER . 'index.php?route=extension/payment/epay/postlink';

        $request = array();
        $request['MERCHANT_ID'] = $this->config->get('epay_merchant_id' . (string) $mode);
        $request['MERCHANT_CERTIFICATE_ID'] = $this->config->get('epay_merchant_certificate_id' . (string) $mode);
        $request['MERCHANT_NAME'] = $this->config->get('epay_merchant_name' . (string) $mode);
        $request['ORDER_ID'] = str_pad($this->session->data['order_id'], 6, "4", STR_PAD_LEFT);
        $request['CURRENCY'] = "398";
		$kzt_order_total = $this->currency->convert($order_info['total'], $order_info['currency_code'], 'KZT');
        $request['AMOUNT'] = $this->currency->format($kzt_order_total, $order_info['currency_code'], $order_info['currency_value'], FALSE);
		
		if (class_exists('Vendor')) {
			$vendor = new Vendor();
		}					
		$vendor->franchise();
        $kkb = new KKBSign();
        $kkb->invert();
        $kkb->load_private_key(DIR_SYSTEM . 'library/epay/' . $this->config->get('epay_private_key_fn' . (string) $mode), $this->config->get('epay_private_key_pass' . (string) $mode));

        //    $this->session->data['postlink'] = 'bebe';
        $data['error_sign'] = '';

        if ($kkb->ecode > 0) {
            $data['error_sign'] = $kkb->estatus;
        } else {
            $result = process_XML(DIR_SYSTEM . 'library/epay/template.xml', $request);

            if (strpos($result, "[RERROR]") > 0) {
                $data['error_sign'] = "Error XML template.";
            } else {
                $result_sign = '<merchant_sign type="RSA" cert_id="' . $this->config->get('epay_merchant_certificate_id' . (string) $mode) . '">' . $kkb->sign64($result) . '</merchant_sign>';
                $data['request'] = base64_encode("<document>" . $result . $result_sign . "</document>");
            }
        }

        return $this->load->view('extension/payment/epay', $data);
    }

    public function postlink() {

        if (isset($_POST["response"])) {
            $response = $_POST["response"];
        }
        ///     $response = file_get_contents('postlinktest0.txt');
        $mode = $this->config->get('epay_mode');
        $xml_parser = new xml();
        $result = $xml_parser->parse(stripslashes($response));

        if (is_array($result)) {

            if (in_array("ERROR", $result)) {

                $visa = array(
                    'order_id' => ltrim($result['RESPONSE_ORDER_ID'], '4'),
                    'customer_reference' => $result['SESSION_ID'],
                    'approval_code' => '',
                    'card_number' => '',
                    'card_country' => '',
                    'verified3d' => '',
                    'total' => '',
                    'transaction_status' => $this->config->get('epay_declined_status_id'),
                    'comment' => $result['ERROR_CHARDATA']
                );
            }

            if (in_array("DOCUMENT", $result)) {
                $kkb = new KKBSign();
                $kkb->invert();
                $confirm = split_sign($response, "BANK");
                $check = $kkb->check_sign64($confirm['LETTER'], $confirm['RAWSIGN'], DIR_SYSTEM . 'library/epay/' . trim($this->config->get('epay_public_key_fn' . (string) $mode)));
file_put_contents('epay.txt', print_r('check='.$check,true),FILE_APPEND);
file_put_contents('epay.txt', print_r($confirm['RAWSIGN'],true),FILE_APPEND);
//file_put_contents('0.txt', print_r($kkb->estatus,true),FILE_APPEND);
                $visa = array(
                    'order_id' => ltrim($result['ORDER_ORDER_ID'], '4'),
                    'customer_reference' => $result['PAYMENT_REFERENCE'],
                    'approval_code' => $result['PAYMENT_APPROVAL_CODE'],
                    'card_number' => $result['PAYMENT_CARD'],
                    'card_country' => $result['PAYMENT_CARD_BIN'],
                    'verified3d' => $result['PAYMENT_SECURE'],
                    'total' => $result['PAYMENT_AMOUNT'],
                    'transaction_status' => ($check == 1) ? $this->config->get('epay_check_status_id') : $this->config->get('epay_error_status_id'),
                    'comment' => ''
                );
            }
file_put_contents('epay.txt', print_r("POSTLINK",true),FILE_APPEND);			
file_put_contents('epay.txt', print_r($visa,true),FILE_APPEND);
			$this->load->model('checkout/order');
            $this->load->model('extension/payment/epay');
            $vs = $this->model_extension_payment_epay->addVisa($visa);
            $this->model_extension_payment_epay->addVisaToOrder($vs, ltrim($visa['order_id'], '4'));
			$this->model_checkout_order->addOrderHistory(ltrim($visa['order_id'], '4'), $visa['transaction_status']);
        } else {
            // or save in error logfile
            $file = DIR_LOGS . $this->config->get('config_error_filename');
            file_put_contents($file, 'Content-Type: payment/epay  ' . date('Y-m-d_H-i-s', time()) .  " Postlink error => [XML_DOCUMENT_UNKNOWN_TYPE]", FILE_APPEND);
        }
    }

    public function success() {
        $error_warning = '';

        $this->load->language('extension/payment/epay');
        $this->load->model('checkout/order');
        $this->load->model('extension/payment/epay');
        $result = $this->model_extension_payment_epay->getVisaByOrder($this->session->data['order_id']);
file_put_contents('epay.txt', print_r("SUCCESS",true),FILE_APPEND);			
file_put_contents('epay.txt', print_r($result,true),FILE_APPEND);
        if ($result['transaction_status'] == $this->config->get('epay_declined_status_id')) {
            $error_warning = $this->language->get('error_text_declined');
        }
        if ($result['transaction_status'] == $this->config->get('epay_error_status_id')) {
            $error_warning = $this->language->get('error_text_error') . ' ( ' . $result['comment'] . ' )';
        }
		if (!$result['transaction_status'] && !$result['customer_reference'] ) {
            $error_warning = $this->language->get('error_text_reversed');
			$this->response->redirect(HTTP_SERVER . 'index.php?route=error/not_operation&error=' . $this->language->get('error_text_reversed'));
        }
        if ($error_warning) {
            $this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('epay_declined_status_id'));
            $this->response->redirect(HTTP_SERVER . 'index.php?route=error/not_operation&error=' . $error_warning);
        } else {
            $this->model_checkout_order->addOrderHistory($this->session->data['order_id'], $this->config->get('epay_check_status_id'));
            $this->response->redirect(HTTPS_SERVER . 'index.php?route=checkout/success');
        }
    }

}

?>