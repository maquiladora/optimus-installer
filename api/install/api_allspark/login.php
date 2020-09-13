<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

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
    $jwt = new JWT($sha_key, 'HS512', 3600, 10);
    $token = $jwt->encode(["user" => array("id" => $user->id, "email" => $user->email), "aud" => "http://$domain", "scopes" => ['user'], "iss" => "http://$domain"]);
    $cookie_options = array ('expires' => time() + 3600, 'path' => '/', 'domain' => $domain, 'secure' => true, 'httponly' => true, 'samesite' => 'None');
    setcookie('token', $token, $cookie_options);
    http_response_code(200);
    echo json_encode(array("code" => 200, "message" => "Successful login"));
}
else
{
   http_response_code(401);
   echo json_encode(array("code" => 401, "message" => "Login failed"));
}
?>
