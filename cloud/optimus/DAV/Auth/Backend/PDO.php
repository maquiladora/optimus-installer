<?php

namespace Optimus\DAV\Auth\Backend;

class PDO extends \Sabre\DAV\Auth\Backend\AbstractDigest
{
	protected $pdo;
  public $tableName = 'users';
	
	function __construct(\PDO $pdo)
	{
		$this->pdo = $pdo;
	}
	
	function getDigestHash($realm, $username)
	{
		$stmt = $this->pdo->prepare('SELECT MD5(CONCAT(email,":","' . $realm . '",":",imap_password)) FROM ' . $this->tableName . ' WHERE email = ?');
		$stmt->execute([$username]);
		return $stmt->fetchColumn() ?: null;
	}
}
