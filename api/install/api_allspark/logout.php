<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Max-Age: 5");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

setcookie("token", "", time() - 3600);
?>
