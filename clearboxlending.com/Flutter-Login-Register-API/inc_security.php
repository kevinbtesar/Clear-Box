<?php


if(!function_exists('output_error_log')){
    function output_error_log(string $location, string $string){
        file_put_contents('/home/sage1o1/public_html/clearboxlending.com/Flutter-Login-Register-API/error.log', PHP_EOL . 
        	$location . ' - ' . current_date_time() . ' - ' . $string . PHP_EOL . PHP_EOL . PHP_EOL, FILE_APPEND);
    }
}



$successFlag = false;

if(isset($_GET['password_secret'])){

    $passwordSecret = $_GET['password_secret'];

    //output_error_log("api_security.php", '$passwordSecert: ' . $passwordSecert . PHP_EOL . 'var_dump: ' .  var_dump($_REQUEST));
    
    if(!empty($passwordSecret) && $passwordSecret === "clearBoxLendingIsTheBestLendingCompanyEVER2468642"){
        $successFlag = true;
    }
}

if(!$successFlag){
   header("Location: https://clearboxlending.com/");
} 


?>