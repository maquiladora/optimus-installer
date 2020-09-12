<?php
namespace Allspark\DAV\Auth\Backend;

use Sabre\HTTP;
use Sabre\HTTP\RequestInterface;
use Sabre\HTTP\ResponseInterface;

include_once 'JWT.php';
use allspark\JWT\JWT;

class JWT_PDO extends \Sabre\DAV\Auth\Backend\AbstractBearer
{

	public function validateBearerToken($bearerToken)
	{

	}

	public function check(RequestInterface $request, ResponseInterface $response)
	{
		if (isset($_COOKIE['token']))
		{
			$payload = (new JWT('$API_SHA_KEY', 'HS512', 3600, 10))->decode($_COOKIE['token']);
			return [true, "principals/".$payload['user']->email];
		}
		else
			return [false, "Invalid Token"];
	}

	public function challenge(RequestInterface $request, ResponseInterface $response)
	{
			 $response->setStatus(200);
	}

}
