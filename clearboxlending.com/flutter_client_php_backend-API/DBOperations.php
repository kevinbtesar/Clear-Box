<?php

ini_set ('display_errors', 'on');
ini_set ('log_errors', 'on');
ini_set ('display_startup_errors', 'on');
ini_set ('error_reporting', E_ALL);
//$CFG->debug = 30719; // DEBUG_ALL, but that constant is not defined here.


class DBOperations{

	 private $host = 'localhost';
	 private $user = 'root_clearbo';
	 private $db = 'root_clearbo';
	 private $pass = 'mrQDx0Ne';
	 private $conn;

public function __construct() {

	$this -> conn = new PDO("mysql:host=".$this -> host.";dbname=".$this -> db, $this -> user, $this -> pass);

}


 public function insertData($user_firstName, $user_lastName,$user_email,$user_pass){

    $date = date_create();
    $date = $date->format('Y-m-d H:i:s');;
    $encrypted_password =  $this->getHash($user_pass);

 	//$unique_id = uniqid('', true);
    //$hash = $this->getHash($user_pass);
    //$encrypted_password = $hash["encrypted"];
    //$salt = $hash["salt"];
    
     $sql = "INSERT INTO wp_users SET user_login = '" . $user_email . "', user_nicename = '" . $user_lastName . 
     "', display_name = '" . $user_firstName . "', user_email = '" . $user_email . "', 
     user_pass = '" . $encrypted_password . "', user_registered = '" . $date . "'";

file_put_contents('/home/sage1o1/public_html/clearboxlending.com/api/e.log', PHP_EOL . 'SQL: ' . $sql, FILE_APPEND);

 	$query = $this ->conn ->prepare($sql);
 	$query->execute(/*array(':user_login' => $user_email, ':user_nicename' => $user_lastName, ':user_email' => $user_email,
     ':display_name' => $user_firstName, ':encrypted_password' => $encrypted_password)*/);

    if ($query) {

        return true;

    } else {

        return false;

    }
 }


 public function checkLogin($email, $password) {

    $sql = 'SELECT * FROM wp_users WHERE email = :email';
    $query = $this -> conn -> prepare($sql);
    $query -> execute(array(':email' => $email));
    $data = $query -> fetchObject();
    $salt = $data -> salt;
    $db_encrypted_password = $data -> encrypted_password;

    if ($this -> verifyHash($password.$salt,$db_encrypted_password) ) {


        $user["first_name"] = $data -> first_name;
        $user["last_name"] = $data -> last_name;
        $user["email"] = $data -> email;
        $user["unique_id"] = $data -> unique_id;
        return $user;

    } else {

        return false;
    }

 }


 public function changePassword($email, $password){


    $hash = $this -> getHash($password);
    $encrypted_password = $hash["encrypted"];
    $salt = $hash["salt"];

    $sql = 'UPDATE users SET encrypted_password = :encrypted_password, salt = :salt WHERE email = :email';
    $query = $this -> conn -> prepare($sql);
    $query -> execute(array(':email' => $email, ':encrypted_password' => $encrypted_password, ':salt' => $salt));

    if ($query) {

        return true;

    } else {

        return false;

    }

 }

 public function checkUserExist($email){

    $sql = 'SELECT COUNT(*) from wp_users WHERE user_email =:email';
    $query = $this -> conn -> prepare($sql);
    $query -> execute(array('email' => $email));

    if($query){

        $row_count = $query -> fetchColumn();

        if ($row_count == 0){

            return false;

        } else {

            return true;

        }
    } else {

        return false;
    }
 }

 public function getHash($password) {

     /*$salt = sha1(rand());
     $salt = substr($salt, 0, 10);
     $encrypted = password_hash($password.$salt, PASSWORD_DEFAULT);
     $hash = array("salt" => $salt, "encrypted" => $encrypted);*/

     $hash = md5($password);
     return $hash;

}



public function verifyHash($password, $hash) {

    return password_verify ($password, $hash);
}
}




