<?php
function read($db,$data)
{
  $authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'dossiers' ORDER BY length(resource) DESC");
  $authorizations->bindParam(':email', $data->user, PDO::PARAM_STR);
  $authorizations->execute();
  $authorizations = $authorizations_contacts->fetch(PDO::FETCH_ASSOC);
  if ($authorizations['read'] == 0)
    return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux dossiers");
  $dossiers = $db->prepare("SELECT id, numero, nom, rg, date_ouverture, date_classement, numero_archive, domaine, CONCAT(domaine,"-",sous_domaine), conseil, aj, id, id FROM `" . $data->db . "`.contacts");
  if($dossiers->execute())
  {
    $dossiers = $dossiers->fetchAll(PDO::FETCH_ASSOC);
    return array("code" => 200, "data" => $dossiers, 'authorizations' => $authorizations);
  }
  else
    return array("code" => 400, "message" => $dossiers->errorInfo()[2]);
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
