<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, MOVE, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

include_once 'config.php';
include_once 'connect.php';
include_once 'api_allspark/auth.php';
include_once 'api_optimus/classes/dossier.php';

$database = new Database();
$db = $database->getConnection();
$dossier = new dossier($db);
$data = json_decode(file_get_contents("php://input"));

if ($_SERVER['REQUEST_METHOD']=='PUT')
{
  $result = $dossier->create($data);
  if ($result)
  {
    http_response_code(201);
    echo json_encode(array("code" => 201, "data" => $result));
  }
  else
  {
    http_response_code(400);
    echo json_encode(array("code" => 400, "message" => $result));
  }
}

if ($_SERVER['REQUEST_METHOD']=='MOVE')
{
  $result = $dossier->rename($data);
  if ($result)
  {
    http_response_code(200);
    echo json_encode(array("code" => 200, "data" => $result));
  }
  else
  {
    http_response_code(400);
    echo json_encode(array("code" => 400, "message" => $result));
  }
}




?>
