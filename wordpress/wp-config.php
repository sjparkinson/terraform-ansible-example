<?php
// ===================================================
// Load database info and local development parameters
// ===================================================
if ( file_exists( dirname( __FILE__ ) . '/local-config.php' ) ) {
	define( 'WP_LOCAL_DEV', true );
	include( dirname( __FILE__ ) . '/local-config.php' );
} else {
	define( 'WP_LOCAL_DEV', false );
	define( 'DB_NAME', 'wordpress' );
	define( 'DB_USER', getenv('DB_USERNAME') );
	define( 'DB_PASSWORD', getenv('DB_PASSWORD') );
	define( 'DB_HOST', getenv('DB_HOST') ); // Probably 'localhost'
}

// ========================
// Custom Content Directory
// ========================
define( 'WP_CONTENT_DIR', dirname( __FILE__ ) . '/content' );
define( 'WP_CONTENT_URL', 'http://' . $_SERVER['HTTP_HOST'] . '/content' );

// ================================================
// You almost certainly do not want to change these
// ================================================
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

// ==============================================================
// Salts, for security
// Grab these from: https://api.wordpress.org/secret-key/1.1/salt
// ==============================================================
define('AUTH_KEY',         '9&)Cp^SGVu-!y<|Z?p#&Eb3:Y!_rE!-T/@G[*oN0`2*8r:V|vhs`9kH*f}cxxOoG');
define('SECURE_AUTH_KEY',  'aEicFui69G> 7XP-rwZ#Mf9(-^5%yIPLD%^|fzMe6;5E}=wz6_d+-. D6CTO0eod');
define('LOGGED_IN_KEY',    'mV:3ao(M,&!F9)|+C#y,!0k%^3*SX1Mp:B9-5Y-v=-;1za-Y9c,TM!N=F&QSSc%$');
define('NONCE_KEY',        '<t{02+2gLlwj#bbu|g2==!5F+]9+.?E+r-*QJrjRq_DzR++0eeq` =rAfaAFkW92');
define('AUTH_SALT',        'T>H<TfdA.)DZ(D/LL;T<vb`f#QUDyY*okQ*/M-1ombU46Eca*]k4{])A8BU!-c(_');
define('SECURE_AUTH_SALT', 'OUO%At<Y_nwl&o|+ZWv<VT92Q<F+/y7,V-`bV~(qLpj:q$OCP=63ucy-g,s.5F]L');
define('LOGGED_IN_SALT',   'AH-rJ+LW;9$I^p}c@4JGA5m:8x3k+C06p)$HrF=i:J>XAa8r^h^fEi;gmix7JYa&');
define('NONCE_SALT',       '.l=A4VD&^ugC-B#oM_<&]as<&~k$>EFFy&>CVSwN9AV7]B$bCJ[&wosx(#z4w]+t');

// ==============================================================
// Table prefix
// Change this if you have multiple installs in the same database
// ==============================================================
$table_prefix  = 'wp_';

// ================================
// Language
// Leave blank for American English
// ================================
define( 'WPLANG', '' );

// ===========
// Hide errors
// ===========
ini_set( 'display_errors', 0 );
define( 'WP_DEBUG_DISPLAY', false );

// =================================================================
// Debug mode
// Debugging? Enable these. Can also enable them in local-config.php
// =================================================================
// define( 'SAVEQUERIES', true );
// define( 'WP_DEBUG', true );

// ======================================
// Load a Memcached config if we have one
// ======================================
if ( file_exists( dirname( __FILE__ ) . '/memcached.php' ) )
	$memcached_servers = include( dirname( __FILE__ ) . '/memcached.php' );

// ===========================================================================================
// This can be used to programatically set the stage when deploying (e.g. production, staging)
// ===========================================================================================
define( 'WP_STAGE', '%%WP_STAGE%%' );
define( 'STAGING_DOMAIN', '%%WP_STAGING_DOMAIN%%' ); // Does magic in WP Stack to handle staging domain rewriting

// ===================
// Bootstrap WordPress
// ===================
if ( !defined( 'ABSPATH' ) )
	define( 'ABSPATH', dirname( __FILE__ ) . '/wp/' );
require_once( ABSPATH . 'wp-settings.php' );
