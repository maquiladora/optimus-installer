<?php

/* Local configuration for Roundcube Webmail */
//$config['enable_installer'] = true;
// PEAR database DSN for read/write operations
// format is db_provider://user:password@host/database
// For examples see http://pear.php.net/manual/en/package.database.mdb2.intro-dsn.php
// currently supported db_providers: mysql, mysqli, pgsql, sqlite, mssql or sqlsrv
$config['db_dsnw'] = 'mysql://$MAILSERVER_MARIADB_USER:$MAILSERVER_MARIADB_PASSWORD@127.0.0.1/roundcube';

// Log sent messages to <log_dir>/sendmail or to syslog
$config['smtp_log'] = false;

// ----------------------------------
// IMAP
// ----------------------------------
// the mail host chosen to perform the log-in
// leave blank to show a textbox at login, give a list of hosts
// to display a pulldown menu or set one host as string.
// To use SSL/TLS connection, enter hostname with prefix ssl:// or tls://
// Supported replacement variables:
// %n - http hostname ($_SERVER['SERVER_NAME'])
// %d - domain (http hostname without the first part)
// %s - domain name after the '@' from e-mail address provided at login screen
// For example %n = mail.domain.tld, %d = domain.tld
$config['default_host'] = 'localhost';

// Type of IMAP indexes cache. Supported values: 'db', 'apc' and 'memcache'.
$config['imap_cache'] = 'db';

// ----------------------------------
// SMTP
// ----------------------------------
// SMTP server host (for sending mails).
// To use SSL/TLS connection, enter hostname with prefix ssl:// or tls://
// If left blank, the PHP mail() function is used
// Supported replacement variables:
// %h - user's IMAP hostname
// %n - http hostname ($_SERVER['SERVER_NAME'])
// %d - domain (http hostname without the first part)
// %z - IMAP domain (IMAP hostname without the first part)
// For example %n = mail.domain.tld, %d = domain.tld
$config['smtp_server'] = 'mail.$DOMAIN';
$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';

// provide an URL where a user can get support for this Roundcube installation
// PLEASE DO NOT LINK TO THE ROUNDCUBE.NET WEBSITE HERE!
$config['support_url'] = 'http://www.cybertron.fr/';

// replace Roundcube logo with this image
// specify an URL relative to the document root of this Roundcube installation
$config['skin_logo'] = '';

// use this folder to store log files (must be writeable for apache user)
// This is used by the 'file' log driver.
$config['log_dir'] = '/var/log/roundcube/';

// use this folder to store temp files (must be writeable for apache user)
$config['temp_dir'] = 'temp/';

// If users authentication is not case sensitive this must be enabled.
// You can also use it to force conversion of logins to lower case.
// After enabling it all user records need to be updated, e.g. with query:
// UPDATE users SET username = LOWER(username);
$config['login_lc'] = false;

// this key is used to encrypt the users imap password which is stored
// in the session record (and the client cookie if remember password is enabled).
// please provide a string of exactly 24 chars.
$config['des_key'] = '$DESKEY';

// use this name to compose page titles
$config['product_name'] = 'ALLSPARK Webmail';

# null == default
// mime magic database
$config['mime_magic'] = null;

// ----------------------------------
// PLUGINS
// ----------------------------------
// List of active plugins (in plugins/ directory)
$config['plugins'] = array(
'acl',
'jqueryui',
'enigma',
'managesieve',
'markasjunk',
'newmail_notifier',
'subscriptions_option',
'zipdownload',

"contextmenu",
"contextmenu_folder",
"sauserprefs",
"swipe",
"thunderbird_labels",
"hotkeys",
"fail2ban",
"advanced_search",
"singleuserautologin");
// ----------------------------------
// USER INTERFACE
// ----------------------------------
// default messages sort column. Use empty value for default server's sorting,
// or 'arrival', 'date', 'subject', 'from', 'to', 'size', 'cc'
$config['message_sort_col'] = 'date';

// These cols are shown in the message list. Available cols are:
// subject, from, to, cc, replyto, date, size, status, flag, attachment, 'priority'
$config['list_cols'] = array('subject', 'status', 'from', 'date', 'size', 'flag', 'attachment');

// the default locale setting (leave empty for auto-detection)
// RFC1766 formatted language name like en_US, de_DE, de_CH, fr_FR, pt_BR
$config['language'] = 'fr_FR';

// use this format for date display (date or strftime format)
$config['date_format'] = 'd/m/Y';

// give this choice of date formats to the user to select from
$config['date_formats'] = array('Y-m-d', 'd-m-Y', 'Y/m/d', 'm/d/Y', 'd/m/Y', 'd.m.Y', 'j.n.Y');

// use this format for detailed date/time formatting (derived from date_format and time_format)
$config['date_long'] = 'd/m/Y H:i';

// automatically create the above listed default folders on first login
$config['create_default_folders'] = true;

// if in your system 0 quota means no limit set this option to true
$config['quota_zero_as_unlimited'] = true;

// These languages can be selected for spell checking.
// Configure as a PHP style hash array: array('en'=>'English', 'de'=>'Deutsch');
// Leave empty for default set of available language.
$config['spellcheck_languages'] = array (
  'fr' => 'French',
  'en' => 'English',
  'de' => 'German',
);

// display remote inline images
// 0 - Never, always ask
// 1 - Ask if sender is not in address book
// 2 - Always show inline images
$config['show_images'] = 2;

// compose html formatted messages by default
// 0 - never, 1 - always, 2 - on reply to HTML message only
$config['htmleditor'] = 1;

// default setting if preview pane is enabled
$config['preview_pane'] = true;

// Encoding of long/non-ascii attachment names:
// 0 - Full RFC 2231 compatible
// 1 - RFC 2047 for 'name' and RFC 2231 for 'filename' parameter (Thunderbird's default)
// 2 - Full 2047 compatible
$config['mime_param_folding'] = 0;

// If true, after message delete/move, the next message will be displayed
$config['display_next'] = false;

// Default font for composed HTML message.
// Supported values: Andale Mono, Arial, Arial Black, Book Antiqua, Courier New,
// Georgia, Helvetica, Impact, Tahoma, Terminal, Times New Roman, Trebuchet MS, Verdana
$config['default_font'] = '';

// lifetime of message cache
// possible units: s, m, h, d, w
$config['message_cache_lifetime'] = '10d';
