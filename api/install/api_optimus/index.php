<?php
print_r($path);
if ($path[1] == 'contacts')
{
  print_r($path);
  $contact['id'] = $path[2];
  include_once 'contact.php';
}
?>
