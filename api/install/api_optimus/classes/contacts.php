<?php
class contacts
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

  function list($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (@$data->categorie AND !preg_match("/^\d+$/", $data->categorie)) return array("code" => 400, "message" => "Identifiant de categorie invalide");

    $authorizations_contacts = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'contacts' ORDER BY length(resource) DESC");
    $authorizations_contacts->bindParam(':email', $payload['user']->email);
    $authorizations_contacts->execute();
    $authorizations_contacts = $authorizations_contacts->fetch(PDO::FETCH_ASSOC);
    if ($authorizations_contacts['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux contacts");

    if (@$data->categorie)
    {
      $contacts = $this->conn->prepare("SELECT * FROM `" . $data->db . "`.contacts WHERE categorie = :categorie");
      $contacts->bindParam(':categorie', $data->categorie, PDO::PARAM_INT);
    }
    else
      $contacts = $this->conn->prepare("SELECT * FROM `" . $data->db . "`.contacts");

    if($contacts->execute())
    {
      $contacts = $contacts->fetchAll(PDO::FETCH_ASSOC);
      return array("code" => 200, "data" => $contacts, 'authorizations' => $authorizations_contacts);
    }
    else
      return array("code" => 400, "message" => $contacts->errorInfo()[2]);


  }
}
?>
