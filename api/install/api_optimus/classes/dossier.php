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


  function create()
  {
    $last_numero = $this->conn->query("SELECT numero FROM " . $this->table_name . " WHERE numero LIKE '" . date('y') . "/%' ORDER BY id DESC LIMIT 1")->fetch();
    $this->nom = time();
    $this->numero = date('y') . '/' . str_pad(intval(substr($last_numero['numero'],3))+1, 4, "0", STR_PAD_LEFT);
    $this->date_ouverture = date('Y-m-d');

    //CREATION DU DOSSIER INFORMATIQUE
    @mkdir('/srv/files/prime@demoptimus.fr/==DOSSIERS==', 0750);
    @mkdir('/srv/files/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom, 0750);

    //CREATION DU DOSSIER IMAP
    umask(0);
    mkdir('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom, 0770);
    chgrp('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom, 'mailboxes');
    mkdir('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom.'/tmp', 0770);
    chgrp('/srv/mailboxes/prime@demoptimus.fr/==DOSSIERS==/'.$this->nom.'/tmp', 'mailboxes');
    file_put_contents('/srv/mailboxes/prime@demoptimus.fr/subscriptions',"==DOSSIERS==/" . $this->nom . "\n", FILE_APPEND);
    set_cookie('roundcube_sessauth','',time() - 3600,"webmail.demoptimus.fr");
    set_cookie('roundcube_sessid','',time() - 3600,"webmail.demoptimus.fr");

    //INSERT DANS LA BASE DE DONNEE
    $stmt = $this->conn->prepare("INSERT INTO " . $this->table_name . " SET nom = :nom, numero = :numero, date_ouverture = :date_ouverture");

    $stmt->bindParam(':nom', $this->nom);
    $stmt->bindParam(':numero', $this->numero);
    $stmt->bindParam(':date_ouverture', $this->date_ouverture);
    if($stmt->execute())
      return $this->conn->lastInsertId();
    else
      return $stmt->errorInfo()[2];
  }
}
?>
