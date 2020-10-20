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
  replace($db,$data);
}

function replace($db,$data)
{
  if (!preg_match('/^[a-zA-Z0-9_]+$/', $data->module)) return array("code" => 400, "message" => "Nom de module invalide");
  foreach($data->settings as $key => $value)
  {
    if (!preg_match('/^[a-z0-9_.]+$/', $key)) return array("code" => 400, "message" => "Nom de variable invalide");
    $settings = $db->prepare("REPLACE INTO `" . $data->db . "`.settings VALUES(:id,:value)");
    $settings->bindValue(':id', strip_tags($data->module) . "." . $key, PDO::PARAM_STR);
    $settings->bindValue(':value', str_replace(']"',']',str_replace('"[','[',json_encode($value))), PDO::PARAM_STR);
    if (!$settings->execute())
      return array("code" => 400, "message" => $settings->errorInfo()[2]);
  }
  return array("code" => 200);
}

function update($db,$data)
{
  return array("code" => 501, "message" => 'Méthode non implémentée');
}

function delete($db,$data)
{
  if (!preg_match('/^[a-z0-9_]+$/', $data->module)) return array("code" => 400, "message" => "Nom de module invalide");
  $settings = $db->prepare("DELETE FROM `" . $data->db . "`.settings WHERE id LIKE :module");
  $settings->bindValue(':module', $data->module.'.%', PDO::PARAM_STR);
  if($settings->execute())
    return array("code" => 200);
  else
    return array("code" => 400, "message" => $settings->errorInfo()[2]);
}
?>
