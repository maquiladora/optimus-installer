<?php
// required headers
header("Access-Control-Allow-Origin: http://localhost/rest-api-authentication-example/");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// database connection will be here
// files needed to connect to database
include_once 'connect.php';
include_once 'user.php';

// get database connection
$database = new Database();
$db = $database->getConnection();

// instantiate user object
$user = new User($db);


$data = json_decode(file_get_contents("php://input"));
$user->email = $data->email;
$email_exists = $user->emailExists();

// files for jwt will be here
include_once 'JWT.php';
include_once 'JWT_validation.php';
use allspark\JWT\JWT;

// check if email exists and if password is correct
if($email_exists && openssl_encrypt($data->password, 'aes-128-ecb', '$AES_KEY') == base64_encode($user->password))
{
    $token = array(
       "iss" => $iss,
       "aud" => $aud,
       "iat" => $iat,
       "nbf" => $nbf,
       "data" => array("id" => $user->id, "email" => $user->email)
    );

    http_response_code(200);

    $jwt = new JWT('secret', 'HS512', 3600, 10);
    $token = $jwt->encode(["user" => array("id" => $user->id, "email" => $user->email), 'aud' => 'http://$DOMAIN', 'scopes' => ['user'], 'iss' => 'http://$DOMAIN']);

    echo json_encode(array("message" => "Successful login", "jwt" => $token));
}
else
{
   http_response_code(401);
   echo json_encode(array("message" => "Login failed"));
}
?>
