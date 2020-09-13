#!/bin/bash
source /etc/allspark/functions.sh
source /root/.allspark

DOMAIN_TO_DNS=$( getent hosts $DOMAIN | awk '{ print $1 }' )
PUBLIC_IP=$( wget -qO- ipinfo.io/ip )

while : ; do

clear

tput cup 2 	3; echo -ne  "\033[46;30m          ALLSPARK INSTALLER          \e[0m"
tput cup 3 	3; echo -ne  "\033[46;30m                 V1.50                \e[0m"

tput cup 5  3; if [ -n "$LAST_UPGRADE" ]; then echo_green "a. Mettre à jour le système (LASTUPGRADE : $LAST_UPGRADE)"; else echo_red "a. Mettre à jour le système"; fi
tput cup 6  3; if [ -n "$PART_TO_ENCRYPT" ] && lsblk -o NAME -n /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q $PART_TO_ENCRYPT; then echo_green "b. Créer une partition $PART_TO_ENCRYPT indépendante"; else echo_red "b. Créer une partition $PART_TO_ENCRYPT indépendante"; fi
tput cup 7  3; if /sbin/blkid /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q 'crypto_LUKS'; then echo_green "c. Activer le chiffrement sur la partition $PART_TO_ENCRYPT"; else echo_red "c. Activer le chiffrement sur la partition $PART_TO_ENCRYPT"; fi
tput cup 8  3; if lsblk -o MOUNTPOINT -n /dev/mapper/crypt$PART_TO_ENCRYPT 2>/dev/null | grep -q '/srv'; then echo_green "d. Déchiffrer la partition $PART_TO_ENCRYPT et la monter sur /srv"; else echo_red "d. Déchiffrer la partition $PART_TO_ENCRYPT et la monter sur /srv"; fi
tput cup 9  3; if grep -q "Port 7822" /etc/ssh/sshd_config; then echo_green "e. Sécuriser le serveur"; else echo_red "e. Sécuriser le serveur"; fi
tput cup 10 3; if ! dpkg -s apache2 2>&1 | grep "is not installed";	then echo_green "f. Installer le serveur web APACHE"; else echo_red "f. Installer le serveur web APACHE"; fi
tput cup 11 3; if [ -d "/srv/www" ]; then echo_green "g. Installer l'espace d'hébergement www"; else echo_red "g. Installer l'espace d'hébergement www"; fi
tput cup 12 3; if ! dpkg -s php 2>&1 | grep "is not installed"; then echo_green "h. Installer PHP"; else echo_red "h. Installer PHP"; fi
tput cup 13 3; if ! dpkg -s mariadb-server 2>&1 | grep "is not installed"; then echo_green "i. Installer MARIADB"; else echo_red "i. Installer MARIADB"; fi
tput cup 14 3; if ! dpkg -s dovecot-core 2>&1 | grep "is not installed"; then echo_green "j. Installer le serveur mail"; else echo_red "j. Installer le serveur mail"; fi
tput cup 15 3; if [ -d "/srv/webmail" ]; then echo_green "k. Installer le webmail ROUNDCUBE"; else echo_red "k. Installer le webmail ROUNDCUBE"; fi
tput cup 16 3; if [ -d "/srv/cloud" ]; then echo_green "l. Installer le serveur cloud SABREDAV (WEBDAV)"; else echo_red "l. Installer le serveur cloud SABREDAV (WEBDAV)"; fi
tput cup 17 3; if [ -d "/srv/api" ]; then echo_green "m. Installer l'api de communication"; else echo_red "m. Installer l'api de communication"; fi
tput cup 18 3; if [ -d "/srv/shared" ]; then echo_green "n. Installer l'espace de partage de fichiers"; else echo_red "n. Installer l'espace de partage de fichiers"; fi
tput cup 19 3; if [ -d "/srv/optimus" ]; then echo_green "o. Installer le client OPTIMUS-AVOCATS (facultatif)"; else echo_red "o. Installer le client OPTIMUS-AVOCATS (facultatif)"; fi
tput cup 20 3; if [[ $DOMAIN_TO_DNS == $PUBLIC_IP ]]; then echo_green "p. Configuration de la zone DNS"; else echo_red "p. Configuration de la zone DNS"; fi
tput cup 21 3; if ! dpkg -s certbot 2>&1 | grep "is not installed"; then echo_green "q. Installer les certificats SSL"; else echo_red "q. Installer les certificats SSL"; fi
tput cup 22 3; if [ -f "/srv/allspark-backup.sh" ]; then echo_green "r. Installer les scripts de sauvegarde"; else echo_red "r. Installer les scripts de sauvegarde"; fi

tput cup 24 3; echo_green "s. Sauvegarder la configuration et les clés de chiffrement"

tput cup 26 3; echo_green "t. Editer la configuration"
tput cup 27 3; echo_green "u. Mettre à jour AllSpark Installer"
tput cup 28 3; echo_green "v. Redémarrer le serveur"
tput cup 29 3; echo_green "w. Afficher le QR CODE 2FA"
tput cup 30 3; echo_green "x. Quitter"

tput cup 32 3; echo_green "y. INSTALLATION GUIDEE"
tput cup 33 3; echo_green "z. INSTALLATION AUTOMATISEE"

tput cup 35 3; echo -ne "\033[46;30m Select Option : \e[0m"; tput cup 25 21

read -n 1 y

case "$y" in

  a)
		tput reset
		clear
    source /etc/allspark/upgrade/install.sh
    source /root/.allspark
    read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

  b)
		tput reset
		clear
		source /etc/allspark/diskpart/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

  c)
  	tput reset
  	clear
  	source /etc/allspark/crypt/install.sh
  	read -p "Appuyez sur [ENTREE] pour continuer..."
  	;;

  d)
    tput reset
    clear
    source /etc/allspark/decrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  e)
    tput reset
    clear
    source /etc/allspark/secure/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  f)
    tput reset
    clear
    source /etc/allspark/apache/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  g)
    tput reset
    clear
    source /etc/allspark/www/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  h)
    tput reset
    clear
    source /etc/allspark/php/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  i)
    tput reset
    clear
    source /etc/allspark/mariadb/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  j)
    tput reset
    clear
    source /etc/allspark/mailserver/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  k)
    tput reset
    clear
    source /etc/allspark/webmail/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  l)
    tput reset
    clear
    source /etc/allspark/cloud/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  m)
    tput reset
    clear
    source /etc/allspark/api/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  n)
    tput reset
    clear
    source /etc/allspark/shared/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  o)
    tput reset
    clear
    source /etc/allspark/optimus/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  p)
    tput reset
    clear
    source /etc/allspark/zonedns/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  q)
    tput reset
    clear
    source /etc/allspark/letsencrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  r)
    tput reset
    clear
    source /etc/allspark/backup/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  s)
    tput reset
    clear
    source /etc/allspark/saveconfig/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  t)
    tput reset
    clear
    nano /root/.allspark
    source /etc/allspark/menu.sh
    ;;

  u)
		tput reset
		clear
    source /etc/allspark/update/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

  v)
    tput reset
    reboot
    exit 1
    ;;

  w)
    tput reset
    qrencode -t ansi "otpauth://totp/debian@$DOMAIN?secret=${SECURE_GOOGLEAUTH_KEY}&issuer=ALLSPARK"
    exit 1
    ;;

  x)
    tput reset
    clear
    exit 1
    ;;

  y)
    tput reset
    clear
    source /etc/allspark/upgrade/install.sh
  	source /etc/allspark/diskpart/install.sh
    source /etc/allspark/crypt/install.sh
    #source /etc/allspark/decrypt/install.sh
    source /etc/allspark/secure/install.sh
    source /etc/allspark/apache/install.sh
    source /etc/allspark/www/install.sh
    source /etc/allspark/php/install.sh
    source /etc/allspark/mariadb/install.sh
    source /etc/allspark/mailserver/install.sh
    source /etc/allspark/webmail/install.sh
    source /etc/allspark/cloud/install.sh
    source /etc/allspark/api/install.sh
    source /etc/allspark/shared/install.sh
    source /etc/allspark/optimus/install.sh
    source /etc/allspark/backup/install.sh
    qrencode -t ansi "otpauth://totp/debian@$DOMAIN.fr?secret=${SECURE_GOOGLEAUTH_KEY}&issuer=ALLSPARK"
    read -p "Appuyez sur [ENTREE] après avoir enregistré votre code ..."
    clear
    source /etc/allspark/zonedns/install.sh
    read -p "Appuyez sur [ENTREE] après avoir modifié votre enregistrement DNS, configuré le reverse DNS, puis ouvert les ports requis..."
    clear
    source /etc/allspark/letsencrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  z)
  	tput reset
  	clear
    if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez renseigner votre nom de domaine :"; fi
    update_conf VERBOSE 2
    update_conf AES_KEY auto
    update_conf WEBMAIL_DES_KEY auto
    update_conf API_SHA_KEY auto
    update_conf UUID auto
    update_conf MODULE_APACHE "Y"
    update_conf MODULE_API "Y"
    update_conf MODULE_BACKUP "Y"
    update_conf MODULE_CLOUD "Y"
    update_conf MODULE_SHARED "Y"
    update_conf MODULE_CRYPT "Y"
    update_conf MODULE_DECRYPT "Y"
    update_conf MODULE_DISKPART "Y"
    update_conf MODULE_LETSENCRYPT "Y"
    update_conf MODULE_MAILSERVER "Y"
    update_conf MODULE_MARIADB "Y"
    update_conf MODULE_MARIADB_REMOTE_ACCESS "Y"
    update_conf MODULE_OPTIMUS "Y"
    update_conf MODULE_PHP "Y"
    update_conf MODULE_SECURE_UPDATE "Y"
    update_conf MODULE_SECURE_ENABLEFW "Y"
    update_conf MODULE_SECURE_FAIL2BAN "Y"
    update_conf MODULE_SECURE_CHANGEROOTPASS "Y"
    update_conf MODULE_SECURE_CHANGEDEBIANPASS "Y"
    update_conf MODULE_SECURE_SSH_REPLACEDEFAULTPORT "Y"
    update_conf MODULE_SECURE_SSH_DISABLEROOTACCESS "Y"
    update_conf MODULE_SECURE_SSH_2FA "Y"
    update_conf MODULE_SHARED "Y"
    update_conf MODULE_UPGRADE "Y"
    update_conf MODULE_WEBMAIL "Y"
    update_conf MODULE_WWW "Y"
    update_conf SECURE_ROOT_PASSWORD auto
    update_conf SECURE_DEBIAN_PASSWORD auto
    update_conf MARIADB_ADMIN_USER "prime@$DOMAIN"
    update_conf MARIADB_ADMIN_PASSWORD auto
    update_conf MARIADB_REMOTE_ROOT_PASSWORD auto
    update_conf CLOUD_MARIADB_USER cloud
    update_conf CLOUD_MARIADB_PASSWORD auto
    update_conf MAILSERVER_MARIADB_USER mailboxes
    update_conf MAILSERVER_MARIADB_PASSWORD auto
    update_conf MAILSERVER_POSTMASTER_USER "prime@$DOMAIN"
    update_conf MAILSERVER_POSTMASTER_PASSWORD auto
    source /root/.allspark
    source /etc/allspark/upgrade/install.sh
  	source /etc/allspark/diskpart/install.sh
    source /etc/allspark/crypt/install.sh
    #source /etc/allspark/decrypt/install.sh
    source /etc/allspark/secure/install.sh
    source /etc/allspark/apache/install.sh
    source /etc/allspark/www/install.sh
    source /etc/allspark/php/install.sh
    source /etc/allspark/mariadb/install.sh
    source /etc/allspark/mailserver/install.sh
    source /etc/allspark/webmail/install.sh
    source /etc/allspark/cloud/install.sh
    source /etc/allspark/api/install.sh
    source /etc/allspark/shared/install.sh
    source /etc/allspark/optimus/install.sh
    source /etc/allspark/backup/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer ..."
    clear
    qrencode -t ansi "otpauth://totp/debian@$DOMAIN?secret=${SECURE_GOOGLEAUTH_KEY}&issuer=ALLSPARK"
    read -p "Appuyez sur [ENTREE] après avoir enregistré votre code 2FA ..."
    clear
    source /etc/allspark/zonedns/install.sh
    read -p "Appuyez sur [ENTREE] après avoir modifié votre enregistrement DNS, configuré le reverse DNS, puis ouvert les ports requis..."
    clear
    source /etc/allspark/letsencrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour terminer l'installation..."
    DOMAIN_TO_DNS=$( getent hosts $DOMAIN | awk '{ print $1 }' )
  	;;
esac
done
