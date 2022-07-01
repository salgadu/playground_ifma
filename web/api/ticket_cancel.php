<?php

require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$id = $obj['id'];

$query = "UPDATE ticket SET status = 2 WHERE id= '$id';";

$result=$sqliteDB->query($query);
if($result){
	echo 'OK';
}else{
	echo 'Error';
}

$sqliteDB=null;

?>