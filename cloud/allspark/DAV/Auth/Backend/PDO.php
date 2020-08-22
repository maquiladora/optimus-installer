<?php

namespace Allspark\DAV\Auth\Backend;

class PDO extends \Sabre\DAV\Auth\Backend\AbstractDigest
{
	protected $pdo;
  public $tableName = 'users.users';

	function __construct(\PDO $pdo)
	{
		$this->pdo = $pdo;
	}

	function getDigestHash($realm, $username)
	{
		$stmt = $this->pdo->prepare('SELECT MD5(CONCAT(email,":","' . $realm . '",":",AES_DECRYPT(password,"$AES_KEY"))) FROM ' . $this->tableName . ' WHERE email = ?');
		$stmt->execute([$username]);
		return $stmt->fetchColumn() ?: null;
	}
}
