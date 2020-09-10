<?php

namespace Allspark\DAV\Auth\Backend;
include_once 'JWT.php';
use allspark\JWT\JWT;

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
		if ($_COOKIE['token'] AND $_COOKIE['token'] != 'null')
		{
			try
			{
			    $payload = (new JWT($API_SHA_KEY, 'HS512', 3600, 10))->decode($_COOKIE['token']);
					$stmt = $this->pdo->prepare('SELECT MD5(CONCAT(email,":","' . $realm . '",":",AES_DECRYPT(password,"$AES_KEY"))) FROM ' . $this->tableName . ' WHERE email = ?');
					$stmt->execute([$payload->email]);
					return $stmt->fetchColumn() ?: null;
			}
			catch (Throwable $e)
			{
			 return null;
			}
		}
		else
		{
				$stmt = $this->pdo->prepare('SELECT MD5(CONCAT(email,":","' . $realm . '",":",AES_DECRYPT(password,"$AES_KEY"))) FROM ' . $this->tableName . ' WHERE email = ?');
				$stmt->execute([$username]);
				return $stmt->fetchColumn() ?: null;
		}
	}
}
