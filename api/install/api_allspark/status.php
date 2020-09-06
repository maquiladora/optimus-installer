<?php
header("Access-Control-Allow-Origin: " . $_SERVER['SERVER_NAME']);
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == "OPTIONS")
  die(http_response_code(200));

$token = substr(getallheaders()['Authorization'],7);
include_once 'auth.php';

//APACHE

function get_status($app)
{
  exec('systemctl status ' . $app, $output);
  foreach ($output as $line)
    if (strpos($line, 'Active: active') !== false)
      return 'active';
  return 'inactive';
}

function get_version($app)
{
  return system("dpkg -s " . $app . " | grep '^Version:' | cut -c 10- | cut -f1 -d'-' | cut -f1 -d'+' | cut -f2 -d':'");
}

$status['apache']['status'] = get_status('apache2');
$status['apache']['version'] = get_version('apache2');
$status['apache']['status'] = get_status('php');
$status['apache']['version'] = get_version('php');
$status['apache']['status'] = get_status('mariadb');
$status['apache']['version'] = get_version('mariadb');
$status['apache']['status'] = get_status('postfix');
$status['apache']['version'] = get_version('postfix');
$status['apache']['status'] = get_status('dovecot-core');
$status['apache']['version'] = get_version('dovecot-core');
$status['apache']['status'] = get_status('spamassassin');
$status['apache']['version'] = get_version('spamassassin');
$status['apache']['status'] = get_status('clamav');
$status['apache']['version'] = get_version('clamav');
$status['apache']['status'] = get_status('rdiff-backup');
$status['apache']['version'] = get_version('rdiff-backup');

echo json_encode(array("message" => "", "response" => $status));
?>
