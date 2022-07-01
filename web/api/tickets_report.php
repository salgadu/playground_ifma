<?php
require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$day = $obj['day'];

$query = "SELECT * FROM ticket WHERE date BETWEEN strftime('%Y-%m-%dT00:00:00.000000', '$day') AND strftime('%Y-%m-%dT23:59:59.000000', '$day') ORDER BY status;";

// echo json_encode($query);

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
                "payment"=>$row['payment'],
            )
        );
    }
    
    echo json_encode($res_array);
}else{
    echo '';
}

$sqliteDB=null;

?>