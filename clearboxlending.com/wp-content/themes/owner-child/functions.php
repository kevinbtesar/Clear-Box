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

?>