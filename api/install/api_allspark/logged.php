<?php
if (!preg_match("/^https:\/\/v\d+.optimus-avocats.fr$/",$_SERVER['HTTP_ORIGIN']))
{
	header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
	header("Access-Control-Allow-Credentials: true");
	http_response_code(401);
	die(json_encode(array("code" => 401, "message" => "Les requêtes depuis " . $_SERVER['HTTP_ORIGIN'] . " ne sont pas autorisées")));
}
header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

include_once 'auth.php';

http_response_code(200);
die(json_encode(array("code" => 200, "message" => "Successful login")));
?>
