<?php
class contact
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
    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'contacts' or resource = 'contacts." . $data->id . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $data->user);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['read'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder à ce contact");

    $contact = $this->conn->prepare("SELECT * FROM `" . $data->db . "`.contacts WHERE id = :id");
    $contact->bindParam(':id', $data->id, PDO::PARAM_INT);
    $contact->execute();
    if ($contact->rowCount() == 0)
      return array("code" => 404, "message" => "Ce contact n'existe pas");
    else
    {
      $contact = $contact->fetch(PDO::FETCH_ASSOC);
      return array("code" => 200, "data" => $contact, "authorizations" => $authorizations);
    }
  }


  function create($data)
  {
    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'contacts'");
    $authorizations->bindParam(':email', $data->user, PDO::PARAM_STR);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['create'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $query = "INSERT INTO `" . $data->db . "`.contacts SET ";
    if ($data->values)
    {
      foreach($data->values as $key => $value)
      {
        $query .= $key.'=:'.$key.',';
        $this->{$key} = $value;
      }
      $query = substr($query,-1);
      $contact = $this->conn->prepare($query);
      foreach($data->values as $key => $value)
        $contact->bindParam(':'.$key, $this->{$key});
    }
    else
    {
      $this->lastname = 'CLIENT ' . time();
      $query .= "lastname=:lastname";
      $contact = $this->conn->prepare($query);
      $contact->bindParam(':lastname', $this->lastname);
    }

    if($contact->execute())
    {
      $this->id = $this->conn->lastInsertId();
      return array("code" => 201, "data" => $this, "authorizations" => $authorizations);
    }
    else
      return array("code" => 400, "message" => $contact->errorInfo()[2] . ' ' . $query);
  }


  function delete($data)
  {
    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'contacts' OR resource = 'contacts." . $data->id . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $data->user);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['delete'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $contact = $this->conn->query("SELECT nom FROM `" . $data->db . "`.dossiers WHERE id = '" . $data->id . "'");
    if ($contact->rowCount() == 0)
      return array("code" => 404, "message" => "Ce dossier n'existe pas");
    else
      $contact = $contact->fetch();

    $intervenants_exists = $this->conn->query("SELECT id FROM `" . $data->db . "`.dossiers_intervenants WHERE contact = '" . $data->id . "'")->rowCount();
    if ($intervenants_exists > 0)
      return array("code" => 400, "message" => "Ce contact ne peut pas être supprimé car il intervient dans un ou plusieurs dossiers");

    //A FAIRE : CHECKER si le contact apparait dans une facture
    //$factures_exists = $this->conn->query("SELECT id FROM optimus_user_1.interventions WHERE dossier = '" . $data->id . "' AND db IS NOT NULL")->rowCount();
    //if ($factures_exists > 0)
      //return array("code" => 400, "message" => "Ce dossier ne peut pas être supprimé car des factures le concernant ont été émises");

    $contact_delete = $this->conn->prepare("DELETE FROM `" . $data->db . "`.contacts WHERE id = ?");
    $contact_delete->bindParam(':id', $data->id, PDO::PARAM_INT);
    if($contact_delete->execute())
      return array("code" => 200);
    else
      return array("code" => 400, "message" => $contact_delete->errorInfo()[2]);
  }


  function update($data)
  {
    if (!preg_match("/^[a-z0-9_]+$/", $data->field)) return array("code" => 400, "message" => "Champ invalide");

    $authorizations = $this->conn->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'contacts' OR resource = 'contacts." . $data->id . "' OR resource = 'contacts." . $data->id . "." . $data->field . "') ORDER BY length(resource) DESC");
    $authorizations->bindParam(':email', $data->user);
    $authorizations->execute();
    $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
    if ($authorizations['write'] == 0)
      return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

    $exists = $this->conn->query("SELECT id FROM `" . $data->db . "`.contacts WHERE id = " . $data->id);
    if ($exists->rowCount() == 0)
      return array("code" => 404, "message" => "Ce contact n'existe pas");

    $field = $this->conn->prepare("SELECT DISTINCT DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'contacts' AND COLUMN_NAME = :field");
    $field->bindParam(':field', $data->field);
    if($field->execute())
      $field = $field->fetch();
    else
      return array("code" => 400, "message" => $field->errorInfo()[2]);

    $contact = $this->conn->prepare("UPDATE `" . $data->db . "`.contacts SET `" . $data->field . "` = :value WHERE id = " . $data->id);
    if ($field['DATA_TYPE'] == 'bit' OR $field['DATA_TYPE'] == 'tinyint' OR $field['DATA_TYPE'] == 'smallint' OR $field['DATA_TYPE'] == 'mediumint'  OR $field['DATA_TYPE'] == 'int' OR $field['DATA_TYPE'] == 'bigint')
    {
      if ($data->value=='')
        $contact->bindValue(':value', null, PDO::PARAM_NULL);
      else
        $contact->bindParam(':value', $data->value, PDO::PARAM_INT);
    }
    else if (($field['DATA_TYPE'] == 'date' OR $field['DATA_TYPE'] == 'datetime') AND $data->value =='')
      $contact->bindValue(':value', null, PDO::PARAM_NULL);
    else
      $contact->bindParam(':value', $data->value, PDO::PARAM_STR);

    if($contact->execute())
      return array("code" => 200);
    else
      return array("code" => 400, "message" => $contact->errorInfo()[2]);
    }
  }
  ?>
