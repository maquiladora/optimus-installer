<?php
include_once('api_optimus/datagrid.php');

function read($db,$data)
{
  if (@$data->db_table AND @$data->db_table != 'dossiers') return array("code" => 400, "message" => "La valeur db_table doit être 'dossiers'");

  $authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'dossiers' ORDER BY length(resource) DESC");
  $authorizations->bindParam(':email', $data->user, PDO::PARAM_STR);
  $authorizations->execute();
  $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
  if ($authorizations['read'] == 0)
    return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux dossiers");

  if ($data->db_table)
  {
    $domaineslist = file_get_contents('https://api.optimus-avocats.fr/constants/?data={"db":"dossiers_domaines"}');
    $domaineslist = json_decode($domaineslist, true);
    foreach ($domaineslist['data'] as $domaine)
    	$dblink['domaines'][$domaine['id']] = $domaine['value'];

    $sousdomaineslist = file_get_contents('https://api.optimus-avocats.fr/constants/?data={"db":"dossiers_sousdomaines"}');
    $sousdomaineslist = json_decode($sousdomaineslist, true);
    foreach ($sousdomaineslist['data'] as $sousdomaine)
    	$dblink['sousdomaines'][$sousdomaine['id']] = $sousdomaine['value'];

    $results = datagrid_request($db, $data, $dblink);
    $total = $db->query('SELECT FOUND_ROWS()')->fetchColumn();

    return array("code" => 200, "data" => $results, 'authorizations' => $authorizations, "total" => $total);
  }
  else
  {
    $dossiers = $db->prepare("SELECT * FROM `" . $data->db . "`.dossiers");
    if($dossiers->execute())
    {
      $dossiers = $dossiers->fetchAll(PDO::FETCH_ASSOC);
      return array("code" => 200, "data" => $contacts, 'authorizations' => $authorizations_contacts);
    }
    else
      return array("code" => 400, "message" => $dossiers->errorInfo()[2]);
  }
}






function create($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function replace($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function update($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function delete($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}
?>
