<?php
add_action( 'wp_enqueue_scripts', 'enqueue_parent_styles' );
function enqueue_parent_styles() {
   wp_enqueue_style( 'parent-style', get_template_directory_uri().'/style.css' );
}


add_filter( 'bdpwr_code_email_text' , function( $text , $email , $code , $expiry ) {
  date_default_timezone_set("America/Chicago");
  $newTime = date("D M j G:i:s T",strtotime(date("Y-m-d H:i:s")." +15 minutes"));

  return  "
  A password reset was requested for your account and your password reset code is " . $code . "
  
  Your link is <a href='http://clearboxlending/reset-password/?code=" . $code . "&email=" . $email . ">
  http://clearboxlending/reset-password/?code=" . $code . "&email=" . $email . "</a>

  Please note this code will expire in 15 minutes, which is at " . $newTime;

  
}, 10 , 4 );


function my_scripts_and_styles(){
  $cache_buster = date("YmdHi", filemtime( get_stylesheet_directory() . '/style.css'));
  wp_enqueue_style( 'main', get_stylesheet_directory_uri() . '/style.css', array(), $cache_buster, 'all' );
  //wp_register_script('ScrollMagic', get_stylesheet_directory_uri() . '/js/scrollmagic.min.js', array('jquery'), '1.1', false);
    //wp_enqueue_script('ScrollMagic');
  
}
add_action( 'wp_enqueue_scripts', 'my_scripts_and_styles', 1);


add_action('wp_enqueue_scripts', 'shopkeeper_enqueue_styles', 100);
function shopkeeper_enqueue_styles() 
{
    // enqueue parent styles
    wp_enqueue_style('main', get_template_directory_uri() .'/style.css');
    // enqueue RTL styles
    //if (is_rtl()) {
        //wp_enqueue_style( 'shopkeeper-child-rtl-styles', get_template_directory_uri() . '/rtl.css', array( 'shopkeeper-styles' ), wp_get_theme()->get('Version') );
    //}
    // Do manually to control version. Forces new version to show rather than outdated ver
    //wp_enqueue_style( 'blankslate-style', get_stylesheet_uri() );
    //wp_enqueue_script('jquery');
    //wp_enqueue_script('jquery-ui-core');
    //wp_register_script('ScrollMagic', get_stylesheet_directory_uri() . '/js/scrollmagic.min.js', array('jquery'), '1.1', false);
    //wp_enqueue_script('ScrollMagic');
    //wp_enqueue_style( 'bootstrap', 'https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' );
}
/* asynchronously load scripts *************************/
function add_async_attribute($tag, $handle)
{
    // add script handles to the array below
    $scripts_to_async = array('jquery-migrate', 'jquery', 'jquery-ui-core', 'bootstrap');
    foreach ($scripts_to_async as $async_script) {
        if ($async_script === $handle) {
            return str_replace(' src', ' async src', $tag);
        }
    }
    return $tag;
}
add_filter('script_loader_tag', 'add_async_attribute', 10, 2);
/* defer scripts *************************/
function add_defer_attribute($tag, $handle)
{
    // add script handles to the array below
    $scripts_to_defer = array('smartmenus', 'admin-bar');
    foreach ($scripts_to_defer as $defer_script) {
        if ($defer_script === $handle) {
            return str_replace(' src', ' defer="defer" src', $tag);
        }
    }
    return $tag;
}
add_filter('script_loader_tag', 'add_defer_attribute', 10, 2);

// Hide admin bar automatically
add_action("user_register", "set_user_admin_bar_false_by_default", 10, 1);
function set_user_admin_bar_false_by_default($user_id) {
    update_user_meta( $user_id, 'show_admin_bar_front', 'false' );
    update_user_meta( $user_id, 'show_admin_bar_admin', 'false' );
}
?>