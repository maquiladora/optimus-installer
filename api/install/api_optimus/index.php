<?php
if ($path[0] == 'optimus' AND $path[1] == 'contacts')
{
  $contact['id'] = $path[1];
  include_once 'contact.php';
}
?>
