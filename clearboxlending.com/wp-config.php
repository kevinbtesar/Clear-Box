<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'root_clearbo');

/** MySQL database username */
define('DB_USER', 'root_clearbo');

/** MySQL database password */
define('DB_PASSWORD', 'mrQDx0Ne');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8mb4');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'AfTMDg/JY.ImzRg+m=kIoZ]@ (h[DE-4K=D[LRj1fS=yzT4p/ _D{I)<h k^jwcY');
define('SECURE_AUTH_KEY',  'aA(1C1a*=G(bFuv_CcDkx^bhi.!w8juK$T$9qg.vaYJmhc{~wRZSNJKKF4rPs11<');
define('LOGGED_IN_KEY',    'xIlRjIZ1@lPXFhZ;kFXEN`Eupq^fNB_~0oM!K$@{)])$q>r}E$T(MoLkClh`?1b1');
define('NONCE_KEY',        '3o#Udya,b$l?a%+.>S#]a)NDIO8}5NhCIs:iewYl]/4fKp$laA6EfeC7Iw(>cF`-');
define('AUTH_SALT',        ' vUf{=*B:u Cj)!Zxm4|c@7R6PJCyEdWTh 6g62F@:;&A<o]Cde/TPrfm5?uj7KF');
define('SECURE_AUTH_SALT', '9$#@Btco{G8%[S$&+$yGUTrC%Q%Zmj5M4Z?Cdws}:mW0Y|I<Nrsd84-zR%mEuem#');
define('LOGGED_IN_SALT',   '1R^Im=y0&MS:PD.v)1De{`;$OT[d iZ?.77)eOUNphP@sB!A:p5I;3$4[hPTtN{G');
define('NONCE_SALT',       'GUuXa(vA<4v:[qU`vC)FyNiTt- |~+D0(0+>af[>8i-f?F4g.eA<?K;>M<S?ZE.C');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
