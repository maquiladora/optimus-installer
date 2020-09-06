<?php
header("Access-Control-Allow-Origin: " . $_SERVER['HTTP_ORIGIN']);
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == "OPTIONS")
  die(http_response_code(200));

$token = substr(getallheaders()['Authorization'],7);
include_once 'auth.php';

//APACHE

function is_active($app)
{
  exec('systemctl status ' . $app, $output);
  foreach ($output as $line)
    if (strpos($line, 'active (running)') !== false)
      return 'active';
  return 'inactive';
}

$status['apache']['status'] = is_active('apache2');
$status['mariadb']['status'] = is_active('mariadb');
$status['postfix']['status'] = is_active('postfix');

echo json_encode($status);
?>
