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
    $query = "INSERT INTO " . $this->table_name . " SET nom = :nom, numero = :numero, date_ouverture = :date_ouverture";

    $stmt = $this->conn->prepare($query);

    $this->nom=htmlspecialchars(strip_tags('testapi'));
    $this->numero=htmlspecialchars(strip_tags('20/030'));
    $this->date_ouverture=htmlspecialchars(strip_tags('2020-10-14'));

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
