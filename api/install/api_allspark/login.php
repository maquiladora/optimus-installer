<?php
http_response_code(200);
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
//$user = new User($db);
$data = json_decode(file_get_contents("php://input"));

//$user->email = $data->email;
//$email_exists = $user->emailExists();

include_once 'JWT.php';
use allspark\JWT\JWT;

if($data->password == 'W26b3RTE8mj4L3Su6GJBjz0qXtPIcNaM')
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
