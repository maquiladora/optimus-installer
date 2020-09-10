<?php
include_once 'config.php';
include_once 'JWT.php';
use allspark\JWT\JWT;

$headers = getallheaders();
if ($headers['Authorization'])
  $token = str_replace('Bearer ','', $headers['Authorization']);
elseif ($_COOKIE['token'])
  $token = $_COOKIE['token'];
else
{
  http_response_code(401);
  echo json_encode(array("message" => "Access denied"));
  exit;
}

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
?>
