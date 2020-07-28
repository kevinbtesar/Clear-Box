<?php

require_once('inc_security.php'); // Must be included with every php file in API directory


if (!function_exists('check_login'))
{
    function check_login(string $email, string $password)
    {

        require_once('./../wp-blog-header.php');
        global $wpdb;
        $user = get_user_by( 'email', $email );
        //output_error_log("check_login", "email: " . $email . " user: " . json_encode($user));

        if ( $user) 
        {
            // User found!

            $all_meta_for_user = get_user_meta( $user->ID );
            //output_error_log("check_login", "user\'s meta: " . json_encode($all_meta_for_user));

            if ($all_meta_for_user['user_activation_status'][0] == "0") 
            {
                output_error_log("check_login", "user_activation_status: " . $all_meta_for_user['user_activation_status'][0] . " -- User email not confirmed");
                return 'not confirmed';

            } else if($user->data->user_status != 0 && $user->data->user_status != 1) 
            {
                output_error_log("check_login", "user_status: " .  $user->data->user_status . " -- User status not equal to 0 (users) or 1 (admins)");    
                return 'invalid status';

            } else if(wp_check_password( $password, $user->data->user_pass, $user->ID )) 
            {
                // User's email was confirmed!
                // User has a status of either 1 or 2
                
                $obj_merged = (object) array_merge((array) $user, (array) $all_meta_for_user);
                //output_error_log("check_login", "obj_merged: " .  json_encode($obj_merged) . " -- User credentials found successfully!");    
                return $obj_merged;

            } else 
            {
                // Failed checks

                output_error_log("check_login", "Failed Checks 1");  
                return false;
            }
     
            // last resort. Failed checks.
            output_error_log("check_login", "Failed Checks 2");  
            return false;

        } else 
        {
            // User not found

            output_error_log("check_login", "User not found");  
            return false;
        }
        
    }
}


if (!function_exists('current_date_time'))
{
    function current_date_time()
    {
        return date_create()->format('Y-m-d H:i:s');
    }
}


if (!function_exists('remove_non_alphanumeric'))
{
    function remove_non_alphanumeric(string $string)
    {
        return $string = preg_replace( '/[\W]/', '', $string);
    }
}


if (!function_exists('check_phone_length'))
{
    function check_phone_length(string $string)
    {
        if(strlen($string) == 10) return true;
        else return false;
    }
}


if (!function_exists('check_password_length'))
{
    function check_password_length(string $string)
    {
        if(strlen($string) >= 6) return true;
        else return false;
    }
}


if (!function_exists('return_printable_array'))
{
    function return_printable_array(array $array)
    {
        return json_encode($array);
    }
}


if(!function_exists('sql_debug')){
    function sql_debug($sql_string, array $params = null) {
        if (!empty($params)) {
            $indexed = $params == array_values($params);
            foreach($params as $k=>$v) {
                if (is_object($v)) {
                    if ($v instanceof \DateTime) $v = $v->format('Y-m-d H:i:s');
                    else continue;
                }
                elseif (is_string($v)) $v="'$v'";
                elseif ($v === null) $v='NULL';
                elseif (is_array($v)) $v = implode(',', $v);

                if ($indexed) {
                    $sql_string = preg_replace('/\?/', $v, $sql_string, 1);
                }
                else {
                    if ($k[0] != ':') $k = ':'.$k; //add leading colon if it was left out
                    $sql_string = str_replace($k,$v,$sql_string);
                }
            }
        }
        return $sql_string;
    }
}
?>