<?php
if ($path[2] == 'login')
  include_once 'login.php';
else if ($path[2] == 'logout')
  include_once 'logout.php';
  else if ($path[2] == 'logged')
    include_once 'logged.php';
else if ($path[2] == 'status')
  include_once 'status.php';
?>
