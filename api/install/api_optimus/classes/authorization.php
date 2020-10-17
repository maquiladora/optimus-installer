<?php
class authorization
{
  function list($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (!preg_match("/^[a-z0-9_.]+$/", $data->resource)) return array("code" => 400, "message" => "Resource invalide");

    $dossier = $this->conn->query("SELECT 'read', 'write', 'create', 'delete' FROM `" . $data->db . "`.authorizations WHERE email = '" . $payload['user']->email . "' AND resource = '" . $data->resource . "'");
    if ($dossier->rowCount() == 0)
      return array("code" => 404, "message" => "Ce dossier n'existe pas");
    else
      return array("code" => 200, "data" => $dossier->fetch(PDO::FETCH_ASSOC));
  }


  function create($data,$payload)
  {
    //TO BE DONE
  }

  function delete($data,$payload)
  {
    //TO BE DONE
  }

  function update($data,$payload)
  {
    //TO BE DONE
  }
}
?>
