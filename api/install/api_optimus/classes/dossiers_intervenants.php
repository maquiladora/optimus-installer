<?php
class dossiers_intervenants
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


  function list($data)
  {
    if (!preg_match("/^\d+$/", $data->dossier)) return array("code" => 400, "message" => "Identifiant de dossier invalide");

    $authorizations_dossier = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $data->dossier . "') ORDER BY length(resource) DESC");
    $authorizations_dossier->bindParam(':email', $data->user, PDO::PARAM_STR);
    $authorizations_dossier->execute();
    $authorizations_dossier = $authorizations_dossier->fetch(PDO::FETCH_ASSOC);
    if ($authorizations_dossier['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder à ce dossier");

    $authorizations_contacts = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'contacts' ORDER BY length(resource) DESC");
    $authorizations_contacts->bindParam(':email', $data->user, PDO::PARAM_STR);
    $authorizations_contacts->execute();
    $authorizations_contacts = $authorizations_contacts->fetch(PDO::FETCH_ASSOC);
    if ($authorizations_contacts['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux contacts");

    $intervenants = $this->conn->query("SELECT * FROM `" . $data->db . "`.dossiers_intervenants WHERE dossier = " . $data->dossier);
    $intervenants = $intervenants->fetchAll(PDO::FETCH_ASSOC);
    return array("code" => 200, "data" => $intervenants, "authorizations" => $authorizations_dossier);
  }
}
?>
