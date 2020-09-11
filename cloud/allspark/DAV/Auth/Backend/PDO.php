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
print_r($_COOKIE);
		if (isset($_COOKIE['token']))
		{
			try
			{
			    $payload = (new JWT('$API_SHA_KEY', 'HS512', 3600, 10))->decode($_COOKIE['token']);
					$username = (array)$payload;
					$username = $username['user']->email;
					$stmt = $this->pdo->prepare('SELECT MD5(CONCAT(email,":","' . $realm . '",":",AES_DECRYPT(password,"$AES_KEY"))) FROM ' . $this->tableName . ' WHERE email = ?');
					$stmt->execute([$username]);
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
