<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once 'config.php';

include_once 'JWT_validation.php';
include_once 'JWT.php';
use allspark\JWT\JWT;

$data = json_decode(file_get_contents("php://input"));

$token = isset($data->token) ? $data->token : "";

if($token)
{
  try
  {
      $payload = (new JWT($sha_key, 'HS512', 3600))->decode($token);
      http_response_code(200);
      echo json_encode(array("message" => "Access granted","payload" => $payload->data));
  }
  catch (Exception $e)
  {
      http_response_code(401);
      echo json_encode(array("message" => "Access denied","error" => $e->getMessage()));
  }
}
else
{
  http_response_code(401);
  echo json_encode(array("message" => "Access denied"));
}
?>
