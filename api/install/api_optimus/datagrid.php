<?php

function datagrid_request($db,$data,$dblink)
{
  $data = datagrid_validation($data);
  $query = datagrid_query($data,$dblink);
  $results = datagrid_fetch($db,$data,$query,$dblink);
  if ($results AND $data->sorts)
    $results = datagrid_sort($results,$data->sorts);
  if ($results AND $data->page AND $data->results)
    $results = datagrid_limit($results, $data->page, $data->results);
  return $results;
}

function datagrid_validation($data)
{
  foreach($data->columns as $key => $column)
    if (!preg_match("/^[a-z0-9_]+$/", $column->field)) return die(json_encode(array("code" => 400, "message" => "Champ invalide")));

    //advanced_search
    //column_search
    //global_search

  return $data;

}

function datagrid_query($data,$dblink)
{
  //START
  $query = "SELECT SQL_CALC_FOUND_ROWS ";

  //CHAMPS
  foreach ($data->columns as $key => $column)
  	$query .= $column->field . ',';
  $query = substr($query,0,-1);

  //BASE
  $query .= " FROM `" . $data->db . "`." .  $data->db_table;
  $query .= " WHERE 1=1";

  //GLOBAL SEARCH
  if ($data->global_search)
  {
  	$query .= ' AND (';
  	foreach ($data->columns as $key => $column)
  		if ($column->dblink == null)
  			$query .= $column->field . " LIKE '%" . data_format($data->global_search,$column->data_type) . "%' OR ";
  		else
  		{
  			unset($rowsearch);

  			foreach ($dblink[$column->dblink] as $key => $value)
  				if (preg_match("/" . addslashes($data->global_search) . "/i", $value))
  					@$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				if (is_array(@$rowsearch))
  					$query .= $column->field . " IN (" . implode($rowsearch,',') . ") OR ";
  		}
  	$query = substr($query,0,-4) . ')';
  }

  //COLUMN SEARCH
  if ($data->column_search)
  	foreach ($data->column_search as $key => $col)
  		if ($data->columns[$col[0]]->dblink == null)
  		{
  			if ($data->columns[$col[0]]->data_type=='text' OR $data->columns[$col[0]]->data_type=='date')
  				$query .= " AND " .$data->columns[$col[0]]->field . " LIKE '%" . data_format($col[1],$data->columns[$col[0]]->data_type) . "%'";
  			else
  				$query .= " AND " .$data->columns[$col[0]]->field . " = '" . data_format($col[1],$data->columns[$col[0]]->data_type) . "'";
  		}
  		else
  		{
  			unset($rowsearch);
  			foreach ($dblink[$data->columns[$col[0]]->dblink] as $key => $value)
  			{
  				if ($data->columns[$col[0]]->data_type=='text' OR $data->columns[$col[0]]->data_type=='date')
  				{
  					if (preg_match("/" . data_format($col[1],$data->columns[$col[0]]->data_type) . "/i", $value))
  						$rowsearch[] = "'".$key."'";
  				}
  				else
  				{
  					if (data_format($col[1],$data->columns[$col[0]]->data_type)==$value)
  						$rowsearch[] = $key;
  				}
  			}
  			if (is_array($rowsearch))
  				$query .= " AND " . $data->columns[$col[0]]->field . " IN (" . implode($rowsearch,',') . ")";
  			else
  				$query .= ' AND 1=0';
  		}


  //ADVANCED SEARCH
  if ($data->advanced_search)
  {
  	$query .= ' AND (';
  	foreach ($data->advanced_search as $key => $col)
  		if ($data->columns[$col[0]]->dblink == null)
  		{
  			if ($col[1] == "==")
  				$query .= $data->columns[$col[0]]->field . "= '" . data_format($col[2],$data->columns[$col[0]]->data_type) . "' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			if ($col[1] == "<>" OR $col[1] == ">" OR $col[1] == ">=" OR $col[1] == "<" OR $col[1] == "<=")
  				$query .= $data->columns[$col[0]]->field . $col[1] . " '" . data_format($col[2],$data->columns[$col[0]]->data_type) . "' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "LIKE%")
  				$query .= $data->columns[$col[0]]->field . " LIKE '" . data_format($col[2],$data->columns[$col[0]]->data_type) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%LIKE%")
  				$query .= $data->columns[$col[0]]->field . " LIKE '%" . data_format($col[2],$data->columns[$col[0]]->data_type) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%LIKE")
  				$query .= $data->columns[$col[0]]->field . " LIKE '%" . data_format($col[2],$data->columns[$col[0]]->data_type) . "' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "NOT LIKE%")
  				$query .= $data->columns[$col[0]]->field . " NOT LIKE '" . data_format($col[2],$data->columns[$col[0]]->data_type) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%NOT LIKE%")
  				$query .= $data->columns[$col[0]]->field . " NOT LIKE '%" . data_format($col[2],$data->columns[$col[0]]->data_type) . "%' " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "%NOT LIKE")
  				$query .= $data->columns[$col[0]]->field . " NOT LIKE '%" . data_format($col[2],$data->columns[$col[0]]->data_type) . "' " .(($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "IS NULL")
  				$query .= $data->columns[$col[0]]->field . " IS NULL " . (($col[3]=='AND')?'AND':'OR') . " ";
  			else if ($col[1] == "IS NOT NULL")
  				$query .= $data->columns[$col[0]]->field . " IS NOT NULL " . (($col[3]=='AND')?'AND':'OR') . " ";
  		}
  		else
  		{
  			unset($rowsearch);
  			foreach ($dblink[$data->columns[$col[0]]->dblink] as $key => $value)
  				if ($col[1] == "==" AND $value == data_format($col[2],$data->columns[$col[0]]->data_type))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "<>" AND $value != data_format($col[2],$data->columns[$col[0]]->data_type))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == ">" AND $value > data_format($col[2],$data->columns[$col[0]]->data_type))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == ">=" AND $value >= data_format($col[2],$data->columns[$col[0]]->data_type))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "<" AND $value < data_format($col[2],$data->columns[$col[0]]->data_type))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "<=" AND $value <= data_format($col[2],$data->columns[$col[0]]->data_type))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "LIKE%" AND preg_match("/^" . data_format($col[2],$data->columns[$col[0]]->data_type) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%LIKE%" AND preg_match("/" . data_format($col[2],$data->columns[$col[0]]->data_type) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%LIKE" AND preg_match("/" . data_format($col[2],$data->columns[$col[0]]->data_type) . "$/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "NOT LIKE%" AND !preg_match("/^" . data_format($col[2],$data->columns[$col[0]]->data_type) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%NOT LIKE%" AND !preg_match("/" . data_format($col[2],$data->columns[$col[0]]->data_type) . "/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "%NOT LIKE" AND !preg_match("/" . data_format($col[2],$data->columns[$col[0]]->data_type) . "$/i", $value))
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";
  				else if ($col[1] == "IS NULL")
  					$rowsearch = [0];
  				else if ($col[1] == "IS NOT NULL" AND $key!=0)
  					$rowsearch[] = (is_numeric($key))? $key : "'".$key."'";

  				if (is_array($rowsearch))
  					$query .= $data->$columns[$col[0]]->field . " IN (" . implode($rowsearch,',') . ") " . (($col[3]=='AND')?'AND':'OR') . " ";
  				else
  					$query .= '1=0 ' . (($col[3]=='AND')?'AND':'OR') . " ";
  		}
  	$query = substr($query,0,-4) . ')';
  }
  return $query;
}


function datagrid_fetch($db,$data,$query,$dblink)
{
  $fetched_results = $db->prepare($query);
  if($fetched_results->execute())
  {
    while($fetched_result = $fetched_results->fetch(PDO::FETCH_NUM))
    {
      foreach ($data->columns as $key => $column)
        if ($column->dblink)
          $fetched_result[$key] = array(@$dblink[$column->dblink][$fetched_result[$key]],$fetched_result[$key]);
      $results[] = $fetched_result;
    }
    return @$results;
  }
  else
    return $fetched_results->errorInfo()[2];
}

function datagrid_sort($data, $sorts)
{
  foreach($sorts as $key => $column)
    if ($column >= 0)
      $sorts_arr[round(abs($column))] = 'SORT_DESC';
    else
      $sorts_arr[round(abs($column))] = 'SORT_ASC';

  $colarr = array();
  foreach ($sorts_arr as $col => $ordr)
  {
    $colarr[$col] = array();
    foreach ($data as $k => $row)
      $colarr[$col]['_'.$k] = $row[$col];
  }

  $multi_params = array();
  foreach ($sorts_arr as $col => $ordr)
  {
    $multi_params[] = '$colarr[\'' . $col .'\']';
    $multi_params[] = $ordr;
  }
  $rum_params = implode(',',$multi_params);
  eval("array_multisort({$rum_params});");
  $sorted_array = array();
  foreach ($colarr as $col => $arr)
    foreach ($arr as $k => $v)
    {
      $k = substr($k,1);
      if (!isset($sorted_array[$k]))
        $sorted_array[$k] = $data[$k];
      $sorted_array[$k][$col] = $data[$k][$col];
    }

  return array_values($sorted_array);
}


function datagrid_limit($data,$page,$results)
{
  return array_slice($data,($page-1)*$results,$results);
}


function data_format($value,$type)
{
	if ($type=='date')
	{
		if (substr($value,2,1)=='/' AND substr($value,5,1)=='/')
			return substr($value,6,4) . '-' . substr($value,3,2) . '-' . substr($value,0,2);
		else
			return $value;
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
		return $value;
}
