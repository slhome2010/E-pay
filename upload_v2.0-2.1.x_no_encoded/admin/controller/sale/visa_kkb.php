<?php

//require_once(DIR_SYSTEM . 'library/epay/ip2locationlite.class.php');
require_once(DIR_SYSTEM . 'library/epay/kkb.utils.php');

class ControllerSaleVisaKkb extends Controller {

    private $error = array();

    public function index() {

        $this->load->language('sale/visa_kkb');

        $this->document->setTitle($this->language->get('heading_title'));

        $data['heading_title'] = $this->language->get('heading_title');

        $data['text_latest_10_orders'] = $this->language->get('text_latest_10_orders');
        $data['text_total_order'] = $this->language->get('text_total_order');

        $data['text_no_results'] = $this->language->get('text_no_results');
        $data['column_visa'] = $this->language->get('column_visa');
        $data['column_order'] = $this->language->get('column_order');
        $data['column_customer'] = $this->language->get('column_customer');
        $data['column_status'] = $this->language->get('column_status');
        $data['column_date_added'] = $this->language->get('column_date_added');
        $data['column_total'] = $this->language->get('column_total');
        $data['column_firstname'] = $this->language->get('column_firstname');
        $data['column_lastname'] = $this->language->get('column_lastname');
        $data['column_action'] = $this->language->get('column_action');
        $data['button_refresh'] = $this->language->get('button_refresh');

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL')
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('sale/visa_kkb', 'token=' . $this->session->data['token'], 'SSL')
        );

        $data['token'] = $this->session->data['token'];

        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        $this->load->model('sale/visa_kkb');
        $this->load->model('localisation/order_status');

        $data['orders'] = array();

        $param = array(
            'sort' => 'o.date_added',
            'order' => 'DESC',
            'start' => 0,
            'limit' => 20
        );
//file_put_contents('epay.txt', print_r("SUCCESS" . PHP_EOL,true),FILE_APPEND);			
//file_put_contents('epay.txt', print_r($param,true),FILE_APPEND);
        $results = $this->model_sale_visa_kkb->getOrders($param);

        foreach ($results as $result) {
            $action = array();
            $transaction_status = $this->model_localisation_order_status->getOrderStatus($result['transaction_status']);

            $action[] = array(
                'text' => $this->language->get('text_refresh'),
                'text1' => $this->language->get('text_confirm'),
                'text2' => $this->language->get('text_cancel'),
                'text3' => $this->language->get('text_verified'),
                'href' => $this->url->link('sale/visa_kkb/info', 'token=' . $this->session->data['token'] .
                        '&order_id=' . $result['order_id'] .
                        '&customer_reference=' . $result['customer_reference'] .
                        '&transaction_status=' . $result['transaction_status'], 'SSL')
            );

            $data['orders'][] = array(
                'visa_id' => $result['visa_kkb_id'],
                'order_id' => $result['order_id'],
                'customer' => $result['customer'],
                'status' => $result['status'],
                'customer_reference' => $result['customer_reference'],
                'transaction_status' => $transaction_status['name'],
                'date_added' => date($this->language->get('date_format_short'), strtotime($result['date_added'])),
                'total' => $this->currency->format($result['total'], $result['currency_code'], $result['currency_value']),
                'action' => $action
            );
        }

        $authorized_status = $this->model_localisation_order_status->getOrderStatus($this->config->get('epay_check_status_id'));
        $data['authorized_status'] = $authorized_status['name'];
        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('sale/visa_kkb.tpl', $data));
    }

    public function refresh() {
        $visa = array();
        $this->load->model('sale/visa_kkb');
        $this->load->model('localisation/order_status');

        $visa_kkbID = (isset($this->request->get['visa_id'])) ? (int) $this->request->get['visa_id'] : NULL;

        $set = array(
            'sort' => 'o.date_added',
            'order' => 'DESC',
            'filter_visa_id' => $visa_kkbID,
            'start' => 0,
            'limit' => 20
        );
        $orders = $this->model_sale_visa_kkb->getOrders($set);
        $mode = $this->config->get('epay_mode');

        foreach ($orders as $order) {
            // запрос информации на сервер Казкома
            $request = array();
			$str_pad = (int)$order['order_id'] < 999 ? "5" : "0";
            $request['MERCHANT_ID'] = $this->config->get('epay_merchant_id' . (string) $mode);
            $request['ORDER_ID'] = ($mode) ? $order['order_id'] : str_pad($order['order_id'], 6, $str_pad, STR_PAD_LEFT);

            $kkb = new KKBSign();
            $kkb->invert();
            $kkb->load_private_key(DIR_SYSTEM . 'library/epay/' . $this->config->get('epay_private_key_fn' . (string) $mode), $this->config->get('epay_private_key_pass' . (string) $mode));

            if ($kkb->ecode > 0) {
                $this->error['warning'] = $kkb->estatus;
            } else {
                $xml = '<merchant id="' . $this->config->get('epay_merchant_id' . (string) $mode) . '"><order id="' . $request['ORDER_ID'] . '"/></merchant>';
                if (strpos($xml, "[RERROR]") > 0) {
                    $this->error['warning'] = "Error XML template.";
                } else {
                    $result_sign = '<merchant_sign type="RSA" cert_id="' . $this->config->get('epay_merchant_certificate_id' . (string) $mode) . '">' . $kkb->sign64($xml) . '</merchant_sign>';
                    $url = $this->config->get('epay_server_checking' . (string) $mode) . urlencode("<document>" . $xml . $result_sign . "</document>");

//file_put_contents('epay.txt', print_r($url,true),FILE_APPEND);
//file_put_contents('epay.txt', print_r(PHP_EOL,true),FILE_APPEND);                  
				   $response = $this->connect($url);
//file_put_contents('epay.txt', print_r($response,true),FILE_APPEND);
//file_put_contents('epay.txt', print_r(PHP_EOL,true),FILE_APPEND);

                    $xml_parser = new xml();
                    $result = $xml_parser->parse(stripslashes($response));

                    if (is_array($result)) {

                        if (in_array("ERROR", $result)) {
                            $this->error['warning'] = "System error: " . $result['ORDER_ID'];
                        } elseif (in_array("DOCUMENT", $result)) {

                            if ($result['RESPONSE_PAYMENT'] == 'true') {
                                if ($result['RESPONSE_STATUS'] == '0') {
                                    $transaction_status = $this->config->get('epay_check_status_id');
                                } elseif ($result['RESPONSE_STATUS'] == '2') {
                                    $transaction_status = $this->config->get('epay_order_status_id');
                                } else {
                                    $transaction_status = $this->config->get('epay_error_status_id');
                                }
                            }

                            if ($result['RESPONSE_PAYMENT'] == 'false') {
                                if ($result['RESPONSE_STATUS'] == '8') {
                                    $transaction_status = $this->config->get('epay_declined_status_id');
                                } elseif ($result['RESPONSE_STATUS'] == '2') {
                                    $transaction_status = $this->config->get('epay_canceled_status_id');
                                } else {
                                    $transaction_status = $this->config->get('epay_error_status_id');
                                }
                            }

                            $visa = array(
                                'order_id' => ($mode) ? $result['ORDER_ID'] : ltrim($result['ORDER_ID'], $str_pad),
                                'comment' => $result['RESPONSE_MSG'],
                                'transaction_status' => $transaction_status
                            );
                            $this->model_sale_visa_kkb->editVisa($visa);

                            $history = array(
                                'notify' => '0',
                                'order_status_id' => $transaction_status
                            );
                            $this->model_sale_visa_kkb->addOrderHistory($visa['order_id'], $history);
                        } else {
                            $this->error['warning'] = "Connection error";
                        }
                    } else {
                        $this->error['warning'] = "System error";
                    }
                }
            }
        }

        // выдача данных для jquery обновление страницы
        $this->language->load('sale/visa_kkb');
        $order_status = $this->model_localisation_order_status->getOrderStatus($visa['transaction_status']);
        echo json_encode(array('warning' => ($this->error) ? $this->error['warning'] : FALSE, 'success' => (!$this->error) ? $this->language->get('text_success') : FALSE,
            'status' => isset($visa['transaction_status']) ? $order_status['name'] : '',
                //  'reference' => isset($visa['customer_reference']) ? $visa['customer_reference'] : ''
        ));
    }

    public function confirm() {

        $visa = array();
        $this->load->model('sale/visa_kkb');
        $this->load->model('localisation/order_status');

        $visa_kkbID = (isset($this->request->get['visa_id'])) ? (int) $this->request->get['visa_id'] : NULL;

        $set = array(
            'sort' => 'o.date_added',
            'order' => 'DESC',
            'filter_visa_id' => $visa_kkbID,
            'start' => 0,
            'limit' => 20
        );
        $orders = $this->model_sale_visa_kkb->getOrders($set);
        $mode = $this->config->get('epay_mode');
		
		
        foreach ($orders as $order) {
            // запрос информации на сервер Казкома
			$str_pad = (int)$order['order_id'] < 999 ? "5" : "0";
            $request = array();
            $request['MERCHANT_ID'] = $this->config->get('epay_merchant_id' . (string) $mode);
            $request['ORDER_ID'] = ($mode) ? $order['order_id'] : str_pad($order['order_id'], 6, $str_pad, STR_PAD_LEFT);
            $request['MERCHANT_NAME'] = $this->config->get('epay_merchant_name' . (string) $mode);
            $request['COMMAND'] = 'complete';
            $request['REFERENCE_ID'] = $order['customer_reference'];
            $request['APPROVAL_CODE'] = $order['approval_code'];
            $request['CURRENCY'] = '398';
            $request['AMOUNT'] = $order['total'];
            $request['REASON'] = '';

            $kkb = new KKBSign();
            $kkb->invert();
            $kkb->load_private_key(DIR_SYSTEM . 'library/epay/' . $this->config->get('epay_private_key_fn' . (string) $mode), $this->config->get('epay_private_key_pass' . (string) $mode));

            if ($kkb->ecode > 0) {
                $this->error['warning'] = $kkb->estatus;
            } else {
                $xml = process_XML(DIR_SYSTEM . 'library/epay/command_template.xml', $request);
                if (strpos($xml, "[RERROR]") > 0) {
                    $this->error['warning'] = "Error XML template.";
                } else {
                    $result_sign = '<merchant_sign type="RSA" cert_id="' . $this->config->get('epay_merchant_certificate_id' . (string) $mode) . '">' . $kkb->sign64($xml) . '</merchant_sign>';
                    $url = $this->config->get('epay_server_control' . (string) $mode) . urlencode("<document>" . $xml . $result_sign . "</document>");
// file_put_contents('epay.txt', print_r($url,true),FILE_APPEND);
//file_put_contents('epay.txt', print_r(PHP_EOL,true),FILE_APPEND);                  
				   $response = $this->connect($url);
//file_put_contents('epay.txt', print_r($response,true),FILE_APPEND);
//file_put_contents('epay.txt', print_r(PHP_EOL,true),FILE_APPEND);
                    $xml_parser = new xml();
                    $result = $xml_parser->parse(stripslashes($response));

                    if (is_array($result)) {

                        if (in_array("ERROR", $result)) {
                            $this->error['warning'] = "System error: " . $result['ERROR_CHARDATA'];
                        } elseif (in_array("DOCUMENT", $result)) {

                            if ($result['RESPONSE_CODE'] == '00') {
                                $transaction_status = $this->config->get('epay_order_status_id');
                            } else {
                                $transaction_status = $this->config->get('epay_error_status_id');
                            }

                            $visa = array(
                                'order_id' => ($mode) ? $result['PAYMENT_ORDERID'] : ltrim($result['PAYMENT_ORDERID'], $str_pad),
                                'comment' => $result['RESPONSE_MESSAGE'],
                                'transaction_status' => $transaction_status
                            );
                            $this->model_sale_visa_kkb->editVisa($visa);

                            $history = array(
                                'notify' => '0',
                                'order_status_id' => $transaction_status
                            );
                            $this->model_sale_visa_kkb->addOrderHistory($visa['order_id'], $history);
                        } else {
                            $this->error['warning'] = "Connection error";
                        }
                    } else {
                        $this->error['warning'] = "System error";
                    }
                }
            }
        }

        // выдача данных для jquery обновление страницы
        $this->language->load('sale/visa_kkb');
        $order_status = $this->model_localisation_order_status->getOrderStatus($visa['transaction_status']);
        echo json_encode(array('warning' => ($this->error) ? $this->error['warning'] : FALSE, 'success' => (!$this->error) ? $this->language->get('text_success') : FALSE,
            'status' => isset($visa['transaction_status']) ? $order_status['name'] : '',
                //  'reference' => isset($visa['customer_reference']) ? $visa['customer_reference'] : ''
        ));
    }

    public function cancel() {
        $visa = array();
        $this->load->model('sale/visa_kkb');
        $this->load->model('localisation/order_status');

        $visa_kkbID = (isset($this->request->get['visa_id'])) ? (int) $this->request->get['visa_id'] : NULL;

        $set = array(
            'sort' => 'o.date_added',
            'order' => 'DESC',
            'filter_visa_id' => $visa_kkbID,
            'start' => 0,
            'limit' => 20
        );
        $orders = $this->model_sale_visa_kkb->getOrders($set);
        $mode = $this->config->get('epay_mode');
		
        foreach ($orders as $order) {
            // запрос информации на сервер Казкома
			$str_pad = (int)$order['order_id'] < 999 ? "5" : "0";
            $request = array();
            $request['MERCHANT_ID'] = $this->config->get('epay_merchant_id' . (string) $mode);
            $request['ORDER_ID'] = ($mode) ? $order['order_id'] : str_pad($order['order_id'], 6, $str_pad, STR_PAD_LEFT);
            $request['MERCHANT_NAME'] = $this->config->get('epay_merchant_name' . (string) $mode);
            $request['COMMAND'] = 'reverse';
            $request['REFERENCE_ID'] = $order['customer_reference'];
            $request['APPROVAL_CODE'] = $order['approval_code'];
            $request['CURRENCY'] = '398';
            $request['AMOUNT'] = $order['total'];
            $request['REASON'] = 'The store can not accept payment';

            $kkb = new KKBSign();
            $kkb->invert();
            $kkb->load_private_key(DIR_SYSTEM . 'library/epay/' . $this->config->get('epay_private_key_fn' . (string) $mode), $this->config->get('epay_private_key_pass' . (string) $mode));

            if ($kkb->ecode > 0) {
                $this->error['warning'] = $kkb->estatus;
            } else {
                $xml = process_XML(DIR_SYSTEM . 'library/epay/command_template.xml', $request);
                if (strpos($xml, "[RERROR]") > 0) {
                    $this->error['warning'] = "Error XML template.";
                } else {
                    $result_sign = '<merchant_sign type="RSA" cert_id="' . $this->config->get('epay_merchant_certificate_id' . (string) $mode) . '">' . $kkb->sign64($xml) . '</merchant_sign>';
                    $url = $this->config->get('epay_server_control' . (string) $mode) . urlencode("<document>" . $xml . $result_sign . "</document>");
                    $response = $this->connect($url);

                    $xml_parser = new xml();
                    $result = $xml_parser->parse(stripslashes($response));

                    if (is_array($result)) {
                        if (in_array("ERROR", $result)) {
                            $this->error['warning'] = "System error: " . $result['ERROR_CHARDATA'];
                        } elseif (in_array("DOCUMENT", $result)) {

                            if ($result['RESPONSE_CODE'] == '00') {
                                $transaction_status = $this->config->get('epay_canceled_status_id');
                            } else {
                                $transaction_status = $this->config->get('epay_error_status_id');
                            }

                            $visa = array(
                                'order_id' => ($mode) ? $result['PAYMENT_ORDERID'] : ltrim($result['PAYMENT_ORDERID'], $str_pad),
                                'comment' => $result['RESPONSE_MESSAGE'],
                                'transaction_status' => $transaction_status
                            );
                            $this->model_sale_visa_kkb->editVisa($visa);

                            $history = array(
                                'notify' => '0',
                                'order_status_id' => $transaction_status
                            );
                            $this->model_sale_visa_kkb->addOrderHistory($visa['order_id'], $history);
                        } else {
                            $this->error['warning'] = "Connection error";
                        }
                    } else {
                        $this->error['warning'] = "System error";
                    }
                }
            }
        }

        // выдача данных для jquery обновление страницы
        $this->language->load('sale/visa_kkb');
        $order_status = $this->model_localisation_order_status->getOrderStatus($visa['transaction_status']);
        echo json_encode(array('warning' => ($this->error) ? $this->error['warning'] : FALSE, 'success' => (!$this->error) ? $this->language->get('text_success') : FALSE,
            'status' => isset($visa['transaction_status']) ? $order_status['name'] : '',
                //  'reference' => isset($visa['customer_reference']) ? $visa['customer_reference'] : ''
        ));
    }

    public function info() {
        $this->load->language('sale/visa_kkb');

        $this->document->setTitle($this->language->get('heading_title2'));

        $data['heading_title'] = $this->language->get('heading_title2');
        $data['button_back'] = $this->language->get('button_back');
        $data['text_verified'] = $this->language->get('text_verified');

        $data['text_latest_10_orders'] = $this->language->get('text_latest_10_orders');
        $data['text_total_order'] = $this->language->get('text_total_order');
        $data['text_no_results'] = $this->language->get('text_no_results');
        $data['text_visa_big_total'] = $this->language->get('text_visa_big_total');

        $data['column_visa'] = $this->language->get('column_visa');
        $data['column_order'] = $this->language->get('column_order');
        $data['column_customer'] = $this->language->get('column_customer');
        $data['column_status'] = $this->language->get('column_status');
        $data['column_date_added'] = $this->language->get('column_date_added');
        $data['column_total'] = $this->language->get('column_total');
        $data['column_firstname'] = $this->language->get('column_firstname');
        $data['column_lastname'] = $this->language->get('column_lastname');
        $data['column_action'] = $this->language->get('column_action');
        $data['column_comment'] = $this->language->get('column_comment');
        $data['column_approval'] = $this->language->get('column_approval');

        $data['column_country'] = $this->language->get('column_country');
        $data['column_number'] = $this->language->get('column_number');
        $data['column_verified'] = $this->language->get('column_verified');
        $data['column_ip'] = $this->language->get('column_ip');

        $data['breadcrumbs'] = array();

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL')
        );

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title'),
            'href' => $this->url->link('sale/visa_kkb', 'token=' . $this->session->data['token'], 'SSL'),
        );

//$visa_kkbID = (isset ($this->request->get['visa_id'])) ? (int) $this->request->get['visa_id'] : NULL;
        $orderID = (isset($this->request->get['order_id'])) ? $this->request->get['order_id'] : NULL;
        $reference = (isset($this->request->get['customer_reference'])) ? $this->request->get['customer_reference'] : NULL;
        $status = (isset($this->request->get['transaction_status'])) ? $this->request->get['transaction_status'] : NULL;

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('heading_title2'),
            'href' => $this->url->link('sale/visa_kkb/info', 'token=' . $this->session->data['token'] .
                    '&order_id=' . $orderID .
                    '&customer_reference=' . $reference .
                    '&transaction_status=' . $status, 'SSL')
        );

        $data['token'] = $this->session->data['token'];

        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        $data['cancel'] = $this->url->link('sale/visa_kkb', 'token=' . $this->session->data['token'], 'SSL');

        $this->load->model('sale/visa_kkb');
        $this->load->model('localisation/order_status');

        $data['orders'] = array();

        $set = array(
            'sort' => 'o.date_added',
            'order' => 'DESC',
            'filter_order_id' => (int) $orderID,
            'order_id' => $orderID,
            'customer_reference' => $reference,
            'start' => 0,
            'limit' => 20
        );

        //  if ($status == 'AUTHORISED' or $status == 'PAID' or $status == 'DECLINED' or $status == 'REVERSED') {
        //      $results = $this->model_sale_visa_kkb->getExtended($set);
        //   }

        $results = $this->model_sale_visa_kkb->getOrders($set);

        foreach ($results as $result) {
            if ($result['ip_address']) {
                $geoip = new ip2location_lite;
                $geoip->setKey($this->config->get('epay_apikey'));
                $locations = $geoip->getCity($result['ip_address']);
                $errors = $geoip->getError();
                if (!empty($errors)) {
                    $data['text_geoip'] = 'errors' . '<pre>' . print_r($errors, true) . '</pre>';
                } else {
                    $data['text_geoip'] = $locations['countryName'] . ', ' . $locations['cityName'];
                }
            } else {
                $data['text_geoip'] = '';
            }

            $transaction_status = $this->model_localisation_order_status->getOrderStatus($result['transaction_status']);
            $data['orders'][] = array(
                'visa_id' => $result['visa_kkb_id'],
                'order_id' => $result['order_id'],
                'customer' => $result['customer'],
                'status' => $result['status'],
                'customer_reference' => $result['customer_reference'],
                'transaction_status' => $transaction_status['name'],
                'date_added' => date($this->language->get('date_format_short') . ' в ' . $this->language->get('time_format'), strtotime($result['date_added'])),
                'total' => $this->currency->format($result['total'], $result['currency_code'], $result['currency_value']),
                'card_country' => $result['card_country'],
                'card_number' => $result['card_number'],
                'verified3d' => $result['verified3d'],
                'visa_big_total' => $this->config->get('epay_visa_big_total'),
                'geoip' => $data['text_geoip'],
                'ip_address' => $result['ip_address'],
                'comment' => $result['comment'],
                'approval_code' => $result['approval_code']
            );
        }

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('sale/visa_kkb_info.tpl', $data));
    }

    public function connect($url) {
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_URL, $url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        //    curl_setopt($curl,  CURLOPT_SSLVERSION, 1);
        //   curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
        //    curl_setopt($curl, CURLOPT_TIMEOUT, 15);
        curl_setopt($curl, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows; U; Windows NT 5.1; ru; rv:1.9.1.5) Gecko/20091102 Firefox/3.5.5 GTB6");

        $out = curl_exec($curl);
        $errno = curl_errno($curl);
        curl_close($curl);
        return $out;
    }

}

?>