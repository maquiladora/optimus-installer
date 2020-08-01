#!/bin/bash
#VERBOSE=1 #STDOUT normal, STDERR en rouge
VERBOSE=2 #STDOUT pas affiché. STDERR en rouge
#VERBOSE=3 #STDOUT et STDERR pas affiché (mode silencieux)

#DISKPART_AREYOUSURE=N

SECURE_UPDATE=Y
SECURE_CHANGEROOTPASS=Y
SECURE_GENERATEROOTPASS=Y
SECURE_CREATEOPTIMUSUSER=Y
SECURE_CHANGEOPTIMUSPASS=Y
SECURE_GENERATEOPTIMUSPASS=Y
SECURE_ENABLEFW=Y
SECURE_INSTALLFAIL2BAN=Y
SECURE_SSHREPLACEDEFAULTPORT=Y
SECURE_SSHDISABLEROOTACCESS=Y
SECURE_ACTIVATEGOOGLEAUTH=Y

#DOMAIN='demoptimus.fr'
#APACHE_AREYOUSURE=Y
#APACHE_DEFAULSITE_AREYOUSURE=Y

CERTBOT_AREYOUSURE=Y

PHP_AREYOUSURE=Y
PHP_OPTIMUS_REQUIRED_EXTENSIONS_AREYOUSURE=Y

MYSQL_AREYOUSURE=Y
MYSQL_OPTIMUS_DATABASE_INSTALL=Y

POSTFIX_AREYOUSURE=Y
DOVECOT_AREYOUSURE=Y
SPAMASSASSIN_AREYOUSURE=Y

ROUNDCUBE_AREYOUSURE=Y
ROUNDCUBE_OPTIMUS_REQUIRED_PLUGINS=Y

SABREDAV_AREYOUSURE=Y



API="api.$DOMAIN"
CLOUD="cloud.$DOMAIN"
WEBMAIL="webmail.$DOMAIN"
RECEIVE_EMAILS_FOR=$DOMAIN
