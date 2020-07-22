<?php

$successFlag = false;

if(isset($_GET['password_secret'])){

    $passwordSecert = $_GET['password_secret'];

    //file_put_contents('/home/sage1o1/public_html/clearboxlending.com/api/e.log', PHP_EOL 
    //. '$passwordSecert: ' . $passwordSecert . PHP_EOL . 'var_dump: ' .  var_dump($_REQUEST), FILE_APPEND);
    
    if(!empty($passwordSecert) && $passwordSecert === "clearBoxLendingIsTheBestLendingCompanyEVER2468642"){
        $successFlag = true;
    }
}

if(!$successFlag){
   header("Location: https://clearboxlending.com/");
} 


?>