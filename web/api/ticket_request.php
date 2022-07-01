<?php

require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$student = $obj['student'];
$status = $obj['status'];
$date = $obj['date'];
$meal = $obj['meal'];
$reason = $obj['reason'];
$text = $obj['text'];
$payment = $obj['payment'];

$hour=intval(date('H'));
if ((($meal==1)&&(($hour>9)||($hour<6)))||(($meal==2)&&(($hour>17)||($hour<14)))){
	echo '';
}else{
	$insertQuery = "INSERT INTO ticket ( student, status, date, meal, reason, text, payment ) 
	VALUES ( '$student', $status, strftime('%Y-%m-%dT%H:%M:%f', 'now'), $meal, '$reason', '$text', '$payment' );";

	$result=$sqliteDB->query($insertQuery);

	if($result){
		echo $sqliteDB->lastInsertId();
	}else{
		echo '';
	}
}

$sqliteDB=null;

?>