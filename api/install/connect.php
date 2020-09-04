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
            $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name, $this->username,  'u8 rN3 Üí YFÉmö¦A Ö:Ë ¯ ­78  ^ù6. I   }~Ú 7Ï³i6');
        }
        catch(PDOException $exception)
        {
            echo "Connection error: " . $exception->getMessage();
        }

        return $this->conn;
    }
}
?>
