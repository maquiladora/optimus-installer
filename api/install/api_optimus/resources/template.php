<?php
function read($db,$data)
{
  //200 OK
  //201 CREATED
  //404 NOT FOUND
  //405 NOT ALLOWED
  //409 CONFLICT
  //501 NOT IMPLEMENTED
  //return array("code" => int, "message" => text, "data" => array, "authorizations" => array);

  //SANITIZE USER DATA INPUTS
  //CHECK AUTHORIZATIONS
  //PREPARE
  //BIND
  //EXECUTE
  //FETCH
  //RETURN CODE, MESSAGE, RESULT, AUTHORIZATIONS
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function create($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function replace($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function update($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function delete($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}
?>
