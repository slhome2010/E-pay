<?php

class ControllerPaymentEpay extends Controller {

    private $error = array();

    public function index() {
        $extension = version_compare(VERSION, '2.3.0', '>=') ? "extension/" : "";       
        
		if (version_compare(VERSION, '2.2.0', '>=')) {
            $this->load->language($extension . 'payment/epay');
            $ssl = true;
        } else {
            $this->load->language('payment/epay');
            $ssl = 'SSL';
        }		

        $this->document->setTitle(strip_tags($this->language->get('heading_title')));

        $this->load->model('setting/setting');

        if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
            $this->model_setting_setting->editSetting('epay', $this->request->post);
            $this->session->data['success'] = $this->language->get('text_success');
            $this->response->redirect($this->url->link('extension/payment', 'token=' . $this->session->data['token'], 'SSL'));
        }

        $data['heading_title'] = $this->language->get('heading_title');

        $data['entry_total'] = $this->language->get('entry_total');
        $data['help_total'] = $this->language->get('help_total');
        $data['help_path'] = $this->language->get('help_path');

        $data['tab_general'] = $this->language->get('tab_general');
        $data['tab_test'] = $this->language->get('tab_test');
        $data['tab_live'] = $this->language->get('tab_live');
        $data['tab_support'] = $this->language->get('tab_support');

        $data['entry_merchant_id'] = $this->language->get('entry_merchant_id');
        $data['entry_merchant_name'] = $this->language->get('entry_merchant_name');
        $data['entry_merchant_certificate_id'] = $this->language->get('entry_merchant_certificate_id');
        $data['entry_private_key_fn'] = $this->language->get('entry_private_key_fn');
        $data['entry_private_key_pass'] = $this->language->get('entry_private_key_pass');
        $data['entry_public_key_fn'] = $this->language->get('entry_public_key_fn');
        $data['entry_server_action'] = $this->language->get('entry_server_action');
        $data['entry_server_checking'] = $this->language->get('entry_server_checking');
        $data['entry_server_control'] = $this->language->get('entry_server_control');

        $data['text_edit'] = $this->language->get('text_edit');
        $data['text_enabled'] = $this->language->get('text_enabled');
        $data['text_disabled'] = $this->language->get('text_disabled');
        $data['text_all_zones'] = $this->language->get('text_all_zones');

        $data['entry_order_status'] = $this->language->get('entry_order_status');
        $data['entry_check_status'] = $this->language->get('entry_check_status');
        $data['entry_declined_status'] = $this->language->get('entry_declined_status');
        $data['entry_error_status'] = $this->language->get('entry_error_status');
        $data['entry_canceled_status'] = $this->language->get('entry_canceled_status');
        $data['entry_comission_status'] = $this->language->get('entry_comission_status');
        $data['entry_geo_zone'] = $this->language->get('entry_geo_zone');
        $data['entry_status'] = $this->language->get('entry_status');
        $data['entry_sort_order'] = $this->language->get('entry_sort_order');
        $data['entry_apikey'] = $this->language->get('entry_apikey');
        $data['entry_visa_big_total'] = $this->language->get('entry_visa_big_total');

        $data['button_save'] = $this->language->get('button_save');
        $data['button_cancel'] = $this->language->get('button_cancel');

        $data['tab_general'] = $this->language->get('tab_general');

        if (isset($this->error['warning'])) {
            $data['error_warning'] = $this->error['warning'];
        } else {
            $data['error_warning'] = '';
        }

        for ($i = 0; $i < 2; $i++) {
        if (isset($this->error['merchant_id'])) {
            $data['error_merchant_id' . (string) $i] = $this->error['merchant_id' . (string) $i];
        } else {
            $data['error_merchant_id' . (string) $i] = '';
        }
        if (isset($this->error['merchant_name' . (string) $i])) {
            $data['error_merchant_name' . (string) $i] = $this->error['merchant_name' . (string) $i];
        } else {
            $data['error_merchant_name' . (string) $i] = '';
        }
        if (isset($this->error['merchant_certificate_id' . (string) $i])) {
            $data['error_merchant_certificate_id' . (string) $i] = $this->error['merchant_certificate_id' . (string) $i];
        } else {
            $data['error_merchant_certificate_id' . (string) $i] = '';
        }
        if (isset($this->error['private_key_fn' . (string) $i])) {
            $data['error_private_key_fn' . (string) $i] = $this->error['private_key_fn' . (string) $i];
        } else {
            $data['error_private_key_fn' . (string) $i] = '';
        }
        if (isset($this->error['private_key_pass' . (string) $i])) {
            $data['error_private_key_pass' . (string) $i] = $this->error['private_key_pass' . (string) $i];
        } else {
            $data['error_private_key_pass' . (string) $i] = '';
        }
        if (isset($this->error['public_key_fn' . (string) $i])) {
            $data['error_public_key_fn' . (string) $i] = $this->error['public_key_fn' . (string) $i];
        } else {
            $data['error_public_key_fn' . (string) $i] = '';
        }
        if (isset($this->error['server_action' . (string) $i])) {
            $data['error_server_action' . (string) $i] = $this->error['server_action' . (string) $i];
        } else {
            $data['error_server_action' . (string) $i] = '';
        }
        if (isset($this->error['server_checking' . (string) $i])) {
            $data['error_server_checking' . (string) $i] = $this->error['server_checking' . (string) $i];
        } else {
            $data['error_server_checking' . (string) $i] = '';
        }
        if (isset($this->error['server_control' . (string) $i])) {
            $data['error_server_control' . (string) $i] = $this->error['server_control' . (string) $i];
        } else {
            $data['error_server_control' . (string) $i] = '';
        }
        }
        $data['breadcrumbs'] = array();

        $data['token'] = $this->session->data['token'];

        $data['breadcrumbs'][] = array(
            'text' => $this->language->get('text_home'),
            'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], 'SSL')
        );

        $data['breadcrumbs'][] = array(
            'href' => $this->url->link('extension/payment', 'token=' . $this->session->data['token'], 'SSL'),
            'text' => $this->language->get('text_payment'),
        );

        $data['breadcrumbs'][] = array(
            'href' => $this->url->link('payment/epay', 'token=' . $this->session->data['token'], 'SSL'),
            'text' => $this->language->get('heading_title'),
        );

        $data['action'] = $this->url->link('payment/epay', 'token=' . $this->session->data['token'], 'SSL');

        $data['cancel'] = $this->url->link('extension/payment', 'token=' . $this->session->data['token'], 'SSL');

        // Нижняя граница
        if (isset($this->request->post['epay_total'])) {
            $data['epay_total'] = $this->request->post['epay_total'];
        } else {
            $data['epay_total'] = $this->config->get('epay_total');
        }
        // Mode test or live
        if (isset($this->request->post['epay_mode'])) {
            $data['epay_mode'] = $this->request->post['epay_mode'];
        } else {
            $data['epay_mode'] = $this->config->get('epay_mode');
        }

        // Настройки по договору с kkb
        for ($i = 0; $i < 2; $i++) {
            if (isset($this->request->post['epay_merchant_id' . (string) $i])) {
                $data['epay_merchant_id' . (string) $i] = $this->request->post['epay_merchant_id' . (string) $i];
            } else {
                $data['epay_merchant_id' . (string) $i] = $this->config->get('epay_merchant_id' . (string) $i);
            }

            if (isset($this->request->post['epay_merchant_name' . (string) $i])) {
                $data['epay_merchant_name' . (string) $i] = $this->request->post['epay_merchant_name' . (string) $i];
            } else {
                $data['epay_merchant_name' . (string) $i] = $this->config->get('epay_merchant_name' . (string) $i);
            }

            if (isset($this->request->post['epay_merchant_certificate_id' . (string) $i])) {
                $data['epay_merchant_certificate_id' . (string) $i] = $this->request->post['epay_merchant_certificate_id' . (string) $i];
            } else {
                $data['epay_merchant_certificate_id' . (string) $i] = $this->config->get('epay_merchant_certificate_id' . (string) $i);
            }

            if (isset($this->request->post['epay_private_key_fn' . (string) $i])) {
                $data['epay_private_key_fn' . (string) $i] = $this->request->post['epay_private_key_fn' . (string) $i];
            } else {
                $data['epay_private_key_fn' . (string) $i] = $this->config->get('epay_private_key_fn' . (string) $i);
            }

            if (isset($this->request->post['epay_private_key_pass' . (string) $i])) {
                $data['epay_private_key_pass' . (string) $i] = $this->request->post['epay_private_key_pass' . (string) $i];
            } else {
                $data['epay_private_key_pass' . (string) $i] = $this->config->get('epay_private_key_pass' . (string) $i);
            }

            if (isset($this->request->post['epay_public_key_fn' . (string) $i])) {
                $data['epay_public_key_fn' . (string) $i] = $this->request->post['epay_public_key_fn' . (string) $i];
            } else {
                $data['epay_public_key_fn' . (string) $i] = $this->config->get('epay_public_key_fn' . (string) $i);
            }

            if (isset($this->request->post['epay_server_action' . (string) $i])) {
                $data['epay_server_action' . (string) $i] = $this->request->post['epay_server_action' . (string) $i];
            } else {
                $data['epay_server_action' . (string) $i] = $this->config->get('epay_server_action' . (string) $i);
            }
            if (isset($this->request->post['epay_server_checking' . (string) $i])) {
                $data['epay_server_checking' . (string) $i] = $this->request->post['epay_server_checking' . (string) $i];
            } else {
                $data['epay_server_checking' . (string) $i] = $this->config->get('epay_server_checking' . (string) $i);
            }
            if (isset($this->request->post['epay_server_control' . (string) $i])) {
                $data['epay_server_control' . (string) $i] = $this->request->post['epay_server_control' . (string) $i];
            } else {
                $data['epay_server_control' . (string) $i] = $this->config->get('epay_server_control' . (string) $i);
            }
        }
        // Статус который надо установить после подтверждения заказа и после авторизации банком-эмитентом
        if (isset($this->request->post['epay_check_status_id'])) {
            $data['epay_check_status_id'] = $this->request->post['epay_check_status_id'];
        } else {
            $data['epay_check_status_id'] = $this->config->get('epay_check_status_id');
        }
        // Статус который надо установить после отказа банка принимать карту к оплате
        if (isset($this->request->post['epay_declined_status_id'])) {
            $data['epay_declined_status_id'] = $this->request->post['epay_declined_status_id'];
        } else {
            $data['epay_declined_status_id'] = $this->config->get('epay_declined_status_id');
        }
        // Статус который надо установить после проверки ответа банка на подлинность
        if (isset($this->request->post['epay_error_status_id'])) {
            $data['epay_error_status_id'] = $this->request->post['epay_error_status_id'];
        } else {
            $data['epay_error_status_id'] = $this->config->get('epay_error_status_id');
        }
        // Статус который надо установить после подтверждения оплаты
        if (isset($this->request->post['epay_order_status_id'])) {
            $data['epay_order_status_id'] = $this->request->post['epay_order_status_id'];
        } else {
            $data['epay_order_status_id'] = $this->config->get('epay_order_status_id');
        }
        // Статус который надо установить после отказа магазина принять оплату
        if (isset($this->request->post['epay_canceled_status_id'])) {
            $data['epay_canceled_status_id'] = $this->request->post['epay_canceled_status_id'];
        } else {
            $data['epay_canceled_status_id'] = $this->config->get('epay_canceled_status_id');
        }

        $this->load->model('localisation/order_status');

        $data['check_statuses'] = $this->model_localisation_order_status->getOrderStatuses();
        $data['order_statuses'] = $this->model_localisation_order_status->getOrderStatuses();
        $data['error_statuses'] = $this->model_localisation_order_status->getOrderStatuses();
        $data['declined_statuses'] = $this->model_localisation_order_status->getOrderStatuses();
        $data['canceled_statuses'] = $this->model_localisation_order_status->getOrderStatuses();

        // вкл-выкл комиссию
        if (isset($this->request->post['epay_comission_status_id'])) {
            $data['epay_comission_status_id'] = $this->request->post['epay_comission_status_id'];
        } else {
            $data['epay_comission_status_id'] = $this->config->get('epay_comission_status_id');
        }
        $data['comission_statuses'][] = array(
            'comission_status_id' => 'false',
            'name' => 'Нет'
        );
        $data['comission_statuses'][] = array(
            'comission_status_id' => 'true',
            'name' => 'Да'
        );

        if (isset($this->request->post['epay_geo_zone_id'])) {
            $data['epay_geo_zone_id'] = $this->request->post['epay_geo_zone_id'];
        } else {
            $data['epay_geo_zone_id'] = $this->config->get('epay_geo_zone_id');
        }

        $this->load->model('localisation/geo_zone');

        $data['geo_zones'] = $this->model_localisation_geo_zone->getGeoZones();

        if (isset($this->request->post['epay_status'])) {
            $data['epay_status'] = $this->request->post['epay_status'];
        } else {
            $data['epay_status'] = $this->config->get('epay_status');
        }

        if (isset($this->request->post['epay_sort_order'])) {
            $data['epay_sort_order'] = $this->request->post['epay_sort_order'];
        } else {
            $data['epay_sort_order'] = $this->config->get('epay_sort_order');
        }

        // Сумма, которую вы считаете большой
        if (isset($this->request->post['epay_visa_big_total'])) {
            $data['epay_visa_big_total'] = $this->request->post['epay_visa_big_total'];
        } else {
            $data['epay_visa_big_total'] = $this->config->get('epay_visa_big_total');
        }

        $data['header'] = $this->load->controller('common/header');
        $data['column_left'] = $this->load->controller('common/column_left');
        $data['footer'] = $this->load->controller('common/footer');

        $this->response->setOutput($this->load->view('payment/epay.tpl', $data));
    }

    private function validate() {
        if (!$this->user->hasPermission('modify', 'payment/epay')) {
            $this->error['warning'] = $this->language->get('error_permission');
        }
        for ($i = 0; $i < 2; $i++) {
            if (!$this->request->post['epay_merchant_certificate_id' . (string) $i]) {
                $this->error['merchant_certificate_id' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_private_key_fn' . (string) $i]) {
                $this->error['private_key_fn' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_private_key_pass' . (string) $i]) {
                $this->error['private_key_pass' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_public_key_fn' . (string) $i]) {
                $this->error['public_key_fn' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_merchant_id' . (string) $i]) {
                $this->error['merchant_id' . (string) $i] = $this->language->get('error_merchant_id');
            }
            if (!$this->request->post['epay_merchant_name' . (string) $i]) {
                $this->error['merchant_name' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_server_action' . (string) $i]) {
                $this->error['server_action' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_server_checking' . (string) $i]) {
                $this->error['server_checking' . (string) $i] = $this->language->get('error_empty_field');
            }
            if (!$this->request->post['epay_server_control' . (string) $i]) {
                $this->error['server_control' . (string) $i] = $this->language->get('error_empty_field');
            }
        }
        return !$this->error;
    }

    public function install() {
        $this->load->model('sale/visa_kkb');
        $this->model_sale_visa_kkb->createDatabaseTables();
		// Настройки по договору с kkb          
                $data['epay_merchant_id0'] = '92061101';           
                $data['epay_merchant_id1'] = '92061101';
				
                $data['epay_merchant_name0'] = 'Test Merch';           
                $data['epay_merchant_name1'] = 'Test Merch';  
           
                $data['epay_merchant_certificate_id0'] = '00C182B189';         
                $data['epay_merchant_certificate_id1'] = '00C182B189';
				
                $data['epay_private_key_fn0'] = 'test_prv.pem';         
                $data['epay_private_key_fn1'] = 'test_prv.pem';
         
                $data['epay_private_key_pass0'] = 'nissan';            
                $data['epay_private_key_pass1'] = 'nissan';
				
                $data['epay_public_key_fn0'] = 'kkbca.pem';           
                $data['epay_public_key_fn1'] = 'kkbca.pem';
				
                $data['epay_server_action0'] = 'https://testpay.kkb.kz/jsp/process/logon.jsp';           
                $data['epay_server_action1'] = 'https://epay.kkb.kz/jsp/process/logon.jsp';             
            
                $data['epay_server_checking0'] = 'https://testpay.kkb.kz/jsp/remote/checkOrdern.jsp?';           
                $data['epay_server_checking1'] = 'https://epay.kkb.kz/jsp/remote/checkOrdern.jsp?'; 
          
                $data['epay_server_control0'] = 'https://testpay.kkb.kz/jsp/remote/control.jsp?';           
                $data['epay_server_control1'] = 'https://epay.kkb.kz/jsp/remote/control.jsp?'; 
				
		$this->load->model('setting/setting');
		$this->model_setting_setting->editSetting('epay', $data);	
       
    }

    public function uninstall() {

        $this->load->model('sale/visa_kkb');
        $this->model_sale_visa_kkb->dropDatabaseTables();
    }

}

class ControllerExtensionPaymentEpay extends ControllerPaymentEpay { }
?>