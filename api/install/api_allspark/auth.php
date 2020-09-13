<?php
include_once 'config.php';
include_once 'JWT.php';
use allspark\JWT\JWT;

if (isset(getallheaders()['Authorization']))
  $token = str_replace('Bearer ','', getallheaders()['Authorization']);
elseif (isset($_COOKIE['token']))
  $token = $_COOKIE['token'];
else
{
  http_response_code(401);
  echo json_encode(array("code" => 401, "message" => "Access denied", "error" => "No Token"));
  exit;
}

try
{
    $payload = (new JWT($sha_key, 'HS512', 3600, 10))->decode($token);
}
catch (Throwable $e)
{
    http_response_code(401);
    echo json_encode(array("code" => 401, "message" => "Access denied", "error" => $e->getMessage()));
    exit;
}
?>
