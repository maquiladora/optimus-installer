<?php
function read($data)
{
  //200 OK
  //404 NOT FOUND
  //405 NOT ALLOWED
  //409 CONFLICT
  //501 NOT IMPLEMENTED
  //return array("code" => int, "message" => text, "data" => array, "authorizations" => array);

  //VALIDATE USER DATA INPUTS
  //CHECK AUTHORIZATIONS
  //EXECUTE COMMAND
  //RETURN CODE, MESSAGE, RESULT, AUTHORIZATIONS
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function create($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function replace($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function update($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function delete($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}
?>
