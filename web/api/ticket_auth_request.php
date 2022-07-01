<?php

require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$date = $obj['date'];
$student = $obj['student'];
$status = $obj['status'];
$meal = $obj['meal'];
$reason = $obj['reason'];
$text = $obj['text'];
$days = $obj['days'];

$insertQuery = "INSERT INTO ticket_auth ( student, date, status, meal, reason, text, days ) 
							VALUES ( '$student', strftime('%Y-%m-%dT%H:%M:%f', 'now'), $status, $meal, '$reason', '$text', '$days' );";

$result=$sqliteDB->query($insertQuery);

if($result){
	echo $sqliteDB->lastInsertId();
}else{
	echo '';
}

$sqliteDB=null;

?>