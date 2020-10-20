<?php
include_once('api_optimus/datagrid.php');

function read($db,$data)
{
  $authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'dossiers' ORDER BY length(resource) DESC");
  $authorizations->bindParam(':email', $data->user, PDO::PARAM_STR);
  $authorizations->execute();
  $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
  if ($authorizations['read'] == 0)
    return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux dossiers");

  $domaineslist = file_get_contents('https://api.optimus-avocats.fr/constants/?data={"db":"dossiers_domaines"}');
  $domaineslist = json_decode($domaineslist, true);
  foreach ($domaineslist['data'] as $domaine)
  	$domaines[$domaine['id']] = $domaine['value'];

  $sousdomaineslist = file_get_contents('https://api.optimus-avocats.fr/constants/?data={"db":"dossiers_sousdomaines"}');
  $sousdomaineslist = json_decode($sousdomaineslist, true);
  foreach ($sousdomaineslist['data'] as $sousdomaine)
  	$sousdomaines[$sousdomaine['id']] = $sousdomaine['value'];

  $query = datagrid_request($db,$data);

  $dossiers = $db->prepare($query);
  if($dossiers->execute())
  {
    if (@$data->results)
    {
      while($dossier = $dossiers->fetch(PDO::FETCH_NUM))
      {
        foreach ($data->columns as $key => $column)
          if ($column->dblink)
            $dossier[$key] = array(@${$column->dblink}[$dossier[$key]],$dossier[$key]);
        $results[] = $dossier;
      }
      if ($results AND $data->sorts)
        $results = datagrid_sort($results,$data->sorts);
      if ($results AND $data->page AND $data->results)
        $results = datagrid_limit($results, $data->page, $data->results);
      $total = $db->query('SELECT FOUND_ROWS()')->fetchColumn();
    }
    else
      $results = $dossiers->fetchAll(PDO::FETCH_ASSOC);
    return array("code" => 200, "data" => $results, 'authorizations' => $authorizations, "total" => $total);
  }
  else
    return array("code" => 400, "message" => $dossiers->errorInfo()[2], "query" => $query);

  //retourner le total
  //retourner une array si pas requete datagrid
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
