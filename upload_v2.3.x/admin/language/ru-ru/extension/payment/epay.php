<?php

// Heading
$_['heading_title'] = '<b style="color: #FCBA24;"> E</b><span style="color: #008CB0;">pay</span>';

// Tab
$_['tab_test']           = 'Тестовый';
$_['tab_live']          = 'Боевой';
$_['tab_support']      = 'Поддержка';

// Text
$_['text_edit'] = 'Настройки модуля';
$_['text_payment'] = 'Оплата';
$_['text_success'] = 'Настройки модуля обновлены!';
$_['text_epay'] = '<a target="_BLANK" href="https://epay.kkb.kz/"><img src="view/image/payment/tn_epay.png" alt="Сайт платежной системы epay.kkb.kz" title="Сайт платежной системы epay.kkb.kz" style="border: 1px solid #EEEEEE; height: 40px;" /></a>';

// Entry
$_['entry_total'] = 'Нижняя граница';
$_['entry_merchant_id'] = 'ID продавца';
$_['entry_merchant_name'] = 'Название магазина (продавца)';
$_['entry_merchant_certificate_id'] = 'Серийный номер сертификата';
$_['entry_private_key_fn'] = 'Файл с закрытым ключом';
$_['entry_private_key_pass'] = 'Пароль к закрытому ключу';
$_['entry_public_key_fn'] = 'Файл с открытым ключом';
$_['entry_server_action'] = 'Сервер ККБ';
$_['entry_server_checking'] = 'Сервер удаленного контроля';
$_['entry_server_control'] = 'Сервер удаленного управления';

$_['entry_check_status'] = 'Статус заказа после авторизации карты банком:';
$_['entry_error_status'] = 'Статус в случае ошибки проверки подписи и сертификатов:';
$_['entry_order_status'] = 'Статус заказа после оплаты:';
$_['entry_declined_status'] = 'Статус в случае отказа банка принимать карту к оплате:';
$_['entry_canceled_status'] = 'Статус если оплата не принята магазином:';
$_['entry_comission_status'] = 'Включить комиссию платежной системы в чек Epay:';
$_['entry_geo_zone'] = 'Гео. Зона:';

$_['entry_status'] = 'Состояние:';
$_['entry_sort_order'] = 'Порядок сортировки';
$_['entry_apikey'] = 'Ключ для GeoIP в сервисе http://ipinfodb.com/:';
$_['entry_visa_big_total'] = 'Большая сумма заказа для повышенного внимания:';

// Error
$_['error_permission'] = 'У Вас нет прав для изменения модуля!';
$_['error_merchant_id'] = 'Неверный ID продавца!';
$_['error_empty_field'] = 'Это поле обязательно надо заполнить!';

// Help
$_['help_total'] = 'Минимальная сумма заказа. Ниже данной суммы, способ оплаты будет недоступен.';
$_['help_path'] = 'Файл должен находиться в папке /system/library/epay.';
?>