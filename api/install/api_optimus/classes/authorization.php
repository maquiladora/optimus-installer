<?php
class authorization
{
  public function __construct($db)
  {
    $this->conn = $db;
  }

  function list($data,$payload)
  {
    if (!preg_match("/^[a-z0-9_@.]+$/", $data->db)) return array("code" => 400, "message" => "Base de données invalide");
    if (!preg_match("/^[a-z0-9_.]+$/", $data->resource)) return array("code" => 400, "message" => "Resource invalide");

    $authorization = $this->conn->query("SELECT 'read', 'write', 'create', 'delete' FROM `" . $data->db . "`.authorizations WHERE email = '" . $payload['user']->email . "' AND resource = '" . $data->resource . "'");
    if ($authorization->rowCount() == 0)
      return array("code" => 404, "message" => "Aucune autorisation sur cette ressource");
    else
      return array("code" => 200, "data" => $authorization->fetch(PDO::FETCH_ASSOC));
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
