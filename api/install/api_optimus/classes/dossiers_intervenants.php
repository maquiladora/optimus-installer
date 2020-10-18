<?php
class dossier_intervenants
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
    if (!preg_match("/^\d+$/", $data->dossier)) return array("code" => 400, "message" => "Identifiant de dossier invalide");

    $authorizations_dossier = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $data->id . "') ORDER BY length(resource) DESC");
    $authorizations_dossier->bindParam(':email', $payload['user']->email);
    $authorizations_dossier->execute();
    $authorizations_dossier = $authorizations_dossier->fetch(PDO::FETCH_ASSOC);
    if ($authorizations_dossier['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder à ce dossier");

    $authorizations_contacts = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'contacts' ORDER BY length(resource) DESC");
    $authorizations_contacts->bindParam(':email', $payload['user']->email);
    $authorizations_contacts->execute();
    $authorizations_contacts = $authorizations_contacts->fetch(PDO::FETCH_ASSOC);
    if ($authorizations_contacts['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux contacts");

    $dossier = $this->conn->query("SELECT * FROM `" . $data->db . "`.dossiers_intervenants WHERE dossier = " . $data->dossier);
    if ($dossier->rowCount() == 0)
      return array("code" => 404, "message" => "Aucun intervenant n'a été trouvé pour ce dossier");
    else
    {
      $dossier = $dossier->fetch(PDO::FETCH_ASSOC);
      $dossier['authorizations'] = $authorizations_dossier;
      return array("code" => 200, "data" => $dossier);
    }
  }
}


class dossier_intervenant
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

  function create($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (!preg_match("/^\d+$/", $data->dossier)) return array("code" => 400, "message" => "Identifiant de dossier invalide");
    if ($data->dossier > 0) return array("code" => 400, "message" => "Un identifiant de dossier doit être renseigné");
    if (!preg_match("/^\d+$/", $data->contact)) return array("code" => 400, "message" => "Identifiant intervenant invalide");
    if ($data->contact > 0) return array("code" => 400, "message" => "Un identifiant d'intervenant doit être renseigné");
    if (!preg_match("/^\d+$/", $data->qualite)) return array("code" => 400, "message" => "Identifiant qualite invalide");
    if ($data->qualite > 0) return array("code" => 400, "message" => "Un identifiant qualite doit être renseigné");
    if (!preg_match("/^\d+$/", $data->lien)) return array("code" => 400, "message" => "Identifiant lien invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'dossiers'");
    $authorizations->bindParam(':email', $payload['user']->email);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['write'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $this->dossier = $data->dossier;
    $this->contact = $data->contact;
    $this->qualite = $data->qualite;
    $this->lien = $data->qualite OR 0;

    $intervenant = $this->conn->prepare("INSERT INTO `" . $data->db . "`.dossiers_intervenants SET dossier = :dossier, contact = :contact, qualite = :qualite, lien = :lien");
    $intervenant->bindParam(':dossier', $this->dossier);
    $intervenant->bindParam(':contact', $this->contact);
    $intervenant->bindParam(':qualite', $this->qualite);
    $intervenant->bindParam(':lien', $this->lien);
    if($intervenant->execute())
    {
      $this->id = $this->conn->lastInsertId();
      return array("code" => 201, "data" => $this);
    }
    else
      return array("code" => 400, "message" => $stmt->errorInfo()[2]);
  }



?>
