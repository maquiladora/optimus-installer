<?php
class User
{
  private $conn;
  private $table_name = "users";

  public $id;
  public $status;
  public $email;
  public $password;

  public function __construct($db)
  {
    $this->conn = $db;
  }


  function create()
  {
    $query = "INSERT INTO " . $this->table_name . "
            SET
                status = :status,
                email = :email,
                password = :password";

    $stmt = $this->conn->prepare($query);

    $this->status=htmlspecialchars(strip_tags($this->lastname));
    $this->email=htmlspecialchars(strip_tags($this->email));
    $this->password=htmlspecialchars(strip_tags($this->password));

    $stmt->bindParam(':status', $this->status);
    $stmt->bindParam(':email', $this->email);

    $password_hash = password_hash($this->password, PASSWORD_BCRYPT);
    $stmt->bindParam(':password', $password_hash);

    if($stmt->execute())
    {
        return true;
    }

    return false;
  }

  function emailExists()
  {
    $query = "SELECT id, status, password FROM " . $this->table_name . " WHERE email = ? AND status = 1 LIMIT 0,1";

    $stmt = $this->conn->prepare( $query );
    $this->email=htmlspecialchars(strip_tags($this->email));
    $stmt->bindParam(1, $this->email);
    $stmt->execute();

    $num = $stmt->rowCount();

    if($num>0)
    {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $this->id = $row['id'];
        $this->status = $row['status'];
        $this->password = $row['password'];
        return true;
    }

    return false;
  }
}
