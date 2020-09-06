<?php
header("Access-Control-Allow-Origin: " . $_SERVER['SERVER_NAME']);
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == "OPTIONS")
  die(http_response_code(200));

$token = substr(getallheaders()['Authorization'],7);
include_once 'auth.php';

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
  exec("dpkg -s " . $app . " | grep '^Version:' | cut -c 10- | cut -f1 -d'-' | cut -f1 -d'+' | cut -f2 -d':'", $output);
  if ($output[0])
    return $output[0];
}

$status['apache']['status'] = get_status('apache2');
$status['apache']['version'] = get_version('apache2');
$status['php']['status'] = get_status('php');
$status['php']['version'] = get_version('php');
$status['mariadb']['status'] = get_status('mariadb');
$status['mariadb']['version'] = get_version('mariadb');
$status['postfix']['status'] = get_status('postfix');
$status['postfix']['version'] = get_version('postfix');
$status['dovecot-core']['status'] = get_status('dovecot-core');
$status['dovecot-core']['version'] = get_version('dovecot-core');
$status['spamass-milter']['status'] = get_status('spamass-milter');
$status['spamass-milter']['version'] = get_version('spamass-milter');
$status['clamav-milter']['status'] = get_status('clamav-milter');
$status['clamav-milter']['version'] = get_version('clamav-milter');
$status['rdiff-backup']['status'] = get_status('rdiff-backup');
$status['rdiff-backup']['version'] = get_version('rdiff-backup');

echo json_encode(array("message" => "", "response" => $status));
?>
