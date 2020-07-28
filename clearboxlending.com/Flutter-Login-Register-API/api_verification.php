<?php
ob_start(); // Step 1. Comment to see body of errors. 
// Step 2. Break at login.dart, line ~257
// final data = jsonDecode(response.body); <- break here

error_reporting(E_ALL);
ini_set("display_errors", 1);

require_once('inc_security.php'); // Must be included with every php file in API directory
require_once('constants.php');
require_once('functions.php');
require_once('connection.php');

/**
 * action_flag 1 = for login
 * action_flag 2 = for update register 
 */


// Initialize values needed for try/catch output.
(string) $query;
(object) $params;

//flag to check and to execute specific switch case based on flag value sent
(int) $actionFlag = $_POST['action_flag'];

$firstName = "";
$lastName = "";
$userEmail = "";
$phone = "";
$userPass = "";

/**
 * The 'api_status' and 'api_message' values are relayed to sharedloginregister.dart
 * Default 'api_status' and 'api_message' values to failed for global protection 
 * 
 */

$json['api_status'] = 'fail';
if($actionFlag == 1) 
{
	$json['api_message'] = LOGIN_FAILED;
} else {
	// Default api message to REGISTRATION_FAILED
	$json['api_message'] = REGISTRATION_FAILED;
}

//
//
/// VALIDATION BEGIN ////////////////////////////////////////////////////////////////////////////

// Boolean flag only for validation. Checked in case blocks.
$validationErrorFlag = false;

/**
 * ALL Strings:  Ensure all $_POST values do not equal null and not empty
 * Email:        Format to non-capitalization
 * Phone:        Remove non-numeric characters; Check to ensure valid length (10)
 * Password:     Check length (min 6); Trim
 */


// Email
if ($_POST['email'] != null && !empty($_POST['email'])) 
{
	$userEmail = trim(strtolower($_POST['email']));
} else 
{
	$json['api_message'] = REGISTRATION_FAILED_EMPTY;
	$validationErrorFlag = true;
}

// Password
if ($_POST['password'] != null && !empty($_POST['password']))
{
	$userPass = trim($_POST['password']);

	if (!check_password_length($userPass)) 
	{
		$json['api_message'] = REGISTRATION_FAILED_PASSWORD_LENGTH;
		$validationErrorFlag = true;
	}

} else 
{
	$json['api_message'] = REGISTRATION_FAILED_EMPTY;
	$validationErrorFlag = true;
}

// Check if user action is to register
if($actionFlag == 2) 
{
	// First name
	if ($_POST['first_name'] != null && !empty($_POST['first_name']))
	{
		$firstName = trim($_POST['first_name']);
	} else {
		$validationErrorFlag = true;
		$json['api_message'] = REGISTRATION_FAILED_EMPTY;
	}

	// Last name
	if ($_POST['last_name'] != null && !empty($_POST['last_name'])) 
	{
		$lastName = trim($_POST['last_name']);
	} else {
		$validationErrorFlag = true;
		$json['api_message'] = REGISTRATION_FAILED_EMPTY;
	}

	// Phone number
	if ($_POST['phone'] != null && !empty($_POST['phone'])) 
	{
		$phone = trim(remove_non_alphanumeric($_POST['phone']));

		if (!check_phone_length($phone)) 
		{
			$json['api_message'] = REGISTRATION_FAILED_PHONE_INVALID;
			$validationErrorFlag = true;
		}
	} else {
		$json['api_message'] = REGISTRATION_FAILED_EMPTY;
		$validationErrorFlag = true;
	}

}

// VALIDATION END /////////////////////////////////////////////////////////////////////////////////


try {

	// Detect if there's been an issue with validation. If so, do not query database.
	if (!$validationErrorFlag) {

		switch ($actionFlag) {

				// Login
			case 1:

				//$fcm_token = $_POST['fcm_token'];
				$check = check_login($userEmail, $userPass);
				if($check) 
				{
					//creating a query
					$query = "SELECT * FROM crxji_users WHERE user_email = :userEmail
							AND (user_status = 1 OR user_status = 2)";
					$result = $pdo->prepare($query);
					$params = ['userEmail' => $userEmail];
					$result->execute($params);
					//output_error_log("case1", 'debugDumpParams: ' . $result->debugDumpParams() . ' sql: ' . sql_debug($query, $params));
					$rows = $result->fetchAll();

					if (count($rows) == 1) {

						// Login success

						foreach ($rows as $row) {
							//Update FCM Token
							/*$query2 = "UPDATE `user` SET `fcm_token`='$fcm_token' 
								WHERE `id`='".$row['id']."' ";
							$result2 = mysqli_query($connect, $query2);*/

							$json['api_status'] = 'success';
							$json['api_message'] = LOGIN_SUCCESS;

							$json['id'] = $row['ID'];
							$json['email'] = $row['user_email'];
							$json['first_name'] = $row['user_login'];
							$json['last_name'] = $row['user_nicename'];
							$json['phone'] = $row['user_url'];
							$json['user_status'] = $row['user_status'];
						}
					} else if (count($rows) > 1) {
						// Login failed - duplicate emails found

						$json['api_status'] = 'fail';
						$json['api_message'] = LOGIN_FAILED_DUPLICATE_EMAILS;
					} else {
						// Login failed- matching emails not found

						$json['api_status'] = 'fail';
						$json['api_message'] = LOGIN_FAILED_NO_MATCHING;
					}
				} else {
					// Login failed- matching email and password not found

					$json['api_status'] = 'fail';
					$json['api_message'] = LOGIN_FAILED_NO_MATCHING;
				}

				break; //Ends case 1


				//////// Register /////////////////////////////////////////////////////////////////////////////////////////////////////
			case 2:

				$userRegistered = current_date_time();
				$userStatus = 2; // Admins = 1, Users = 2

				$query = "SELECT user_email, user_url FROM crxji_users 
				          WHERE user_email = :userEmail OR user_url = :phone ";
				$params = ['userEmail' => $userEmail, 'phone' => $phone];
				$result = $pdo->prepare($query);
				$result->execute($params);
				$rows = $result->fetchAll();

				/**
				 * Using PHP's count() function, 
				 * we can determine the precise number of rows from phone/email check query.
				 * While the PDO function rowCount() would work as well, 
				 * I read that it can return 0 rows, though it's not accurate.
				 */
				if (count($rows) > 0) {

					$json['api_status'] = 'fail';
					foreach ($rows as $row) {
						if ($row['user_email'] == $userEmail) {
							$json['api_message'] = REGISTRATION_FAILED_EMAIL_DUPLICATE;
						} else if ($row['user_url'] == $phone) {
							$json['api_message'] = REGISTRATION_FAILED_PHONE_DUPLICATE;
						}
					}
				} else {
					$query = "INSERT INTO crxji_users (user_login, user_pass, 
													user_nicename, user_email, user_url, 
													user_registered, user_activation_key, 
													user_status, display_name) 

											VALUES (:userEmail, :userPass, 
													:lastName, :userEmail2, :phone,
													'$userRegistered', '', 
													 $userStatus, :firstName)";

					//$pdo->setAttribute( PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING ); // Debugging setting. Must be done before prepare()
					$inserted = $pdo->prepare($query);

					$params = [
						'userEmail' => $userEmail,
						'userPass' => $userPass,
						'lastName' => $lastName,
						'userEmail2' => $userEmail,
						'phone' => $phone,
						'firstName' => $firstName
					];
					$inserted->execute($params);
					$inserted = $inserted->rowCount();

					if ($inserted == 1) {
						$json['api_status'] = 'success';
						$json['api_message'] = REGISTRATION_SUCCESSFUL;
					} else {
						$json['api_status'] = 'fail';
						$json['api_message'] = REGISTRATION_FAILED;
					}

					/**
					 * Alternatively, we could of check whether the insert was successful with the following if statements:
					 * 
					 * if ($pdo->execute()) { 
					 *  // it worked
					 * } else {
					 *  // it didn't
					 * }
					 * 
					 * ///////////////////////////////////////////////////////////////////////////////////////
					 * 
					 * if ($pdo->execute()) { 
					 *	 // ok :-)
					 *	$count = $pdo->rowCount();
					 *	echo count . ' rows updated properly!';
					 * } else {
					 *	 // KO :-(
					 *	print_r($pdo->errorInfo());
					 *
					 *   // OR //
					 *      
					 *  echo $pdo->error; // I'm not sure of the difference between $stmt->errorInfo() and $stmt->error
					 * 
					 * }
					 *
					 * ///////////////////////////////////////////////////////////////////////////////////////
					 * 
					 *  try
					 *	{
					 *		//----
					 *	}
					 *	catch(PDOException $e)
					 *	{
					 *		echo $e->getMessage();
					 *
					 *	}
					 *
					 * ////////////////////////////////////////////////////////////////////////////////////////
					 * 
					 * Ref: https://stackoverflow.com/questions/9991882/stmt-execute-how-to-know-if-db-insert-was-successful/9991935
					 */
				}


				break; //Ends case 2

			default:
				$inserted == 0;
				break;
		} // Switch end

	} // Validation check end

} catch (Exception $e) {
	//error_log($e);
	output_error_log('api_verification.php - Switch\'s try/catch block', 'Error: ' . $e);
	
	/* Debugging info */

	output_error_log("here0", 'debugDumpParams: ' . $pdo->debugDumpParams . ' sql: ' . sql_debug($query, $params));
	$databaseErrors = $inserted->errorInfo();
	$errorInfo = print_r($databaseErrors, true);
	output_error_log("here1", $errorInfo);
				
	
}

$pdo=null; // Close SQL connection

ob_get_clean();

header("Content-Type: application/json");
echo json_encode($json); // Removal will cause return to be empty

ob_end_flush();
exit;
?>