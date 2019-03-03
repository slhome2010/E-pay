<?php

class ModelExtensionPaymentEpay extends Model {

    public function getMethod($address, $total) {
        $this->load->language('extension/payment/epay');

        $query = $this->db->query("SELECT * FROM " . DB_PREFIX . "zone_to_geo_zone WHERE geo_zone_id = '" . (int) $this->config->get('epay_geo_zone_id') . "' AND country_id = '" . (int) $address['country_id'] . "' AND (zone_id = '" . (int) $address['zone_id'] . "' OR zone_id = '0')");

        if ($this->config->get('epay_total') > 0 && $this->config->get('epay_total') > $total) {
            $status = false;
        } elseif (!$this->config->get('epay_geo_zone_id')) {
            $status = true;
        } elseif ($query->num_rows) {
            $status = true;
        } else {
            $status = false;
        }

        $method_data = array();

        if ($status) {
            $method_data = array(
                'code' => 'epay',
                'title' => $this->language->get('text_title'),
                'terms' => '',
                'sort_order' => $this->config->get('epay_sort_order')
            );
        }

        return $method_data;
    }

    public function addVisa($data) {
        $this->db->query("INSERT INTO `" . DB_PREFIX . "visa_kkb` SET transaction_status = '" . $this->db->escape($data['transaction_status']) . "',
		order_id = '" . (int) $data['order_id'] . "',
		customer_reference = '" . $this->db->escape($data['customer_reference']) . "',
		total = '" . (float) $data['total'] . "',
                approval_code = '" . $data['approval_code'] . "',
                card_number = '" . $data['card_number'] . "',
                card_country = '" . $data['card_country'] . "',
                verified3d = '" . $data['verified3d'] . "',
                comment = '" . $data['comment'] . "',
		date_added = NOW()");

        $visa_id = $this->db->getLastId();

        return $visa_id;
    }

    public function addVisaToOrder($visa_id, $order_id) {
        $this->db->query("UPDATE `" . DB_PREFIX . "order` SET visa_kkb_id = '" . (int) $visa_id . "' WHERE order_id = '" . (int) $order_id . "'");

        return true;
    }

    public function editVisa($data) {
        $this->db->query("UPDATE`" . DB_PREFIX . "visa_kkb` SET transaction_status = '" . $this->db->escape($data['transaction_status']) . "',
		customer_reference = '" . $this->db->escape($data['customer_reference']) . "',
		date_added = NOW() WHERE order_id = '" . (int) $data['order_id'] . "'");

        $visa_id = $this->db->getLastId();

        return $visa_id;
    }

    public function getVisaByOrder($order_id) {
        $sql = "SELECT o.order_id, CONCAT(o.firstname, ' ', o.lastname) AS customer,
		(SELECT os.name FROM " . DB_PREFIX . "order_status os WHERE os.order_status_id = o.order_status_id AND os.language_id = '" . (int) $this->config->get('config_language_id') . "') AS status,
		(SELECT vs.customer_reference FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS customer_reference,
		(SELECT vs.transaction_status FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS transaction_status,
		(SELECT vs.card_country FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS card_country,
		(SELECT vs.card_number FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS card_number,
		(SELECT vs.verified3d FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS verified3d,
		(SELECT vs.ip_address FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS ip_address,
                (SELECT vs.comment FROM " . DB_PREFIX . "visa_kkb vs WHERE vs.visa_id = o.visa_kkb_id) AS comment,
		o.total, o.currency_code, o.currency_value, o.date_added, o.date_modified, o.visa_kkb_id FROM `" . DB_PREFIX . "order` o";

        $sql .= " WHERE o.order_id = '" . (int) $order_id . "'";


        $query = $this->db->query($sql);

        return $query->row;
    }

}

?>