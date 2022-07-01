<?php

 $json = file_get_contents('php://input');
 $obj = json_decode($json,true);

 $ldaprdn = $obj['matricula'];
 $ldappass = $obj['senha'];

if($ldaprdn){
	if($ldappass){
 		$ldapconn = ldap_connect("ldap://10.9.10.50:389") or die("Could not connect to LDAP server.");

		if ($ldapconn){

			$ldapbind = ldap_bind($ldapconn, "CN=$ldaprdn,OU=Alunos,OU=CAMP-CAX,OU=IFMA,DC=ifma,DC=edu", $ldappass);
    			if ($ldapbind){
				$result = ldap_search($ldapconn, "OU=Alunos,OU=CAMP-CAX,OU=IFMA,DC=ifma,DC=edu", "(samaccountname=$ldaprdn)", array("displayName"));
				$data = ldap_get_entries($ldapconn, $result);
				$name=utf8_encode($data["0"]['displayname']["0"]);
				
				$user_json = json_encode("OK:$name");
				echo $user_json;
			}else{
				$error_json = json_encode("Login ou senha invalido");
        			echo $error_json;
    			}
		}else{
			echo json_encode("Falha na autenticacao");
		}
	}else{
		echo json_encode("Preencher senha");
	}
}else{
	echo json_encode("Preencher matricula");
}
?>
