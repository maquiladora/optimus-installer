<?php

namespace Allspark\DAV\Auth\Backend;
//include_once 'JWT.php';
//use allspark\JWT\JWT;

class Jwt extends \Sabre\DAV\Auth\Backend\AbstractBearer
{
	function validateBearerToken($bearerToken)
	{
		return true;
	}
}
