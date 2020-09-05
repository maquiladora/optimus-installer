<?php
$url = parse_url($_SERVER['REQUEST_URI']);
$path = explode('/',$url['path']);

$modules = scandir('.');
foreach ($modules as $module)
  if (is_dir($module) && substr($module,0,4) == 'api_')
    echo include_once . '/index.php';
?>
