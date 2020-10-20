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
  if (!preg_match('/^[a-zA-Z0-9_]+$/', $data->module)) return array("code" => 400, "message" => "Nom de module invalide");
  foreach($data->settings as $key => $value)
      if (!preg_match('/^[a-z0-9_\[\]\"\']+$/', $key) || !preg_match('/^[a-z0-9_]+$/', $value))
        return array("code" => 400, "message" => "Variable ou valeur invalide");

  foreach($data->settings as $key => $value)
  {
    $setting = $db->prepare("REPLACE INTO `" . $data->db . "`.settings VALUES(:id,:value)");
    $settings->bindValue(':id', strip_tags($data->module) . "." . strip_tags($key), PDO::PARAM_STR);
    $settings->bindValue(':value', str_replace(']"',']',str_replace('"[','[',json_encode(strip_tags($value)))), PDO::PARAM_STR);
    $setting->execute();
  }

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
