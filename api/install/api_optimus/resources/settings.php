<?php
function read($data)
{
  $settings = $db->conn->query("SELECT * FROM `" . $data->db . "`.settings WHERE id LIKE 'dossiers.%'");
  $settings = $settings->fetch(PDO::FETCH_ASSOC);
  return array("code" => 200, "data" => $settings);
}

function create($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function replace($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function update($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function delete($data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}
?>
