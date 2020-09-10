<?php
include_once 'config.php';
include_once 'JWT.php';
use allspark\JWT\JWT;

$token = str_replace('Bearer ','', getallheaders()['Authorization'])?$_COOKIE['token'];

if($token)
{
  try
  {
      $payload = (new JWT($sha_key, 'HS512', 3600, 10))->decode($token);
  }
  catch (Throwable $e)
  {
      http_response_code(401);
      echo json_encode(array("message" => "Access denied", "error" => $e->getMessage()));
      exit;
  }
}
else
{
  http_response_code(401);
  echo json_encode(array("message" => "Access denied"));
  exit;
}
?>
