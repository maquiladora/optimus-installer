<?php
class Database
{
    private $host = "localhost";
    private $db_name = "users";
    private $username = "$MARIADB_ADMIN_USER";
    private $password = "$MARIADB_ADMIN_PASSWORD";
    public $conn;

    public function getConnection()
    {
        $this->conn = null;

        try
        {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username, openssl_encrypt($this->password,'AES-128-CBC','$AES_KEY'));
        }
        catch(PDOException $exception)
        {
            echo "Connection error: " . $exception->getMessage();
        }

        return $this->conn;
    }
}
?>
