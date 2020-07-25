# Password Reset with Code for WordPress REST API

A simple plugin that adds a password reset facility to the WordPress REST API using a code. The process is a two step process:

1. User requests a password reset. A 4 digit code is emailed to their registered email address
2. The user enters the code when setting a new password, which is only set if the code is valid and has not expired

It is also possible to check the validity of a code without resetting the password which enables the possibility of setting the password by other means, or having a two stage process for checking the code and resetting the password if desired.

Default settings are to use a 4 digit numerical code which has a life span of 15 minutes, afterwhich a new code would need to be requested. By default a user can attempt to use or validate a code up to 3 times before automatically invalidating it.

## Endpoints

The plugin adds two new endpoints to the REST API:
Also, two new endpoints are added to this namespace.

| Endpoint                              | HTTP Verb | Parameters (**all required**)      |
| ------------------------------------- | --------- | ---------------------------------- |
| */wp-json/bdpwr/v1/reset-password*    | POST      |  email                             |
| */wp-json/bdpwr/v1/set-password*      | POST      |  email <br /> password <br /> code |
| */wp-json/bdpwr/v1/validate-code*     | POST      |  email <br /> code                 |

## Example Requests (jQuery)

### Reset Password

```
$.ajax({
  url: '/wp-json/bdpwr/v1/reset-password',
  method: 'POST',
  data: {
    email: 'example@example.com',
  },
  success: function( response ) {
    console.log( response );
  },
  error: function( response ) {
    console.log( response );
  },
});
```

### Set New Password

```
$.ajax({
  url: '/wp-json/bdpwr/v1/set-password',
  method: 'POST',
  data: {
    email: 'example@example.com',
    code: '1234',
    password: 'Pa$$word1',
  },
  success: function( response ) {
    console.log( response );
  },
  error: function( response ) {
    console.log( response );
  },
});
```

### Validate Code

```
$.ajax({
  url: '/wp-json/bdpwr/v1/validate-code',
  method: 'POST',
  data: {
    email: 'example@example.com',
    code: '1234',
  },
  success: function( response ) {
    console.log( response );
  },
  error: function( response ) {
    console.log( response );
  },
});
```

## Example Success Responses (JSON)

### Reset Password

```json
{
    "data": {
        "status": 200
    },
    "message": "A password reset email has been sent to your email address."
}
```

### Set New Password

```json
{
    "data": {
        "status": 200
    },
    "message": "Password reset successfully."
}
```

### Validate Code

```json
{
    "data": {
        "status": 200
    },
    "message": "The code supplied is valid."
}
```

## Example Error Responses (JSON)

### Reset Password

```json
{
    "code": "bad_email",
    "message": "No user found with this email address.",
    "data": {
        "status": 500
    }
}
```

### Set New Password

```json
{
    "code": "bad_request",
    "message": "You must request a password reset code before you try to set a new password.",
    "data": {
        "status": 500
    }
}
```

### Validate Code

```json
{
    "code": "bad_request",
    "message": "The reset code provided is not valid.",
    "data": {
        "status": 500
    }
}
```

## Filters

A number of WordPress filters have been added to help customise the process, please feel free to request additional filters or submit a pull request with any that you required.

### Filter the length of the code
```
add_filter( 'bdpwr_code_length' , function( $length ) {
  return 4;
}, 10 , 1 );
```

### Filter Expiration Time
```
add_filter( 'bdpwr_code_expiration_seconds' , function( $seconds ) {
  return 900;
}, 10 , 1 );
```

### Filter the date format used by the plugin to display expiration times
```
add_filter( 'bdpwd_date_format' , function( $format ) {
  return 'h:i';
}, 10 , 1 );
```

### Filter the reset email subject
```
add_filter( 'bdpwr_code_email_subject' , function( $subject ) {
  return 'Password Reset';
}, 10 , 1 );
```

### Filter the email content
```
add_filter( 'bdpwr_code_email_text' , function( $text , $email , $code , $expiry ) {
  return $text;
}, 10 , 4 );
```

### Filter maximum attempts allowed to use a reset code, default is 3, -1 for unlimmited
```
add_filter( 'bdpwr_max_attempts' , function( $attempts ) {
  return 3;
}, 10 , 4 );
```

### Filter whether to include upper and lowercase letters in the code as well as numbers, default is false
```
add_filter( 'bdpwr_include_letters' , function( $include ) {
  return false;
}, 10 , 4 );
```

### Filter the characters to be used when generating a code, you can use any string you want, default is 01234567890
```
add_filter( 'bdpwr_selection_string' , function( $string ) {
  return '01234567890';
}, 10 , 4 );
```

### Filter the WP roles allowed to reset their password with this plugin, default is any, example below shows removing administrators
```
add_filter( 'bdpwr_allowed_roles' , function( $roles ) {
  
  $key = array_search( 'administrator' , $roles );
  
  if( $key !== false ) {
    unset( $roles[ $key ] );
  }
  
  return $roles;
  
}, 10 , 1 );
```

### Change Log
 - 0.0.7
 -- Added maximum allowed failed attempts to validate a code before automatically expiring it, default has been set to 3
 -- Added filters to include letters and well as numbers in the reset code as well as allowing you to specify your own string
 -- Added filters to allow the exclusion of certain roles from being able to reset their password, e.g. if you want to exclude Administrators
 - 0.0.6
 -- Added support for WP versions earlier than 5.2.0 due to timezone function availability
 - 0.0.5
 -- Replaced missing api file
 - 0.0.4
 -- Added /validate-code to allow checking a code's validity without actually resetting the password
 - 0.0.3
 -- Fixed bug causing 500 error where WordPress TimeZone was set to a manual UTC offsite