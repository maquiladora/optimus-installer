<?php
if ($path[2] == 'auth')
  include_once 'auth.php';
else if ($path[2] == 'login')
  include_once 'login.php';
else if ($path[2] == 'status')
  include_once 'status.php';
?>
