<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 5");
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

$status['services'][0]['name'] = 'Apache';
$status['services'][0]['status'] = get_status('apache2');
$status['services'][0]['version'] = get_version('apache2');
$status['services'][1]['name'] = 'PHP';
$status['services'][1]['status'] = get_status('php');
$status['services'][1]['version'] = get_version('php');
$status['services'][2]['name'] = 'Maria DB';
$status['services'][2]['status'] = get_status('mariadb-server');
$status['services'][2]['version'] = get_version('mariadb-server');
$status['services'][3]['name'] = 'Postfix';
$status['services'][3]['status'] = get_status('postfix');
$status['services'][3]['version'] = get_version('postfix');
$status['services'][4]['name'] = 'Dovecot';
$status['services'][4]['status'] = get_status('dovecot');
$status['services'][4]['version'] = get_version('dovecot-core');
$status['services'][5]['name'] = 'SpamAssassin';
$status['services'][5]['status'] = get_status('spamassassin');
$status['services'][5]['version'] = get_version('spamassassin');
$status['services'][6]['name'] = 'Spamassassin Milter';
$status['services'][6]['status'] = get_status('spamass-milter');
$status['services'][6]['version'] = get_version('spamass-milter');
$status['services'][7]['name'] = 'Clamav Milter';
$status['services'][7]['status'] = get_status('clamav-milter');
$status['services'][7]['version'] = get_version('clamav-milter');
$status['services'][8]['name'] = 'Rdiff Backup';
$status['services'][8]['status'] = get_status('rdiff-backup');
$status['services'][8]['version'] = get_version('rdiff-backup');
$status['services'][9]['name'] = 'Certbot';
$status['services'][9]['status'] = get_status('certbot');
$status['services'][9]['version'] = get_version('certbot');
$status['services'][10]['name'] = 'Roundcube Webmail';
$status['services'][10]['version'] = shell_exec ("cat /srv/webmail/CHANGELOG | grep 'RELEASE' | head -1 | cut -c 9- | head -c -1");
$status['services'][11]['name'] = 'SabreDAV';
$status['services'][11]['version'] = shell_exec ("cat /srv/cloud/vendor/sabre/dav/CHANGELOG.md | head -4 | tail -1 | cut -f1 -d' ' | head -c -1");

$status['cpu']['usage'] = shell_exec("top -n 1 -b | awk '/^%Cpu/{print $2}'");

$status['memory']['usage'] = shell_exec("free | grep Mem | awk '{print $3/$2 * 100.0}'");


http_response_code(200);
echo json_encode(array("code" => 200, "data" => $status));
?>
