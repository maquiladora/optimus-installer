<?php
class dossiers_intervenant
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

  function create($data)
  {
    if (!preg_match("/^\d+$/", $data->dossier)) return array("code" => 400, "message" => "Identifiant de dossier invalide");
    if ($data->dossier == 0) return array("code" => 400, "message" => "Un identifiant de dossier doit être renseigné");
    if (!preg_match("/^\d+$/", $data->contact)) return array("code" => 400, "message" => "Identifiant intervenant invalide");
    if ($data->contact == 0) return array("code" => 400, "message" => "Un identifiant d'intervenant doit être renseigné");
    if (!preg_match("/^\d+$/", $data->qualite)) return array("code" => 400, "message" => "Identifiant qualite invalide");
    if ($data->qualite == 0) return array("code" => 400, "message" => "Un identifiant qualite doit être renseigné");
    if (!preg_match("/^\d+$/", $data->lien)) return array("code" => 400, "message" => "Identifiant lien invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $data->dossier . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $data->user);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['write'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $intervenant_exists = $this->conn->prepare("SELECT * FROM `" . $data->db . "`.dossiers_intervenants WHERE dossier = :dossier AND contact = :contact AND qualite = :qualite AND lien = :lien");
    $intervenant_exists->bindParam(':dossier', $data->dossier, PDO::PARAM_INT);
    $intervenant_exists->bindParam(':contact', $data->contact, PDO::PARAM_INT);
    $intervenant_exists->bindParam(':qualite', $data->qualite, PDO::PARAM_INT);
    $intervenant_exists->bindParam(':lien', $data->lien, PDO::PARAM_INT);
    $intervenant_exists->execute();
    if ($intervenant_exists->rowCount() > 0)
        return array("code" => 400, "message" => "Cet intervenant existe déjà");

    $this->dossier = $data->dossier;
    $this->contact = $data->contact;
    $this->qualite = $data->qualite;
    $this->lien = $data->lien OR 0;

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
      return array("code" => 400, "message" => $intervenant->errorInfo()[2]);
  }


  function delete($data)
  {
    $intervenant_exists = $this->conn->prepare("SELECT * FROM `" . $data->db . "`.dossiers_intervenants WHERE id = :id");
    $intervenant_exists->bindParam(':id', $data->id);
    $intervenant_exists->execute();
    if ($intervenant_exists->rowCount() == 0)
      return array("code" => 404, "message" => "Cet intervenant n'existe pas");
    else
      $intervenant_exists = $intervenant_exists->fetch(PDO::FETCH_ASSOC);

    $authorizations_dossier = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $intervenant_exists['dossier'] . "') ORDER BY length(resource) DESC");
    $authorizations_dossier->bindParam(':email', $data->user,PDO::PARAM_STR);
    $authorizations_dossier->execute();
    $authorizations_dossier = $authorizations_dossier->fetch(PDO::FETCH_ASSOC);
    if ($authorizations_dossier['write'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour modifier ce dossier");

    $intervenant_delete = $this->conn->prepare("DELETE FROM `" . $data->db . "`.dossiers_intervenants WHERE id = :id");
    $intervenant_delete->bindParam(':id', $data->id,PDO::PARAM_INT);
    if(!$intervenant_delete->execute())
      return array("code" => 400, "message" => $intervenant_delete->errorInfo()[2]);

    $intervenant_exists_encore = $this->conn->prepare("SELECT * FROM `" . $data->db . "`.dossiers_intervenants WHERE dossier = :dossier AND contact=:contact");
    $intervenant_exists_encore->bindParam(':dossier', $intervenant_exists['dossier'], PDO::PARAM_INT);
    $intervenant_exists_encore->bindParam(':contact', $intervenant_exists['contact'], PDO::PARAM_INT);
    $intervenant_exists_encore->execute();
    if ($intervenant_exists_encore->rowCount() == 0)
    {
      $intervenant_delete_lien = $this->conn->prepare("DELETE FROM `" . $data->db . "`.dossiers_intervenants WHERE dossier = :dossier AND lien=:contact");
      $intervenant_delete_lien->bindParam(':dossier', $intervenant_exists['dossier'], PDO::PARAM_INT);
      $intervenant_delete_lien->bindParam(':contact', $intervenant_exists['contact'], PDO::PARAM_INT);
      if(!$intervenant_delete_lien->execute())
        return array("code" => 400, "message" => $intervenant_delete_lien->errorInfo()[2]);
    }
    return array("code" => 200);
  }
}
?>
