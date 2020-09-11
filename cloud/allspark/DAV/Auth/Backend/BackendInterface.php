<?php
declare(strict_types=1);

use Sabre\DAV\Auth\Backend;
use Sabre\HTTP\RequestInterface;
use Sabre\HTTP\ResponseInterface;

interface BackendInterface
{
    function check()
    {
      return array(true, "principals/prime@demoptimus.fr");
    }

    function challenge(RequestInterface $request, ResponseInterface $response)
    {
        // Do Stuff when user could not be authenticated
    }
}
