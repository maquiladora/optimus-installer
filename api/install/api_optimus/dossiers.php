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
include_once 'api_optimus/classes/dossiers.php';

$database = new Database();
$db = $database->getConnection();


if ($_SERVER['REQUEST_METHOD']=='GET')
  $data = json_decode(urldecode($_GET['data']));
else
  $data = json_decode(file_get_contents("php://input"));


if (@$path[3])
  if (!is_int(@$path[3]))
  {
    http_response_code(400);
    die(json_encode(array("code" => 400, "message" => "Identifiant non valude")));
  }
  else
    $data->id = intval($path[3]);


if ($data->id OR $_SERVER['REQUEST_METHOD']=='PUT')
  $dossiers = new dossier($db);
else
  $dossiers = new dossiers($db);


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
