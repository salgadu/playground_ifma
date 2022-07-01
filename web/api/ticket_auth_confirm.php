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
$days = json_decode($obj['days']);

$today=date('w')-1;
if($today<0){
	$today=6;
}

if (!in_array($today,$days)){
	echo ''; // echo 'A autorização não corresponde ao dia de hoje.';
}else{
	$hour=intval(date('H'));
	if ((($meal==1)&&(($hour>=11)||($hour<6)))||(($meal==2)&&(($hour>=19)||($hour<14)))){ // Almoço: 6h-11h  | Jantar: 14h-19h
		echo ''; // echo 'Confirmação fora do horário limite.';
	}else{
		$insertQuery = "INSERT INTO ticket ( student, status, date, meal, reason, text, payment ) 
								VALUES ( '$student', '$status', strftime('%Y-%m-%dT%H:%M:%f', 'now'), $meal, '$reason', '$text', '' );";

		$result=$sqliteDB->query($insertQuery);

		if($result){
			echo $sqliteDB->lastInsertId();
		}else{
			echo '';
		}
	}
}

$sqliteDB=null;

?>