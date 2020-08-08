#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

if [ ! -f /root/uid ]
then
  </dev/urandom tr -dc A-Z0-9 | head -c${1:-16} > /root/uid
fi

if [ $DOMAIN ]; then echo $DOMAIN > /etc/hostname; fi

while : ; do

clear

tput cup 2 	3; echo -ne  "\033[46;30m          ALLSPARK INSTALLER          \e[0m"
tput cup 3 	3; echo -ne  "\033[46;30m                 V1.26                \e[0m"

tput cup 5  3; if [ -f "/root/LAST_UPGRADE" ]; then echo_green "a. Mettre à jour le système"; else echo_red "a. Mettre à jour le système"; fi
tput cup 6  3; if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'; then echo_green "b. Créer une partition /dev/sda2 indépendante"; else echo_red "b. Créer une partition /dev/sda2 indépendante"; fi
tput cup 7  3; if /sbin/blkid /dev/sda2 2>/dev/null | grep -q 'crypto_LUKS'; then echo_green "c. Activer le cryptage sur la partition /dev/sda2"; else echo_red "c. Activer le cryptage sur la partition /dev/sda2"; fi
tput cup 8  3; if lsblk -o MOUNTPOINT -n /dev/mapper/cryptsda2 2>/dev/null | grep -q '/srv'; then echo_green "d. Decrypter la partition /dev/sda2 et la monter sur /srv"; else echo_red "d. Decrypter la partition /dev/sda2 et la monter sur /srv"; fi
tput cup 9  3; if grep -q "Port 7822" /etc/ssh/sshd_config; then echo_green "e. Sécuriser le serveur"; else echo_red "e. Sécuriser le serveur"; fi
tput cup 10  3; if [ -f "/etc/apache2/apache2.conf" ];	then echo_green "f. Installer le serveur web APACHE"; else echo_red "f. Installer le serveur web APACHE"; fi
tput cup 11 3; if [ -d "/srv/www" ]; then echo_green "g. Installer l'espace d'hébergement www"; else echo_red "g. Installer l'espace d'hébergement www"; fi
tput cup 12 3; if [ -d "/etc/php" ]; then echo_green "h. Installer PHP"; else echo_red "h. Installer PHP"; fi
tput cup 13 3; if [ -d "/srv/databases" ]; then echo_green "i. Installer MARIADB"; else echo_red "i. Installer MARIADB"; fi
tput cup 14 3; if [ -d "/srv/mailboxes" ]; then echo_green "j. Installer le serveur mail"; else echo_red "j. Installer le serveur mail"; fi
tput cup 15 3; if [ -d "/srv/webmail" ]; then echo_green "k. Installer le webmail ROUNDCUBE"; else echo_red "k. Installer le webmail ROUNDCUBE"; fi
tput cup 16 3; if [ -d "/srv/cloud" ]; then echo_green "l. Installer le serveur SABREDAV"; else echo_red "l. Installer le serveur SABREDAV"; fi
tput cup 17 3; if [ -d "/srv/api" ]; then echo_green "m. Installer l'api de comunication"; else echo_red "m. Installer l'api de communication"; fi
tput cup 18 3; if [ -d "/srv/optimus" ]; then echo_green "n. Installer le client OPTIMUS-AVOCATS (facultatif)"; else echo_red "n. Installer le client OPTIMUS-AVOCATS (facultatif)"; fi
tput cup 19 3; echo_green "o. Configuration de la zone DNS"
tput cup 20 3; if [ -d "/etc/letsencrypt" ]; then echo_green "q. Installer les certificats SSL"; else echo_red "q. Installer les certificats SSL"; fi
tput cup 21 3; if [ -d "/etc/rsync" ]; then echo_green "r. Installer RSYNC"; else echo_red "r. Installer RSYNC"; fi

tput cup 23 3; echo_green "u. Update Installer"
tput cup 24 3; echo_green "v. Reboot server"
tput cup 25 3; echo_green "x. Quit"

#tput cup 24 3; echo -ne "\e[32m s. Save \e[0m"

tput cup 27 3; echo -ne "\033[46;30m Select Option : \e[0m"; tput cup 25 21

read -n 1 y

case "$y" in

  a)
		tput reset
		clear
    DEBIAN_FRONTEND=noninteractive sudo apt-get --yes update
    DEBIAN_FRONTEND=noninteractive sudo apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
    DEBIAN_FRONTEND=noninteractive sudo apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
    echo date +'%Y%m%d' > /root/LAST_UPGRADE
		;;

  b)
		tput reset
		clear
		source /installer/diskpart/install.sh
		;;

  c)
  	tput reset
  	clear
  	source /installer/crypt-setup/install.sh
  	read -p "Appuyez sur [ENTREE] pour continuer..."
  	;;

  d)
    tput reset
    clear
    source /installer/decrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  e)
    tput reset
    clear
    source /installer/secure/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  f)
    tput reset
    clear
    source /installer/apache/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  g)
    tput reset
    clear
    source /installer/www/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  h)
    tput reset
    clear
    source /installer/php/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  i)
    tput reset
    clear
    source /installer/mariadb/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  j)
    tput reset
    clear
    source /installer/mail-server/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  o)
    tput reset
    clear
    source /installer/api/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  o)
    tput reset
    clear
    source /installer/zonedns/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  q)
    tput reset
    clear
    source /installer/letsencrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  u)
		tput reset
		clear
    rm -R /installer
    mkdir /installer
    git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer
    chmod +x /installer/menu.sh
    source /installer/menu.sh
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
esac
done
