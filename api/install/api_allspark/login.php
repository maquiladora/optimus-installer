<?php
header("Access-Control-Allow-Origin: https://www.demoptimus.fr");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, Accept, Origin");

include_once 'config.php';
include_once 'connect.php';
include_once 'api_allspark/user.php';

$database = new Database();
$db = $database->getConnection();
$user = new User($db);
$data = json_decode(file_get_contents("php://input"));

echo $user->password;
http_response_code(200);

$user->email = $data->email;
$email_exists = $user->emailExists();



include_once 'JWT.php';
use allspark\JWT\JWT;

if($email_exists && openssl_encrypt($data->password, 'aes-128-ecb', $aes_key) == base64_encode($user->password))
{
    http_response_code(200);

    $jwt = new JWT($sha_key, 'HS512', 3600, 10);
    $token = $jwt->encode(["user" => array("id" => $user->id, "email" => $user->email), "aud" => "http://$domain", "scopes" => ['user'], "iss" => "http://$domain"]);
    echo json_encode(array("message" => "Successful login", "token" => $token));
}
else
{
   http_response_code(401);
   echo json_encode(array("message" => "Login failed"));
}
?>
