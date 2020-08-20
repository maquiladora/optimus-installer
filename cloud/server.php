<?php
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS' AND (strpos($_SERVER['HTTP_USER_AGENT'],'davfs')!=FALSE OR strpos($_SERVER['HTTP_USER_AGENT'],'Microsoft-WebDAV')!=FALSE OR strpos($_SERVER['HTTP_USER_AGENT'],'Chrome')!=FALSE OR strpos($_SERVER['HTTP_USER_AGENT'],'Dictate')!=FALSE))
{
	header("Access-Control-Allow-Origin: https://optimus.$DOMAIN");
	header("Access-Control-Allow-Credentials: true");
	header("Access-Control-Allow-Methods: OPTIONS,GET,HEAD,DELETE,PROPFIND,PUT,PROPPATCH,COPY,MOVE,REPORT,MKCOL,POST,LOCK,UNLOCK");
	header("Access-Control-Allow-Headers: Authorization, Digest, Content-Type, Credentials, Depth, Destination, Overwrite, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control, Access-Control-Allow-Headers, Authorization, X-Requested-With");
  header('Access-Control-Max-Age: 3600');
  exit;
}
else
{
	header("Access-Control-Allow-Origin: https://optimus.$DOMAIN");
	header("Access-Control-Allow-Credentials: true");
	header("Access-Control-Allow-Headers: Authorization, Digest, Content-Type, Credentials, Depth, Destination, Overwrite, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control, Access-Control-Allow-Headers, Authorization, X-Requested-With");
}
error_reporting(E_ALL);
require('/srv/cloud/vendor/autoload.php');

$pdo = new \PDO('mysql:dbname=cloud','$CLOUD_MARIADB_USER','$CLOUD_MARIADB_PASSWORD');
$pdo->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);

function exception_error_handler($errno, $errstr, $errfile, $errline) {
    throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
}
set_error_handler("exception_error_handler");

$authBackend = new Optimus\DAV\Auth\Backend\PDO($pdo);
$authBackend->setRealm('OPTIMUS');
$principalBackend = new Optimus\DAVACL\PrincipalBackend\PDO($pdo);
$caldavBackend = new Sabre\CalDAV\Backend\PDO($pdo);
$carddavBackend   = new Optimus\CardDAV\Backend\PDO($pdo);
$lockBackend = new Sabre\DAV\Locks\Backend\PDO($pdo);
$storageBackend = new Sabre\DAV\PropertyStorage\Backend\PDO($pdo);


$nodes = [
	new Sabre\DAVACL\PrincipalCollection($principalBackend),
	new Optimus\DAVACL\FS\HomeCollection($principalBackend, '/srv/files'),
	new Sabre\CalDAV\CalendarRoot($principalBackend, $caldavBackend),
	new Sabre\CardDAV\AddressBookRoot($principalBackend, $carddavBackend),
];

$server = new Sabre\DAV\Server($nodes);
//$server->setBaseUri('/');

$server->addPlugin(new Sabre\DAV\Auth\Plugin($authBackend));
$server->addPlugin(new Sabre\DAV\Locks\Plugin($lockBackend));
$server->addPlugin(new Sabre\DAV\PropertyStorage\Plugin($storageBackend));
$server->addPlugin(new Sabre\DAV\Browser\Plugin());
//$server->addPlugin(new Sabre\DAV\Browser\GuessContentType());
$server->addPlugin(new Sabre\DAV\Sharing\Plugin());
$server->addPlugin(new Sabre\DAV\Sync\Plugin());
$server->addPlugin(new Sabre\CalDAV\Plugin());
$server->addPlugin(new Sabre\CalDAV\Schedule\Plugin());
$server->addPlugin(new Sabre\CalDAV\SharingPlugin());
$server->addPlugin(new Sabre\CalDAV\ICSExportPlugin());
$server->addPlugin(new Sabre\CardDAV\Plugin());
$server->addPlugin(new Sabre\CardDAV\VCFExportPlugin());


$aclPlugin = new Sabre\DAVACL\Plugin();
$aclPlugin->allowAccessToNodesWithoutACL = false;
$aclPlugin->hideNodesFromListings = true;
$aclPlugin->adminPrincipals[] = 'principals/prime@$DOMAIN';
$server->addPlugin($aclPlugin);

$server->exec();
?>
