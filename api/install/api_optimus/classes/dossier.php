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
      return $this;
    }
    else
      return $stmt->errorInfo()[2];
  }


  function rename($data)
  {
    $old_name = $this->conn->query("SELECT nom FROM " . $this->table_name . " WHERE id = '" . $data->id . "'")->fetch();
    $new_name = $this->conn->query("UPDATE " . $this->table_name . " SET nom = '" . $data->new_name . "' WHERE id = '" . $data->id . "'")->fetch();
    @rename('/srv/files/prime@demoptimus.fr/==DOSSIERS==/' . $old_name['nom'], '/srv/files/prime@demoptimus.fr/==DOSSIERS==/' . $data->new_name);
    @rename('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/' . imap_utf7_encode($old_name['nom']), '/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/' . imap_utf7_encode($data->new_name));
    $subscriptions = file_get_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions');
    $subscriptions = str_replace('==DOSSIERS==/' . imap_utf7_encode($old_name['nom']), '==DOSSIERS==/' . imap_utf7_encode($data->new_name), $subscriptions);
    @file_put_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions', $subscriptions);
    return true;
  }
}
?>
