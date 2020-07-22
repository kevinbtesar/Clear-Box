<?php

$servername = "localhost";
$dbname = "root_clearbo";
$username = "root_clearbo";
$password = "mrQDx0Ne";

try {
	$pdo = new PDO("mysql:dbname=$dbname;host=$servername;charset=utf8", $username, $password);

	/**
	 * When using PDO to access a MySQL database real prepared statements are not used by default. 
	 * To fix this you have to disable the emulation of prepared statements using, ATTR_EMULATE_PREPARES
	 * Ref: https://stackoverflow.com/questions/60174/how-can-i-prevent-sql-injection-in-php
	 */
	$pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);

	// set the PDO error mode to exception
	/**
	 * The script will not stop with a Fatal Error when something goes wrong. 
	 * Gives the chance to catch any error(s) which are thrown as PDOExceptions.
	 * Ref: https://stackoverflow.com/questions/60174/how-can-i-prevent-sql-injection-in-php
	 */
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);


	// TODO - find out what fetch_assoc does compare to other modes. Setting it as default for now. Saves having to set it later.
	$pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);


} catch (PDOException $e) 
{
	error_log($e);
	output_error_log('connection.php - try/catch block', 
					 'ERROR! Database connection FAILED - Error:  
					 ' . $e->getMessage()); 
		
}


if (!$pdo) {
	
	output_error_log('connection.php - if(!$pdo)', 
	                 'ERROR! Database connection FAILED. Did not pass if(!$pdo) check.');

	/**
	 * When the script ends, PHP automatically closes the connection to database server. 
	 * If you want to explicitly close the database connection, you need to set the PDO object to null as follows
	 */
	$pdo = null;

	// Stop PHP
	exit();

}
