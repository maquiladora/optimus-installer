<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: GET, PUT, DELETE, PATCH, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

include_once 'config.php';
include_once 'connect.php';
include_once 'api_allspark/auth.php';
include_once 'api_optimus/classes/contacts.php';

$database = new Database();
$db = $database->getConnection();

if ($_SERVER['REQUEST_METHOD']=='GET')
  $data = json_decode(urldecode($_GET['data']));
else
  $data = json_decode(file_get_contents("php://input"));

if ($data->id OR $_SERVER['REQUEST_METHOD']=='PUT')
  $contacts = new contact($db);
else
  $contacts = new contacts($db);

if ($_SERVER['REQUEST_METHOD']=='GET')
  $result = $contacts->list($data,$payload);

if ($_SERVER['REQUEST_METHOD']=='PUT')
  $result = $contacts->create($data,$payload);

if ($_SERVER['REQUEST_METHOD']=='DELETE')
  $result = $contacts->delete($data,$payload);

if ($_SERVER['REQUEST_METHOD']=='PATCH')
  $result = $contacts->update($data,$payload);

http_response_code($result['code']);
echo json_encode($result);
?>
