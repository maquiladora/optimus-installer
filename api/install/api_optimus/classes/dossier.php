<?php
class dossier
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
    if (!preg_match("/^\d+$/", $data->id)) return array("code" => 400, "message" => "Identifiant invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' or resource = 'dossiers." . $data->id . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $payload['user']->email);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder à ce dossier");

    $dossier = $this->conn->query("SELECT * FROM `" . $data->db . "`.dossiers WHERE id = " . $data->id);
    if ($dossier->rowCount() == 0)
      return array("code" => 404, "message" => "Ce dossier n'existe pas");
    else
    {
      $dossier = $dossier->fetch(PDO::FETCH_ASSOC);
      $dossier['authorizations'] = $authorizations;
      return array("code" => 200, "data" => $dossier);
    }
  }


  function create($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'dossiers'");
    $authorizations->bindParam(':email', $payload['user']->email);
    $authorizations->execute();
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['create'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $last_numero = $this->conn->query("SELECT numero FROM `" . $data->db . "`.dossiers WHERE numero LIKE '" . date('y') . "/%' ORDER BY id DESC LIMIT 1")->fetch();
    $this->nom = 'DOSSIER ' . time();
    $this->numero = date('y') . '/' . str_pad(intval(substr($last_numero['numero'],3))+1, 4, "0", STR_PAD_LEFT);
    $this->date_ouverture = date('Y-m-d');

    @mkdir('/srv/files/' . $data->db . '/==DOSSIERS==', 0750);
    @mkdir('/srv/files/' . $data->db . '/==DOSSIERS==/'.$this->nom, 0750);

    umask(0);
    @mkdir('/srv/mailboxes/' . $data->db . '/==DOSSIERS==/'.$this->nom, 0770);
    @chgrp('/srv/mailboxes/' . $data->db . '/==DOSSIERS==/'.$this->nom, 'mailboxes');
    @mkdir('/srv/mailboxes/' . $data->db . '/==DOSSIERS==/'.$this->nom.'/tmp', 0770);
    @chgrp('/srv/mailboxes/' . $data->db . '/==DOSSIERS==/'.$this->nom.'/tmp', 'mailboxes');
    @file_put_contents('/srv/mailboxes/' . $data->db . '/subscriptions',"==DOSSIERS==/" . $this->nom . "\n", FILE_APPEND);

    $stmt = $this->conn->prepare("INSERT INTO `" . $data->db . "`.dossiers SET nom = :nom, numero = :numero, date_ouverture = :date_ouverture");
    $stmt->bindParam(':nom', $this->nom);
    $stmt->bindParam(':numero', $this->numero);
    $stmt->bindParam(':date_ouverture', $this->date_ouverture);
    if($stmt->execute())
    {
      $this->id = $this->conn->lastInsertId();
      return array("code" => 201, "data" => $this);
    }
    else
      return array("code" => 400, "message" => $stmt->errorInfo()[2]);
  }


  function rename($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (!preg_match("/^\d+$/", $data->id)) return array("code" => 400, "message" => "Identifiant invalide");
    $data->new_name = trim($data->new_name);
    if ($data->new_name == '.' OR $data->new_name == '..') return array("code" => 400, "message" => "Nom de dossier invalide");
    if (!preg_match('/^[a-zA-Z0-9 ._@\-àâäéèêëïîôöùûüÿç]+$/', $data->new_name)) return array("code" => 400, "message" => "Nom de dossier invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $data->id . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $payload['user']->email);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['write'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action", "auth"=> json_encode($authorizations));

    $old_name = $this->conn->query("SELECT nom FROM `" . $data->db . "`.dossiers WHERE id = '" . $data->id . "'");
    if ($old_name->rowCount() == 0)
      return array("code" => 404, "message" => "Ce dossier n'existe pas");
    else
      $old_name = $old_name->fetch();
    $new_name = $this->conn->query("UPDATE `" . $data->db . "`.dossiers SET nom = '" . $data->new_name . "' WHERE id = '" . $data->id . "'")->fetch();
    @rename('/srv/files/' . $data->db . '/==DOSSIERS==/' . $old_name['nom'], '/srv/files/' . $data->db . '/==DOSSIERS==/' . $data->new_name);
    @rename('/srv/mailboxes/' . $data->db . '/==DOSSIERS==/' . mb_convert_encoding($old_name['nom'], "UTF7-IMAP","UTF-8"), '/srv/mailboxes/' . $data->db . '/==DOSSIERS==/' . mb_convert_encoding($data->new_name, "UTF7-IMAP","UTF-8"));
    $subscriptions = file_get_contents('/srv/mailboxes/' . $data->db . '/subscriptions');
    $subscriptions = str_replace('==DOSSIERS==/' . mb_convert_encoding($old_name['nom'], "UTF7-IMAP","UTF-8"), '==DOSSIERS==/' . mb_convert_encoding($data->new_name, "UTF7-IMAP","UTF-8"), $subscriptions);
    @file_put_contents('/srv/mailboxes/' . $data->db . '/subscriptions', $subscriptions);
    return array("code" => 200);
  }


  function delete($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (!preg_match("/^\d+$/", $data->id)) return array("code" => 400, "message" => "Identifiant invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $data->id . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $payload['user']->email);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['delete'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $dossier = $this->conn->query("SELECT nom FROM `" . $data->db . "`.dossiers WHERE id = '" . $data->id . "'");
    if ($dossier->rowCount() == 0)
      return array("code" => 404, "message" => "Ce dossier n'existe pas");
    else
      $dossier = $dossier->fetch();

    $interventions_exists = $this->conn->query("SELECT id FROM `" . $data->db . "`.interventions WHERE dossier = '" . $data->id . "'")->rowCount();
    if ($interventions_exists > 0)
      return array("code" => 400, "message" => "Ce dossier ne peut pas être supprimé car il contient des fiches d'intervention");

    $factures_exists = $this->conn->query("SELECT id FROM optimus_user_1.interventions WHERE dossier = '" . $data->id . "' AND db IS NOT NULL")->rowCount();
    if ($factures_exists > 0)
      return array("code" => 400, "message" => "Ce dossier ne peut pas être supprimé car des factures le concernant ont été émises");

    $dossier_delete = $this->conn->query("DELETE FROM `" . $data->db . "`.dossiers WHERE id = '" . $data->id . "'");
    $intervenants_delete = $this->conn->query("DELETE FROM `" . $data->db . "`.dossiers_intervenants WHERE dossier = '" . $data->id . "'");

    system('rm -R /srv/files/' . $data->db . '/==DOSSIERS==/' . $dossier['nom']);
    system('rm -R /srv/mailboxes/' . $data->db . '/==DOSSIERS==/' . mb_convert_encoding($dossier['nom'], "UTF7-IMAP","UTF-8"));
    $subscriptions = file_get_contents('/srv/mailboxes/' . $data->db . '/subscriptions');
    $subscriptions = str_replace('==DOSSIERS==/' . mb_convert_encoding($dossier['nom'], "UTF7-IMAP","UTF-8") . "\n", '', $subscriptions);
    @file_put_contents('/srv/mailboxes/' . $data->db . '/subscriptions', $subscriptions);
    return array("code" => 200);
  }

  function update($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (!preg_match("/^\d+$/", $data->id)) return array("code" => 400, "message" => "Identifiant invalide");
    if (!preg_match("/^[a-z0-9_]+$/", $data->field)) return array("code" => 400, "message" => "Champ invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'dossiers' OR resource = 'dossiers." . $data->id . "' OR resource = 'dossiers." . $data->id . "." . $data->field . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $payload['user']->email);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['write'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $exists = $this->conn->query("SELECT nom FROM `" . $data->db . "`.dossiers WHERE id = " . $data->id);
    if ($exists->rowCount() == 0)
      return array("code" => 404, "message" => "Ce dossier n'existe pas");

    $field = $this->conn->prepare("SELECT DISTINCT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'dossiers' AND COLUMN_NAME = :field");
    $field->bindParam(':field', $data->field);
    if($field->execute())
      $field = $field->fetch();
    else
      return array("code" => 400, "message" => $field->errorInfo()[2]);

    $dossier = $this->conn->prepare("UPDATE `" . $data->db . "`.dossiers SET `" . $data->field . "` = :value WHERE id = " . $data->id);
    if ($field['DATA_TYPE'] == 'bit' OR $field['DATA_TYPE'] == 'tinyint' OR $field['DATA_TYPE'] == 'smallint' OR $field['DATA_TYPE'] == 'mediumint'  OR $field['DATA_TYPE'] == 'int' OR $field['DATA_TYPE'] == 'bigint')
    {
      if ($data->value=='')
        $dossier->bindValue(':value', null, PDO::PARAM_NULL);
      else
        $dossier->bindParam(':value', $data->value, PDO::PARAM_INT);
    }
    else if (($field['DATA_TYPE'] == 'date' OR $field['DATA_TYPE'] == 'datetime') AND $data->value =='')
      $dossier->bindValue(':value', null, PDO::PARAM_NULL);
    else
      $dossier->bindParam(':value', $data->value, PDO::PARAM_STR);

    if($dossier->execute())
      return array("code" => 200);
    else
      return array("code" => 400, "message" => $dossier->errorInfo()[2]);
  }
}
?>
