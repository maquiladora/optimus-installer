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
    $last_numero = $this->conn->query("SELECT numero FROM " . $this->table_name . " WHERE numero LIKE '" . date('Y') . "/%' ORDER BY id DESC LIMIT 1")->fetch();
    print_r($last_numero);

    $query = "INSERT INTO " . $this->table_name . " SET nom = :nom, numero = :numero, date_ouverture = :date_ouverture";

    $stmt = $this->conn->prepare($query);

    $this->nom = time();
    $this->numero = date('Y') . '/' . str_pad(substr($last_numero['numero'],3)+1, 4, "0", STR_PAD_LEFT);
    $this->date_ouverture = date('Y-m-d');

    $stmt->bindParam(':nom', $this->nom);
    $stmt->bindParam(':numero', $this->numero);
    $stmt->bindParam(':date_ouverture', $this->date_ouverture);

    if($stmt->execute())
      return $this->conn->lastInsertId();
    else
      return $stmt->errorInfo()[2];

    return false;
  }
}
?>
