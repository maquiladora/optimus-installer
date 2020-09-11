<?php

namespace Allspark\DAV\Auth\Backend;
include_once 'JWT.php';
use allspark\JWT\JWT;

class PDO extends \Sabre\DAV\Auth\Backend\AbstractBearer
{
	protected $pdo;
  public $tableName = 'users.users';

	function __construct(\PDO $pdo)
	{
		$this->pdo = $pdo;
	}
}
