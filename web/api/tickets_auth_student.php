<?php
require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$student = $obj['student'];

$query = "SELECT * FROM ticket_auth WHERE student = '$student' ORDER BY id DESC;";

$result=$sqliteDB->query($query);

if($result){
    $res_array = array();
    foreach($result as $row){
        array_push(
            $res_array, array(
                "id"=>$row['id'],
                "student"=>$row['student'],
                "status"=>(int)$row['status'],
                "date"=>$row['date'],
                "meal"=>(int)$row['meal'],
                "reason"=>$row['reason'],
                "text"=>$row['text'],
                "days"=>$row['days'],
            )
        );
    }
    
    echo json_encode($res_array);
}else{
	echo '';
}

$sqliteDB=null;

?>