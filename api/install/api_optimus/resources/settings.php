<?php
function read($db,$data)
{
  if (!preg_match('/^[a-z0-9_]+$/', $data->module)) return array("code" => 400, "message" => "Nom de module invalide");
  $settings = $db->prepare("SELECT * FROM `" . $data->db . "`.settings WHERE id LIKE :module");
  $settings->bindValue(':module', $data->module.'.%', PDO::PARAM_STR);
  $settings->execute();
  $results = array();
  while ($setting = $settings->fetch(PDO::FETCH_ASSOC))
    $results[substr($setting['id'],strlen($data->module)+1)] = $setting['value'];
  return array("code" => 200, "data" => @$results);
}

function create($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function replace($db,$data)
{
  if (!preg_match('/^[a-z0-9_]+$/', $data->module)) return array("code" => 400, "message" => "Nom de module invalide");
  foreach($data->settings as $key => $value)
    $setting = $db->query("REPLACE INTO `" . $data->db . "`.settings VALUES('" . $data->module . "." . $key . "','" . json_encode($value) . "')");
  return array("code" => 201);
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
