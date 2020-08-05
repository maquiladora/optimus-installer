#!/bin/bash
#VERBOSE=1 #STDOUT normal, STDERR en rouge
VERBOSE=2 #STDOUT pas affiché. STDERR en rouge
#VERBOSE=3 #STDOUT et STDERR pas affiché (mode silencieux)

#DISKPART_AREYOUSURE=N

SECURE_UPDATE=Y
SECURE_CHANGEROOTPASS=Y
SECURE_GENERATEROOTPASS=Y
SECURE_CHANGEDEBIANPASS=Y
SECURE_GENERATEDEBIANPASS=Y
SECURE_ENABLEFW=Y
SECURE_INSTALLFAIL2BAN=Y
SECURE_SSHREPLACEDEFAULTPORT=Y
SECURE_SSHDISABLEROOTACCESS=Y
SECURE_ACTIVATEGOOGLEAUTH=Y

DOMAIN='demoptimus.fr'
APACHE_AREYOUSURE=Y

WWW_AREYOUSURE=Y

PHP_AREYOUSURE=Y

MARIADB_AREYOUSURE=Y
MARIADB_REMOTEACCESS=Y
MARIADB_REMOTE_ROOT_PASSWORD=remote_root-123

MAILSERVER_AREYOUSURE=Y
MAILSERVER_USER=mailboxes
MAILSERVER_PASSWORD=mailboxes123

ROUNDCUBE_AREYOUSURE=Y
ROUNDCUBE_OPTIMUS_REQUIRED_PLUGINS=Y

SABREDAV_AREYOUSURE=Y

#LETSENCRYPT_AREYOUSURE=Y


API="api.$DOMAIN"
CLOUD="cloud.$DOMAIN"
WEBMAIL="webmail.$DOMAIN"
RECEIVE_EMAILS_FOR=$DOMAIN
