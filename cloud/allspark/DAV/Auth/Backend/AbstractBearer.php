<?php
declare(strict_types=1);

namespace Allspark\DAV\Auth\Backend;

use Sabre\DAV\Auth\Backend\BackendInterface;

include_once 'JWT.php';
use allspark\JWT\JWT;

abstract class AbstractBearer implements BackendInterface
{

  public function check()
  {
    if (isset($_COOKIE['token']))
    {
      $payload = (new JWT('$API_SHA_KEY', 'HS512', 3600, 10))->decode($_COOKIE['token']);
      return [true, "principals/".$payload['user']->email];
    }
    else
      return [false, "Invalid Token"];
  }


  public function challenge()
  {

  }
}
