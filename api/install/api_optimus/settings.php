<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 1");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

include_once 'config.php';
include_once 'connect.php';
include_once 'api_allspark/auth.php';
$data->user = $payload['user']->email;

$database = new Database();
$db = $database->getConnection();

if (@$data->id OR $_SERVER['REQUEST_METHOD']=='PUT')
{
  include_once 'api_optimus/classes/setting.php';
  $dossiers = new setting($db);
}
else
{
  include_once 'api_optimus/classes/settings.php';
  $dossiers = new settings($db);
}

if ($_SERVER['REQUEST_METHOD']=='GET')
  $result = $dossiers->read($data);
if ($_SERVER['REQUEST_METHOD']=='POST')
  $result = $dossiers->create($data);
if ($_SERVER['REQUEST_METHOD']=='PUT')
  $result = $dossiers->replace($data);
if ($_SERVER['REQUEST_METHOD']=='PATCH')
  $result = $dossiers->modify($data);
if ($_SERVER['REQUEST_METHOD']=='DELETE')
  $result = $dossiers->delete($data);

http_response_code($result['code']);
echo json_encode($result);
?>
