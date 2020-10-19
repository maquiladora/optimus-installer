<?php
function read($db,$data)
{
  $settings = $db->query("SELECT * FROM `" . $data->db . "`.settings WHERE id LIKE 'dossiers.%'");
  $settings = $settings->fetch(PDO::FETCH_ASSOC);
  return array("code" => 200, "data" => $settings);
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
