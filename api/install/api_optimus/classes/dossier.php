<?php
class dossier
{
  private $conn;
  private $table_name = "optimus_user_1.dossiers";

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
    $last_numero = $this->conn->query("SELECT numero FROM " . $this->table_name . " WHERE numero LIKE '" . date('y') . "/%' ORDER BY id DESC LIMIT 1")->fetch();
    $this->nom = time();
    $this->numero = date('y') . '/' . str_pad(intval(substr($last_numero['numero'],3))+1, 4, "0", STR_PAD_LEFT);
    $this->date_ouverture = date('Y-m-d');

    @mkdir('/srv/files/prime@demoptimus.fr/==DOSSIERS==', 0750);
    @mkdir('/srv/files/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom, 0750);

    umask(0);
    @mkdir('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom, 0770);
    @chgrp('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom, 'mailboxes');
    @mkdir('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom.'/tmp', 0770);
    @chgrp('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom.'/tmp', 'mailboxes');
    @file_put_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions',"==DOSSIERS==/" . $this->nom . "\n", FILE_APPEND);

    $stmt = $this->conn->prepare("INSERT INTO " . $this->table_name . " SET nom = :nom, numero = :numero, date_ouverture = :date_ouverture");
    $stmt->bindParam(':nom', $this->nom);
    $stmt->bindParam(':numero', $this->numero);
    $stmt->bindParam(':date_ouverture', $this->date_ouverture);
    if($stmt->execute())
    {
      $this->id = $this->conn->lastInsertId();
      return array("code" => 200, "data" => $this);
    }
    else
      return array("code" => 400, "message" => $stmt->errorInfo()[2]);
  }


  function rename($data)
  {
    $old_name = $this->conn->query("SELECT nom FROM " . $this->table_name . " WHERE id = '" . $data->id . "'")->fetch();
    $new_name = $this->conn->query("UPDATE " . $this->table_name . " SET nom = '" . $data->new_name . "' WHERE id = '" . $data->id . "'")->fetch();
    @rename('/srv/files/prime@demoptimus.fr/==DOSSIERS==/' . $old_name['nom'], '/srv/files/prime@demoptimus.fr/==DOSSIERS==/' . $data->new_name);
    @rename('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/' . mb_convert_encoding($old_name['nom'], "UTF7-IMAP","UTF-8"), '/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/' . mb_convert_encoding($data->new_name, "UTF7-IMAP","UTF-8"));
    $subscriptions = file_get_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions');
    $subscriptions = str_replace('==DOSSIERS==/' . mb_convert_encoding($old_name['nom'], "UTF7-IMAP","UTF-8"), '==DOSSIERS==/' . mb_convert_encoding($data->new_name, "UTF7-IMAP","UTF-8"), $subscriptions);
    @file_put_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions', $subscriptions);
    return array("code" => 200);
  }


  function delete($data)
  {
    $dossier = $this->conn->query("SELECT nom FROM " . $this->table_name . " WHERE id = '" . $data->id . "'")->fetch();

    $interventions_exists = $this->conn->query("SELECT id FROM optimus_user_1.interventions WHERE dossier = '" . $data->id . "'")->rowCount();
    if ($interventions_exists > 0)
      return "Ce dossier ne peut pas être supprimé car il contient des fiches d'intervention";

    $factures_exists = $this->conn->query("SELECT id FROM optimus_user_1.interventions WHERE dossier = '" . $data->id . "' AND db IS NOT NULL")->rowCount();
    if ($factures_exists > 0)
      return "Ce dossier ne peut pas être supprimé car des factures le concernant ont été émises";

    $dossier_delete = $this->conn->query("DELETE FROM " . $this->table_name . " WHERE id = '" . $data->id . "'");
    //$intervenants_delete = $this->conn->query("DELETE FROM " . $this->table_name . " WHERE dossier = '" . $data->id . "'");

    @rmdir('/srv/files/prime@demoptimus.fr/==DOSSIERS==/' . $dossier['nom']);
    @rmdir('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/' . mb_convert_encoding($dossier['nom'], "UTF7-IMAP","UTF-8"));
    $subscriptions = file_get_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions');
    $subscriptions = str_replace('==DOSSIERS==/' . mb_convert_encoding($dossier['nom'], "UTF7-IMAP","UTF-8") . "\n", '', $subscriptions);
    @file_put_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions', $subscriptions);
    return array("code" => 200);
  }
}
?>
