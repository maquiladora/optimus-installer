<?php
function read($db,$data)
{
  $settings = $db->prepare("SELECT * FROM `" . $data->db . "`.settings WHERE id LIKE :module");
  $settings->bindParam(':module', 'dossiers');
  $settings->execute();
  while ($setting = $settings->fetch(PDO::FETCH_ASSOC))
    $results[$setting['id']] = $setting['value'];
  return array("code" => 200, "data" => $results);
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
