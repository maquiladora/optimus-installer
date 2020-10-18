<?php
if (@$_GET['data'] && $_SERVER['REQUEST_METHOD']=='GET')
  $data = json_decode(urldecode($_GET['data']));
else
  $data = json_decode(file_get_contents("php://input"));

if (!$data)
  $data = (object) array();

if (@$path[2] AND preg_match("/^[a-z0-9_@.]+$/", @$path[2]))
  $data->db = $path[2];
else
{
  http_response_code(400);
  die(json_encode(array("code" => 400, "message" => "Base de données invalide")));
}

if (@!$path[3] OR !preg_match("/^[a-z0-9_]+$/", @$path[3]))
{
  http_response_code(400);
  die(json_encode(array("code" => 400, "message" => "Resource invalide")));
}

if (@$path[4])
{
  if (preg_match("/^\d+$/", @$path[4]))
    $data->id = intval($path[4]);
  else
  {
    http_response_code(400);
    die(json_encode(array("code" => 400, "message" => "Identifiant invalide")));
  }
}

if (@$path[3] == 'contacts' AND @$data->id)
  include_once 'contact.php';
else if (@$path[3] == 'contacts')
  include_once 'contacts.php';

if (@$path[3] == 'dossiers' AND @$data->id)
  include_once 'dossier.php';
else if (@$path[3] == 'dossiers')
  include_once 'dossiers.php';

if (@$path[3] == 'dossiers_intervenants' AND @$data->id)
  include_once 'dossiers_intervenant.php';
else if (@$path[3] == 'dossiers_intervenants')
  include_once 'dossiers_intervenants.php';
?>
