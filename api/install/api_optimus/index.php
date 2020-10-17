<?php
if ($path[2] == 'contact')
  include_once 'contact.php';
else if ($path[2] == 'dossier')
  include_once 'dossier.php';
else if ($path[3] == 'authorization')
  include_once 'authorization.php';

?>
