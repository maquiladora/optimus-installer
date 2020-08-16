#!/bin/bash
#VERBOSE=1 #STDOUT normal, STDERR en rouge
#export VERBOSE=2 #STDOUT pas affiché. STDERR en rouge
#VERBOSE=3 #STDOUT et STDERR pas affiché (mode silencieux)

export VERBOSE=2
export DOMAIN=
export AES_KEY=
export DISKPART_AREYOUSURE=
export PART_TO_ENCRYPT=
export SECURE_UPDATE=Y
export SECURE_CHANGEROOTPASS=Y
export SECURE_GENERATEROOTPASS=Y
export SECURE_CHANGEDEBIANPASS=Y
export SECURE_GENERATEDEBIANPASS=Y
export SECURE_ENABLEFW=Y
export SECURE_INSTALLFAIL2BAN=Y
export SECURE_SSHREPLACEDEFAULTPORT=Y
export SECURE_SSHDISABLEROOTACCESS=Y
export SECURE_ACTIVATEGOOGLEAUTH=Y
export APACHE_AREYOUSURE=Y
export WWW_AREYOUSURE=Y
export PHP_AREYOUSURE=Y
export MARIADB_AREYOUSURE=Y
export MARIADB_REMOTEACCESS=Y
export MARIADB_ADMIN_USER=prime@$DOMAIN
export MARIADB_ADMIN_PASSWORD=
export MARIADB_REMOTE_ROOT_PASSWORD=
export CLOUD_AREYOUSURE=Y
export CLOUD_MARIADB_USER=cloud
export CLOUD_MARIADB_PASSWORD=
export WEBMAIL_AREYOUSURE=Y
export API_AREYOUSURE=Y
export MAILSERVER_AREYOUSURE=Y
export MAILSERVER_MARIADB_USER=mailboxes
export MAILSERVER_MARIADB_PASSWORD=
export MAILSERVER_POSTMASTER_MAILBOX_USER=postmaster@$DOMAIN
export MAILSERVER_POSTMASTER_MAILBOX_PASSWORD=
export ROUNDCUBE_AREYOUSURE=Y
export SABREDAV_AREYOUSURE=Y
export LETSENCRYPT_AREYOUSURE=Y
export BACKUP_AREYOUSURE=
