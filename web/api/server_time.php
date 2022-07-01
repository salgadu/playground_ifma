<?php

require('connection.php');

$result=$sqliteDB->query("select datetime();");

if($result){
    echo $result->fetch()["datetime()"];
}else{
	echo 'Error';
}

// foreach($result as $row){
//     echo $row["datetime()"] . "\n";
// }

$sqliteDB=null;

?>

