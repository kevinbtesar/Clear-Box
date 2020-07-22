<?php
require_once('api_security.php');


define("LOGIN_SUCCESS", "Successfully logged in");
define("LOGIN_FAILED", "Failed to log in");

define("LOGIN_FAILED_DUPLICATE_EMAILS", "Duplicate emails found. Please contact support.");
define("LOGIN_FAILED_NO_MATCHING", "Login failed. Matching email and password could not be found.");

define("REGISTRATION_SUCCESSFUL", "Successfully registered");

define("REGISTRATION_FAILED", "Registration failed");
define("REGISTRATION_FAILED_EMPTY", "All fields must contain a value");

define("REGISTRATION_FAILED_PASSWORD_LENGTH", "Password must be at least 6 characters");
define("REGISTRATION_FAILED_PHONE_INVALID", "Please format phone number for 10 digits");

define("REGISTRATION_FAILED_EMAIL_DUPLICATE", "Duplicate emails detected");
define("REGISTRATION_FAILED_PHONE_DUPLICATE", "Duplicate phone numbers detected");

?>