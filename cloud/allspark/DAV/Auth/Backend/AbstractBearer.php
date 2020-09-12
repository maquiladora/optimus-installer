<?php
declare(strict_types=1);

namespace Allspark\DAV\Auth\Backend;

use Sabre\DAV\Auth\Backend\BackendInterface;
use Sabre\HTTP;
use Sabre\HTTP\RequestInterface;
use Sabre\HTTP\ResponseInterface;

include_once 'JWT.php';
use allspark\JWT\JWT;

abstract class AbstractBearer implements BackendInterface
{

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
    $auth = new HTTP\Auth\Bearer('', $request, $response);
    $auth->requireLogin();
  }
}
