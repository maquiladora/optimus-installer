<?php
$url = parse_url($_SERVER['REQUEST_URI']);
$path = explode('/',$url['path']);

$modules = scandir('.');
foreach ($modules as $module)
    echo $module . '/index.php';
?>
