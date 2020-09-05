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
include_once 'core.php';
include_once 'libs/php-jwt/src/BeforeValidException.php';
include_once 'libs/php-jwt/src/ExpiredException.php';
include_once 'libs/php-jwt/src/SignatureInvalidException.php';
include_once 'libs/php-jwt/src/JWT.php';
use \Firebase\JWT\JWT;

// check if email exists and if password is correct
if($email_exists && openssl_encrypt($data->password, 'aes-128-ecb', '$AES_KEY') == $user->password)
{
    $token = array(
       "iss" => $iss,
       "aud" => $aud,
       "iat" => $iat,
       "nbf" => $nbf,
       "data" => array("id" => $user->id, "email" => $user->email)
    );

    http_response_code(200);

    $jwt = JWT::encode($token, $key);
    echo json_encode(array("message" => "Successful login.", "jwt" => $jwt));
}
else
{
   http_response_code(401);
   echo json_encode(array("message" => "Login failed.", "pass" => 'op->' . base64_encode($user->password)));
}
?>
