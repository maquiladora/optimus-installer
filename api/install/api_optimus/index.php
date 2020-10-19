<?php
header("Access-Control-Allow-Origin: " . (isset($_SERVER['HTTP_ORIGIN'])?$_SERVER['HTTP_ORIGIN']:$_SERVER['SERVER_NAME']));
header("Access-Control-Allow-Methods: GET, POST, PUT, PATCH, DELETE, OPTIONS");
header("Access-Control-Allow-Credentials: true");
header("Access-Control-Allow-Headers: Content-Type, Accept, Authorization");
header("Access-Control-Max-Age: 1");
header("Content-Type: application/json");
if ($_SERVER['REQUEST_METHOD'] == "OPTIONS") die(http_response_code(200));

if (@$_GET['data'] && $_SERVER['REQUEST_METHOD']=='GET')
  $data = json_decode(urldecode($_GET['data']));
else
  $data = json_decode(file_get_contents("php://input"));

if (!$data)
  $data = (object) array();


//optimus/{database}/{resource}/{id}

if (@$path[2] AND preg_match("/^[a-z0-9_@.]+$/", @$path[2]))
  $data->db = $path[2];
else
{
  http_response_code(400);
  die(json_encode(array("code" => 400, "message" => "Base de données invalide")));
}


if (@$path[3] AND preg_match("/^[a-z0-9_]+$/", @$path[3]))
  $data->resource = $path[3];
else
{
  http_response_code(400);
  die(json_encode(array("code" => 400, "message" => "Resource invalide")));
}


if (@$path[4] OR substr($url['path'],-1)=='/')
{
  if (preg_match("/^\d+$/", @$path[4]))
    $data->id = intval($path[4]);
  else
  {
    http_response_code(400);
    die(json_encode(array("code" => 400, "message" => "Identifiant invalide")));
  }
}

include_once 'config.php';
include_once 'connect.php';

include_once 'api_allspark/auth.php';
$data->user = $payload['user']->email;

//if ($data->resource == 'contacts')
  //include_once 'contacts.php';
//else if ($data->resource ==  'dossiers')
  //include_once 'dossiers.php';
//else if ($data->resource == 'dossiers_intervenants')
  //include_once 'dossiers_intervenants.php';
if ($data->resource == 'settings')
  include_once 'api_optimus/resources/settings.php';
else
{
  http_response_code(404);
  die(json_encode(array("code" => 404, "message" => "Resource inconnue")));
}

if ($_SERVER['REQUEST_METHOD']=='GET')
  $result = read($db,$data);
if ($_SERVER['REQUEST_METHOD']=='POST')
  $result = create($db,$data);
if ($_SERVER['REQUEST_METHOD']=='PUT')
  $result = replace($db,$data);
if ($_SERVER['REQUEST_METHOD']=='PATCH')
  $result = modify($db,$data);
if ($_SERVER['REQUEST_METHOD']=='DELETE')
  $result = delete($db,$data);

http_response_code($result['code']);
echo json_encode($result);
?>
