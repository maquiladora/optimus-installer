<?php
$url = parse_url($_SERVER['REQUEST_URI']);
$path = explode('/',$url['path']);

$modules = scandir();
foreach ($modules as $module)
  if (substr($module,0,4) == 'api_')
    include_once $module . '/index.php';
?>
