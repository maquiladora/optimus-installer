<?php
class dossiers
{
  private $conn;

  public $id;
  public $nom;
  public $numero;
  public $date_ouverture;

  public function __construct($db)
  {
    $this->conn = $db;
  }

  function read($data)
  {
    //200 OK
    //404 NOT FOUND
    //405 NOT ALLOWED
    //409 CONFLICT
    //501 NOT IMPLEMENTED
    //return array("code" => int, "message" => text, "data" => array, "authorizations" => array);
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
}
?>
