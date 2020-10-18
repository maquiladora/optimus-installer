<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: GET, PUT, DELETE, MOVE, PATCH, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

include_once 'config.php';
include_once 'connect.php';
include_once 'api_allspark/auth.php';

$database = new Database();
$db = $database->getConnection();

if ($data->id OR $_SERVER['REQUEST_METHOD']=='PUT')
{
  include_once 'api_optimus/classes/dossier.php';
  $dossiers = new dossier($db);
}
else
{
  include_once 'api_optimus/classes/dossiers.php';
  $dossiers = new dossiers($db);
}

if ($_SERVER['REQUEST_METHOD']=='GET')
  $result = $dossiers->list($data,$payload);
if ($_SERVER['REQUEST_METHOD']=='PUT')
  $result = $dossiers->create($data,$payload);
if ($_SERVER['REQUEST_METHOD']=='MOVE')
  $result = $dossiers->rename($data,$payload);
if ($_SERVER['REQUEST_METHOD']=='DELETE')
  $result = $dossiers->delete($data,$payload);
if ($_SERVER['REQUEST_METHOD']=='PATCH')
  $result = $dossiers->update($data,$payload);

http_response_code($result['code']);
echo json_encode($result);
?>
