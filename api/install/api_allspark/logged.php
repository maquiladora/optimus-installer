<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

include_once 'auth.php';

http_response_code(200)
die(json_encode(array("code" => 200, "message" => "Successful login")));
?>
