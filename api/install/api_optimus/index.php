<?php
if ($path[2] == 'contact')
{
  $contact['id'] = $path[3];
  include_once 'contact.php';
}
else if ($path[2] == 'dossier')
{
  if ($path[3])
    $dossier['id'] = $path[3];
  include_once 'dossier.php';
}

?>
