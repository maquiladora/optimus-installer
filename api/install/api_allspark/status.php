<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Access-Control-Allow-Headers, Authorization, X-Requested-With");
echo json_encode( getallheaders());
echo json_encode($_COOKIE);
echo json_encode($_SERVER);
echo file_get_contents("php://input");
exit;

if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

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
  return shell_exec ("dpkg -s " . $app . " | grep '^Version:' | cut -c 10- | cut -f1 -d'-' | cut -f1 -d'+' | cut -f2 -d':' | head -c -1");
}

$status['apache']['status'] = get_status('apache2');
$status['apache']['version'] = get_version('apache2');
$status['php']['status'] = get_status('php');
$status['php']['version'] = get_version('php');
$status['mariadb']['status'] = get_status('mariadb-server');
$status['mariadb']['version'] = get_version('mariadb-server');
$status['postfix']['status'] = get_status('postfix');
$status['postfix']['version'] = get_version('postfix');
$status['dovecot']['status'] = get_status('dovecot');
$status['dovecot']['version'] = get_version('dovecot-core');
$status['spamassassin']['status'] = get_status('spamassassin');
$status['spamassassin']['version'] = get_version('spamassassin');
$status['spamass-milter']['status'] = get_status('spamass-milter');
$status['spamass-milter']['version'] = get_version('spamass-milter');
$status['clamav-milter']['status'] = get_status('clamav-milter');
$status['clamav-milter']['version'] = get_version('clamav-milter');
$status['rdiff-backup']['status'] = get_status('rdiff-backup');
$status['rdiff-backup']['version'] = get_version('rdiff-backup');
$status['certbot']['status'] = get_status('certbot');
$status['certbot']['version'] = get_version('certbot');
$status['roundcube']['version'] = shell_exec ("cat /srv/webmail/CHANGELOG | grep 'RELEASE' | head -1 | cut -c 9- | head -c -1");
$status['sabredav']['version'] = shell_exec ("cat /srv/cloud/vendor/sabre/dav/CHANGELOG.md | head -4 | tail -1 | cut -f1 -d' ' | head -c -1");

echo json_encode($status);

?>
