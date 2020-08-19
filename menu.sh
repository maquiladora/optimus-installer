#!/bin/bash
source /etc/allspark/functions.sh

while : ; do

clear

tput cup 2 	3; echo -ne  "\033[46;30m          ALLSPARK INSTALLER          \e[0m"
tput cup 3 	3; echo -ne  "\033[46;30m                 V1.28                \e[0m"

tput cup 5  3; if [ -n "$LAST_UPGRADE" ]; then echo_green "a. Mettre à jour le système (LASTUPGRADE : $LAST_UPGRADE)"; else echo_red "a. Mettre à jour le système"; fi
tput cup 6  3; if lsblk -o NAME -n /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q $PART_TO_ENCRYPT; then echo_green "b. Créer une partition /dev/$PART_TO_ENCRYPT indépendante"; else echo_red "b. Créer une partition /dev/$PART_TO_ENCRYPT indépendante"; fi
tput cup 7  3; if /sbin/blkid /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q 'crypto_LUKS'; then echo_green "c. Activer le cryptage sur la partition /dev/$PART_TO_ENCRYPT"; else echo_red "c. Activer le cryptage sur la partition /dev/$PART_TO_ENCRYPT"; fi
tput cup 8  3; if lsblk -o MOUNTPOINT -n /dev/mapper/crypt$PART_TO_ENCRYPT 2>/dev/null | grep -q '/srv'; then echo_green "d. Decrypter la partition /dev/$PART_TO_ENCRYPT et la monter sur /srv"; else echo_red "d. Decrypter la partition /dev/$PART_TO_ENCRYPT et la monter sur /srv"; fi
tput cup 9  3; if grep -q "Port 7822" /etc/ssh/sshd_config; then echo_green "e. Sécuriser le serveur"; else echo_red "e. Sécuriser le serveur"; fi
tput cup 10  3; if [ -f "/etc/apache2/apache2.conf" ];	then echo_green "f. Installer le serveur web APACHE"; else echo_red "f. Installer le serveur web APACHE"; fi
tput cup 11 3; if [ -d "/srv/www" ]; then echo_green "g. Installer l'espace d'hébergement www"; else echo_red "g. Installer l'espace d'hébergement www"; fi
tput cup 12 3; if [ -d "/etc/php" ]; then echo_green "h. Installer PHP"; else echo_red "h. Installer PHP"; fi
tput cup 13 3; if [ -d "/srv/databases" ]; then echo_green "i. Installer MARIADB"; else echo_red "i. Installer MARIADB"; fi
tput cup 14 3; if [ -d "/srv/mailboxes" ]; then echo_green "j. Installer le serveur mail"; else echo_red "j. Installer le serveur mail"; fi
tput cup 15 3; if [ -d "/srv/webmail" ]; then echo_green "k. Installer le webmail ROUNDCUBE"; else echo_red "k. Installer le webmail ROUNDCUBE"; fi
tput cup 16 3; if [ -d "/srv/cloud" ]; then echo_green "l. Installer le serveur cloud SABREDAV (WEBDAV)"; else echo_red "l. Installer le serveur cloud SABREDAV (WEBDAV)"; fi
tput cup 17 3; if [ -d "/srv/api" ]; then echo_green "m. Installer l'api de comunication"; else echo_red "m. Installer l'api de communication"; fi
tput cup 18 3; if [ -d "/srv/optimus" ]; then echo_green "n. Installer le client OPTIMUS-AVOCATS (facultatif)"; else echo_red "n. Installer le client OPTIMUS-AVOCATS (facultatif)"; fi
tput cup 19 3; echo_green "o. Configuration de la zone DNS"
tput cup 20 3; if [ -d "/etc/letsencrypt" ]; then echo_green "q. Installer les certificats SSL"; else echo_red "q. Installer les certificats SSL"; fi
tput cup 21 3; if [ -d "/etc/rsync" ]; then echo_green "r. Installer les scripts de sauvegardes"; else echo_red "r. Installer les scripts de sauvegardes"; fi

tput cup 23 3; echo_green "t. Edit config"
tput cup 24 3; echo_green "u. Update Installer"
tput cup 25 3; echo_green "v. Reboot server"
tput cup 26 3; echo_green "x. Quit"

tput cup 28 3; echo_green "z. AUTOINSTALL"

tput cup 30 3; echo -ne "\033[46;30m Select Option : \e[0m"; tput cup 25 21

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
  	source /etc/allspark/crypt-setup/install.sh
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
    source /etc/allspark/optimus/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  o)
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

  x)
      tput reset
      clear
      exit 1
      ;;

  z)
  	tput reset
  	clear
    source /etc/allspark/upgrade/install.sh
  	source /etc/allspark/diskpart/install.sh
    source /etc/allspark/crypt-setup/install.sh
    source /etc/allspark/decrypt/install.sh
    source /etc/allspark/secure/install.sh
    source /etc/allspark/apache/install.sh
    source /etc/allspark/www/install.sh
    source /etc/allspark/php/install.sh
    source /etc/allspark/mariadb/install.sh
    source /etc/allspark/mailserver/install.sh
    #source /etc/allspark/webmail/install.sh
    source /etc/allspark/cloud/install.sh
    source /etc/allspark/api/install.sh
    #source /etc/allspark/optimus/install.sh
    #source /etc/allspark/zonedns/install.sh
    source /etc/allspark/letsencrypt/install.sh
    #source /etc/allspark/backup/install.sh
  	;;

esac
done
