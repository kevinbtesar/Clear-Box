<?php
require_once('api_security.php');


if (!function_exists('md5_hash'))
{
    function md5_hash(string $string)
    {
        return md5($string);
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