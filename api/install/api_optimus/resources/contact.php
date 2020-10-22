<?php
function read($db,$data)
{
	$authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'contacts' or resource = 'contacts." . $data->id . "') ORDER BY length(resource) DESC");
	$authorizations->bindParam(':email', $data->user);
	$authorizations->execute();
	$authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
	if ($authorizations['read'] == 0)
	return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder à ce contact");

	if (@$data->fields)
	{
		$database_fields = $db->query("SELECT DISTINCT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'contacts'");
		while ($database_field = $database_fields->fetch(PDO::FETCH_ASSOC))
			$fields[$database_field['COLUMN_NAME']] = $database_field['DATA_TYPE'];
		foreach($data->fields as $field)
			if (!array_key_exists($field, $fields))
				return array("code" => 400, "message" => "Le champ " . $field . " n'existe pas dans la table contacts");

		$contact = $db->prepare("SELECT " . implode(',', $data->fields) . " FROM `" . $data->db . "`.contacts WHERE id = :id");
	}
	else
		$contact = $db->prepare("SELECT * FROM `" . $data->db . "`.contacts WHERE id = :id");

	$contact->bindParam(':id', $data->id, PDO::PARAM_INT);
	$contact->execute();
	if ($contact->rowCount() == 0)
		return array("code" => 404, "message" => "Ce contact n'existe pas");
	else
	{
		$contact = $contact->fetch(PDO::FETCH_ASSOC);
		return array("code" => 200, "data" => $contact, "authorizations" => $authorizations);
	}
}


function create($db,$data)
{
	$authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'contacts'");
	$authorizations->bindParam(':email', $data->user, PDO::PARAM_STR);
	$authorizations->execute();
	$authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
	if ($authorizations['create'] == 0)
		return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

	if (@!$data->values->lastname)
		$data->values->lastname = 'CLIENT ' . time();

	$database_fields = $db->query("SELECT DISTINCT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'contacts'");
	while ($database_field = $database_fields->fetch(PDO::FETCH_ASSOC))
		$fields[$database_field['COLUMN_NAME']] = $database_field['DATA_TYPE'];
	if (@$data->values)
		foreach($data->values as $key => $value)
			if (!array_key_exists($key, $fields))
				return array("code" => 400, "message" => "Le champ " . $key . " n'existe pas dans la table contacts");

	$query = "INSERT INTO `" . $data->db . "`.contacts SET ";
	if (@$data->values)
	{
		foreach($data->values as $key => $value)
			$query .= $key.'=:'.$key.',';
		$query = substr($query,0,-1);

		$contact = $db->prepare($query);
		foreach($data->values as $key => $value)
			if ($fields[$key] == 'bit' OR $fields[$key] == 'tinyint' OR $fields[$key] == 'smallint' OR $fields[$key] == 'mediumint' OR $fields[$key] == 'int' OR $fields[$key] == 'bigint')
			{
				if ($value=='')
					$contact->bindValue(':'.$key, null, PDO::PARAM_NULL);
				else
					$contact->bindParam(':'.$key, $data->values->$key, PDO::PARAM_INT);
			}
			else if (($fields[$key] == 'date' OR $fields[$key] == 'datetime') AND $value =='')
				$contact->bindValue(':'.$key, null, PDO::PARAM_NULL);
			else
				$contact->bindParam(':'.$key, $data->values->$key, PDO::PARAM_STR);
	}

	if($contact->execute())
		return array("code" => 201, "data" => $db->lastInsertId(), "authorizations" => $authorizations);
	else
		return array("code" => 400, "message" => $contact->errorInfo()[2]);
}


function replace($db,$data)
{
	delete($db,$data);
	$data->values->id = $data->id;
	return create($db,$data);
}


function modify($db,$data)
{
	$authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'contacts' OR resource = 'contacts." . $data->id . "' OR resource = 'contacts." . $data->id . "." . $data->field . "') ORDER BY length(resource) DESC");
	$authorizations->bindParam(':email', $data->user);
	$authorizations->execute();
	$authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
	if ($authorizations['write'] == 0)
		return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

	$exists = $db->query("SELECT id FROM `" . $data->db . "`.contacts WHERE id = " . $data->id);
	if ($exists->rowCount() == 0)
		return array("code" => 404, "message" => "Ce contact n'existe pas");

	$database_fields = $db->query("SELECT DISTINCT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'contacts'");
	while ($database_field = $database_fields->fetch(PDO::FETCH_ASSOC))
		$fields[$database_field['COLUMN_NAME']] = $database_field['DATA_TYPE'];
	if (@$data->values)
		foreach($data->values as $key => $value)
			if (!array_key_exists($key, $fields))
				return array("code" => 400, "message" => "Le champ " . $key . " n'existe pas dans la table contacts");

	$query = "UPDATE `" . $data->db . "`.contacts SET ";
	if (@$data->values)
	{
		foreach($data->values as $key => $value)
			$query .= $key.'=:'.$key.',';
		$query = substr($query,0,-1);

		$contact = $db->prepare($query);
		foreach($data->values as $key => $value)
			if ($fields[$key] == 'bit' OR $fields[$key] == 'tinyint' OR $fields[$key] == 'smallint' OR $fields[$key] == 'mediumint' OR $fields[$key] == 'int' OR $fields[$key] == 'bigint')
			{
				if ($value=='')
					$contact->bindValue(':'.$key, null, PDO::PARAM_NULL);
				else
					$contact->bindParam(':'.$key, $data->values->$key, PDO::PARAM_INT);
			}
			else if (($fields[$key] == 'date' OR $fields[$key] == 'datetime') AND $value =='')
				$contact->bindValue(':'.$key, null, PDO::PARAM_NULL);
			else
				$contact->bindParam(':'.$key, $data->values->$key, PDO::PARAM_STR);
	}

	if($contact->execute())
		return array("code" => 201, "data" => $db->lastInsertId(), "authorizations" => $authorizations);
	else
		return array("code" => 400, "message" => $contact->errorInfo()[2]);
}


function delete($db,$data)
{
	$authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND (resource = 'contacts' OR resource = 'contacts." . $data->id . "') ORDER BY length(resource) DESC");
	$authorizations->bindParam(':email', $data->user);
	$authorizations->execute();
	$authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
	if ($authorizations['delete'] == 0)
		return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour effectuer cette action");

	$contact = $db->query("SELECT * FROM `" . $data->db . "`.contacts WHERE id = '" . $data->id . "'");
	if ($contact->rowCount() == 0)
		return array("code" => 404, "message" => "Ce contact n'existe pas");
	else
		$contact = $contact->fetch();

	$intervenants_exists = $db->query("SELECT id FROM `" . $data->db . "`.dossiers_intervenants WHERE contact = '" . $data->id . "'")->rowCount();
	if ($intervenants_exists > 0)
		return array("code" => 400, "message" => "Ce contact ne peut pas être supprimé car il intervient dans un ou plusieurs dossiers");

  //A FAIRE : CHECKER si le contact apparait dans une facture
  //$factures_exists = $this->conn->query("SELECT id FROM optimus_user_1.interventions WHERE dossier = '" . $data->id . "' AND db IS NOT NULL")->rowCount();
  //if ($factures_exists > 0)
    //return array("code" => 400, "message" => "Ce dossier ne peut pas être supprimé car des factures le concernant ont été émises");

	$contact_delete = $db->prepare("DELETE FROM `" . $data->db . "`.contacts WHERE id = :id");
	$contact_delete->bindParam(':id', $data->id, PDO::PARAM_INT);
	if($contact_delete->execute())
		return array("code" => 200);
	else
		return array("code" => 400, "message" => $contact_delete->errorInfo()[2]);
}
?>
