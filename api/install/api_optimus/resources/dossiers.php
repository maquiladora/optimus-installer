<?php
function read($db,$data)
{
  $authorizations = $db->prepare("SELECT `read`, `write`, `create`, `delete` FROM `" . $data->db . "`.authorizations WHERE email = :email AND resource = 'dossiers' ORDER BY length(resource) DESC");
  $authorizations->bindParam(':email', $data->user, PDO::PARAM_STR);
  $authorizations->execute();
  $authorizations = $authorizations->fetch(PDO::FETCH_ASSOC);
  if ($authorizations['read'] == 0)
    return array("code" => 403, "message" => "Vous n'avez pas les autorisations suffisantes pour accéder aux dossiers");

  $sousdomaines['0-0'] = 'inconnu';
  $sousdomaines['0'] = 'inconnu';

  $query = datagrid_request($data,$db);
  //SUBSTITUTIONS ICI
  $dossiers = $db->prepare($query);
  if($dossiers->execute())
  {
    if (@$data->page)
      $dossiers = $dossiers->fetchAll(PDO::FETCH_NUM);
    else
      $dossiers = $dossiers->fetchAll(PDO::FETCH_ASSOC);
    return array("code" => 200, "data" => $dossiers, 'authorizations' => $authorizations);
  }
  else
    return array("code" => 400, "message" => $dossiers->errorInfo()[2], "query" => $query);

  //retourner le total
  //retourner une array si pas requete datagrid
}


function datagrid_request($data,$db)
{
  //START
  $query = "SELECT SQL_CALC_FOUND_ROWS ";

  //CHAMPS
  foreach ($data->columns as $key => $column)
  	$query .= $column->field . ',';
  $query = substr($query,0,-1);

  //BASE
  $query .= " FROM `" . $data->db . "`." .  $data->db_table;
  $query .= " WHERE id > 0";

  //GLOBAL SEARCH
  if ($data->global_search)
  {
  	$query .= " AND (";
  	foreach ($data->columns as $key => $column)
  		if ($column->dblink == null)
  			$query .= $column->field . " LIKE '%" . $data->global_search . "%' OR ";
  		else
  		{
  			unset($rowsearch);
  			foreach (${$column->dblink} as $key => $value)
  				if (preg_match("/" . $data->global_search . "/i", $value))
  					@$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				if (is_array($rowsearch))
  					$query .= $column->field . " IN (" . implode($rowsearch,',') . ") OR ";
  		}
  	$query = substr($query,0,-4) . ')';
  }

  return $query;

  //COLUMN SEARCH
  if ($data->column_search)
  	foreach ($data->column_search as $col)
  		if ($data->columns[$col[0]]['dblink'] == null)
  		{
  			if ($data->columns[$col[0]]['data_type']=='text' OR $data->columns[$col[0]]['datatype']=='date')
  				$query .= " AND " .$data->columns[$col[0]]['field'] . " LIKE '%" . data_format($col[1],$data->columns[$col[0]]['data_type'],$db) . "%'";
  			else
  				$query .= " AND " .$data->columns[$col[0]]['field'] . " = '" . data_format($col[1],$data->columns[$col[0]]['data_type'],$db) . "'";
  		}
  		else
  		{
  			unset($rowsearch);
  			foreach ($data->columns[$col[0]]['dblink'] as $key => $value)
  			{
  				if ($data->columns[$col[0]]['data_type']=='text' OR $data->columns[$col[0]]['data_type']=='date')
  				{
  					if (preg_match("/" . data_format($col[1],$data->columns[$col[0]]['data_type'],$db) . "/i", $value))
  						$rowsearch[] = "'".$key."'";
  				}
  				else
  				{
  					if (data_format($col[1],$data->columns[$col[0]]['data_type'],$db)==$value)
  						$rowsearch[] = $key;
  				}
  			}
  			if (is_array($rowsearch))
  				$query .= " AND " . $data->columns[$col[0]]['field'] . " IN (" . implode($rowsearch,',') . ")";
  			else
  				$query .= ' AND 1=0';
  		}

  //ADVANCED SEARCH
  if ($data->advanced_search)
  {
  	$query .= " AND (";
  	foreach ($data->advanced_search as $col)
  		if ($data->columns[$col[0]]['dblink'] == null)
  		{
  			if ($col[1] == "==")
  				$query .= $data->columns[$col[0]]['field'] . "= '" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			if ($col[1] == "<>" OR $col[1] == ">" OR $col[1] == ">=" OR $col[1] == "<" OR $col[1] == "<=")
  				$query .= $data->$columns[$col[0]]['field'] . $col[1] . " '" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "LIKE%")
  				$query .= $data->$columns[$col[0]]['field'] . " LIKE '" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%LIKE%")
  				$query .= $data->$columns[$col[0]]['field'] . " LIKE '%" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%LIKE")
  				$query .= $data->$columns[$col[0]]['field'] . " LIKE '%" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "NOT LIKE%")
  				$query .= $data->$columns[$col[0]]['field'] . " NOT LIKE '" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%NOT LIKE%")
  				$query .= $data->$columns[$col[0]]['field'] . " NOT LIKE '%" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%NOT LIKE")
  				$query .= $data->$columns[$col[0]]['field'] . " NOT LIKE '%" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "' " .(($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "IS NULL")
  				$query .= $data->$columns[$col[0]]['field'] . " IS NULL " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "IS NOT NULL")
  				$query .= $data->$columns[$col[0]]['field'] . " IS NOT NULL " . (($col[3]=='AND')?'AND':'OR') . " ";
  		}
  		else
  		{
  			unset($rowsearch);
  			foreach ($data->columns[$col[0]]['dblink'] as $key => $value)
  				if ($col[1] == "==" AND $value == data_format($col[2],$data->columns[$col[0]]['data_type'],$db))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "<>" AND $value != data_format($col[2],$data->columns[$col[0]]['data_type'],$db))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == ">" AND $value > data_format($col[2],$data->columns[$col[0]]['data_type'],$db))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == ">=" AND $value >= data_format($col[2],$data->columns[$col[0]]['data_type'],$db))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "<" AND $value < data_format($col[2],$data->columns[$col[0]]['data_type'],$db))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "<=" AND $value <= data_format($col[2],$data->columns[$col[0]]['data_type'],$db))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "LIKE%" AND preg_match("/^" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%LIKE%" AND preg_match("/" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%LIKE" AND preg_match("/" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "$/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "NOT LIKE%" AND !preg_match("/^" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%NOT LIKE%" AND !preg_match("/" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%NOT LIKE" AND !preg_match("/" . data_format($col[2],$data->columns[$col[0]]['data_type'],$db) . "$/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "IS NULL")
  					$rowsearch = [0];
  				else if ($col[1] == "IS NOT NULL" AND $key!=0)
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";

  				if (is_array($rowsearch))
  					$query .= $data->$columns[$col[0]]['field'] . " IN (" . implode($rowsearch,',') . ") " . (($col[3]=='AND')?'AND':'OR') . " ";
  				else
  					$query .= '1=0 ' . (($col[3]=='AND')?'AND':'OR') . " ";
  		}
  	$query = substr($query,0,-4) . ')';
  }
  return $query;
}

function data_format($value,$type,$db)
{
	if ($type=='date')
	{
		if (substr($value,2,1)=='/')
			return mysqli_real_escape_string($db,substr($value,6,4) . '-' . substr($value,3,2) . '-' . substr($value,0,2));
		else
			return mysqli_real_escape_string($db,$value);
	}
	else if ($type=='integer')
		return intval($value);
	else if ($type=='decimal')
		return floatval($value);
	else if ($type=='money')
		return floatval($value);
	else if ($type=='rate')
		return floatval($value);
	else
		return mysqli_real_escape_string($db,$value);
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
