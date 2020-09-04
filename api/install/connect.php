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
        echo mcrypt_encrypt(MCRYPT_RIJNDAEL_128,'$AES_KEY', $this->password, MCRYPT_MODE_ECB, mcrypt_create_iv(mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256,MCRYPT_MODE_ECB),MCRYPT_RAND));
        try
        {
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username,  mcrypt_encrypt(MCRYPT_RIJNDAEL_128,'$AES_KEY', $this->password, MCRYPT_MODE_ECB, mcrypt_create_iv(mcrypt_get_iv_size(MCRYPT_RIJNDAEL_256,MCRYPT_MODE_ECB),MCRYPT_RAND)));
        }
        catch(PDOException $exception)
        {
            echo "Connection error: " . $exception->getMessage();
        }

        return $this->conn;
    }
}
?>
