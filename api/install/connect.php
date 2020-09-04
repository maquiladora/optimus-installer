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
        echo  echo mcrypt_encrypt(MCRYPT_RIJNDAEL_128, '1y6bnzuf6pFUEVUD', $this->password, MCRYPT_MODE_ECB);
        try
        {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username,  mcrypt_encrypt(MCRYPT_RIJNDAEL_128, '1y6bnzuf6pFUEVUD', $this->password, MCRYPT_MODE_ECB));
        }
        catch(PDOException $exception)
        {
            echo "Connection error: " . $exception->getMessage();
        }

        return $this->conn;
    }
}
?>
