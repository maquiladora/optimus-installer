<?php
header("Access-Control-Allow-Origin: $_SERVER['HTTP_ORIGIN']");
header("Access-Control-Allow-Methods: GET, HEAD, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once 'config.php';
include_once 'connect.php';
include_once 'api_allspark/user.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);
$data = json_decode(file_get_contents("php://input"));

$user->email = $data->email;
$email_exists = $user->emailExists();

include_once 'JWT.php';
use allspark\JWT\JWT;

if ($email_exists && openssl_encrypt($data->password, 'aes-128-ecb', $aes_key) == base64_encode($user->password))
{
    http_response_code(200);
    $jwt = new JWT($sha_key, 'HS512', 3600, 10);
    $token = $jwt->encode(["user" => array("id" => $user->id, "email" => $user->email), "aud" => "http://$domain", "scopes" => ['user'], "iss" => "http://$domain"]);
    echo json_encode(array("message" => "Successful login", "token" => $token));
}
else {
  http_response_code(401);
  echo json_encode(array("message" => "Login failed"));
}
?>
