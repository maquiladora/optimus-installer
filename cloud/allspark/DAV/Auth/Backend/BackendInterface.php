<?php

use Sabre\DAV\Auth\Backend\BackendInterface;
use Sabre\HTTP\RequestInterface;
use Sabre\HTTP\ResponseInterface;

class OAuth implements BackendInterface
{
    function check(RequestInterface $request, ResponseInterface $response)
    {
      return array(true, "principals/prime@demoptimus.fr");
    }

    function challenge(RequestInterface $request, ResponseInterface $response)
    {
        // Do Stuff when user could not be authenticated
    }
}
