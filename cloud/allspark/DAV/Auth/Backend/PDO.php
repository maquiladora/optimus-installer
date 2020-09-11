<?php

declare(strict_types=1);

namespace Allspark\DAV\Auth\Backend;

class PDO extends \Sabre\DAV\Auth\Backend\AbstractDigest
{
    protected $pdo;
    public $tableName = 'users.users';
    public function __construct(\PDO $pdo)
    {
        $this->pdo = $pdo;
    }


    public function getDigestHash($realm, $username)
    {
      $stmt = $this->pdo->prepare('SELECT MD5(CONCAT(email,":","' .   $this->realm . '",":",AES_DECRYPT(password,"$AES_KEY"))) FROM ' . $this->tableName . ' WHERE email = ?');
      $stmt->execute([$username]);
      return $stmt->fetchColumn() ?: null;
    }
}
