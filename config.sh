#!/bin/bash
#VERBOSE=1 #STDOUT normal, STDERR en rouge
VERBOSE=2 #STDOUT pas affiché. STDERR en rouge
#VERBOSE=3 #STDOUT et STDERR pas affiché (mode silencieux)

DOMAIN='demoptimus.fr'

#DOIT CONTENIR EXACTEMENT 16 CARACTERES MAJUSCULES, MINUSCULES, CHIFFRES
AES_KEY='54eDGF6erfzTs65F'

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

APACHE_AREYOUSURE=Y
WWW_AREYOUSURE=Y

PHP_AREYOUSURE=Y

MARIADB_AREYOUSURE=Y
MARIADB_REMOTEACCESS=Y
MARIADB_ADMIN_USER=postmaster@$DOMAIN
MARIADB_ADMIN_PASSWORD=postmaster123
MARIADB_REMOTE_ROOT_PASSWORD=remote_root-123

CLOUD_AREYOUSURE=Y
CLOUD_MARIADB_USER=cloud
CLOUD_MARIADB_PASSWORD=cloud123

WEBMAIL_AREYOUSURE=Y
API_AREYOUSURE=Y

export MAILSERVER_AREYOUSURE=Y
export MAILSERVER_MARIADB_USER=mailboxes
export MAILSERVER_MARIADB_PASSWORD=mailboxes123
export MAILSERVER_POSTMASTER_MAILBOX_USER=postmaster@$DOMAIN
export MAILSERVER_POSTMASTER_MAILBOX_PASSWORD=postmaster123

ROUNDCUBE_AREYOUSURE=Y

SABREDAV_AREYOUSURE=Y

#LETSENCRYPT_AREYOUSURE=Y
