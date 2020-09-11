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

    //protected $realm = 'ALLSPARK';

    //abstract protected function validateBearerToken($bearerToken);

    public function setRealm($realm)
    {
        $this->realm = $realm;
    }


    public function check(RequestInterface $request, ResponseInterface $response)
    {
        $auth = new HTTP\Auth\Bearer($this->realm,$request,$response);



        if (isset($_COOKIE['token']))
        {
          $payload = (new JWT('$API_SHA_KEY', 'HS512', 3600, 10))->decode($_COOKIE['token']);
          return [true, $payload['user']->email];
        }
        else
          return false;


        //$bearerToken = $auth->getCredentials($request);
        //echo $bearerToken;
        //if (!$bearerToken) {
        //    return [false, "No 'Authorization: Bearer' header found. Either the client didn't send one, or the server is mis-configured"];
        //}
        //$principalUrl = $this->validateBearerToken($bearerToken);
        //if (!$principalUrl) {
        //    return [false, 'Bearer token was incorrect'];
        //}

        //return [true, $principalUrl];
    }

    /**
     * This method is called when a user could not be authenticated, and
     * authentication was required for the current request.
     *
     * This gives you the opportunity to set authentication headers. The 401
     * status code will already be set.
     *
     * In this case of Bearer Auth, this would for example mean that the
     * following header needs to be set:
     *
     * $response->addHeader('WWW-Authenticate', 'Bearer realm=SabreDAV');
     *
     * Keep in mind that in the case of multiple authentication backends, other
     * WWW-Authenticate headers may already have been set, and you'll want to
     * append your own WWW-Authenticate header instead of overwriting the
     * existing one.
     */
    public function challenge(RequestInterface $request, ResponseInterface $response)
    {
        $auth = new HTTP\Auth\Bearer(
            $this->realm,
            $request,
            $response
        );
        $auth->requireLogin();
    }
}
