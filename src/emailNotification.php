<?php
require_once(__DIR__ . '/../vendor/autoload.php');

// Configure API key authorization: api-key
$config = Brevo\Client\Configuration::getDefaultConfiguration()->setApiKey('api-key', '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 ');
// Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
// $config = Brevo\Client\Configuration::getDefaultConfiguration()->setApiKeyPrefix('api-key', 'Bearer');
// Configure API key authorization: partner-key
//$config = Brevo\Client\Configuration::getDefaultConfiguration()->setApiKey('partner-key', 'YOUR_API_KEY');
// Uncomment below to setup prefix (e.g. Bearer) for API key, if needed
// $config = Brevo\Client\Configuration::getDefaultConfiguration()->setApiKeyPrefix('partner-key', 'Bearer');

//$backup_file = "/home/x3c2p7q7ry12/backup_databases/files/respaldo_".date("YmdHis").'.sql.gz';

$backup_file = '/var/www/acalsa-respaldos/src/ejemplo.txt';

//$command = "mysqldump --no-tablespaces -u ikigai -p'YUwf$;M#Gp,S' --all-databases | gzip > $backup_file";
//shell_exec($command);

echo "dormir " . date("s");
sleep(15);
echo "despertar " . date("s");

$apiInstance = new Brevo\Client\Api\TransactionalEmailsApi(
// If you want use custom http client, pass your client which implements `GuzzleHttp\ClientInterface`.
// This is optional, `GuzzleHttp\Client` will be used as default.
    new GuzzleHttp\Client(),
    $config
);
$sendSmtpEmail = new \Brevo\Client\Model\SendSmtpEmail([
    'subject' => 'Respaldo Base de Datos',
    'sender' => ['name' => 'Acalsa - Respaldos', 'email' => 'respalsod@acalsa.com'],
    'replyTo' => ['name' => 'No Respoder', 'email' => 'no-responder@acalsa.com'],
    'to' => [['name' => 'Alcalsa', 'email' => 'acalsasistema@gmail.com']],
    'htmlContent' => '<html><body><h1>REspaldo, por favor descargalo</h1></body></html>',
    'params' => ['bodyMessage' => 'Acalsa'],
    'attachment' => $backup_file,
]);

try {
    $result = $apiInstance->sendTransacEmail($sendSmtpEmail);
    print_r($result);

} catch (Exception $e) {
    echo 'Exception when calling AccountApi->getAccount: ', $e->getMessage(), PHP_EOL;
}

?>