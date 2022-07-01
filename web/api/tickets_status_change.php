<?php

require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$tickets = $obj['tickets'];
$status = $obj['status'];
$permanent = $obj['permanent'];

$ids_list = '';

foreach($tickets as $t){
	$ids_list.="$t ,";
}
$ids_list=substr($ids_list, 0,-1);

if($permanent){
	$query = "UPDATE ticket_auth SET status=$status WHERE id IN ($ids_list);";
}else{
	$query = "UPDATE ticket SET status=$status WHERE id IN ($ids_list);";
}

$result=$sqliteDB->query($query);
if($result){
	echo 'OK';
}else{
	echo 'Error';
}

$sqliteDB=null;

?>