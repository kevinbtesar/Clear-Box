<?php
add_action( 'wp_enqueue_scripts', 'enqueue_parent_styles' );

function enqueue_parent_styles() {
   wp_enqueue_style( 'parent-style', get_template_directory_uri().'/style.css' );
}

add_filter( 'bdpwd_date_format' , function( $format ) {
  return 'D M j G:i:s T Y';
}, 10 , 1 );

?>