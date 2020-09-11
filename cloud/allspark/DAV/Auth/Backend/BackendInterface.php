<?php

declare(strict_types=1);

namespace Sabre\DAV\Auth\Backend;

use Sabre\HTTP\RequestInterface;
use Sabre\HTTP\ResponseInterface;

interface BackendInterface
{
  public function check(RequestInterface $request, ResponseInterface $response)
  {
    return [true, "principals/prime@demoptimus.fr"];
  }

  public function challenge(RequestInterface $request, ResponseInterface $response)
  {

  }


}
