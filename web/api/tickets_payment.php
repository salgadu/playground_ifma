<?php

require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$tickets = $obj['tickets'];

$ids_list = '';

foreach($tickets as $t){
	$ids_list.="$t ,";
}
$ids_list=substr($ids_list, 0,-1);

$query = "UPDATE ticket SET payment=strftime('%Y-%m-%dT%H:%M:%f', 'now') WHERE id IN ($ids_list);";

$result=$sqliteDB->query($query);
if($result){
	echo 'OK';
}else{
	echo 'Error';
}

$sqliteDB=null;

?>