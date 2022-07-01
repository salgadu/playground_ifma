<?php
require('connection.php');

$json = file_get_contents('php://input');
$obj = json_decode($json,true);

$student = $obj['student'];
$meal = $obj['meal'];
$day = substr(date('c'),0,19);

$query = "SELECT id FROM ticket WHERE student='$student' AND meal=$meal AND status IN (0,1,4,5) AND date BETWEEN strftime('%Y-%m-%dT00:00:00.000000', '$day') AND strftime('%Y-%m-%dT23:59:59.000000', '$day');";

// echo json_encode($query);

$result=$sqliteDB->query($query);

if($result){
    $res_array = array();
    foreach($result as $row){
        array_push(
            $res_array, array(
                "id"=>$row['id'],
            )
        );
    }

    if(empty($res_array)){
        echo '';
    }else{
        echo json_encode($res_array);
    }

}else{
    echo '';
}

$sqliteDB=null;

?>