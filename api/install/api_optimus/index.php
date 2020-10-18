<?php
if (@$_GET['data'] && $_SERVER['REQUEST_METHOD']=='GET')
  $data = json_decode(urldecode($_GET['data']));
else
  $data = json_decode(file_get_contents("php://input"));

print($data);

if (!$data)
  $data = (object) array();

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

if ($data->resource == 'contacts')
  include_once 'contacts.php';
else if ($data->resource ==  'dossiers')
  include_once 'dossiers.php';
else if ($data->resource == 'dossiers_intervenants')
  include_once 'dossiers_intervenants.php';
else
{
  http_response_code(404);
  die(json_encode(array("code" => 404, "message" => "Resource inconnue")));
}
?>
