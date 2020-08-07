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

tput cup 5  3; if stat /var/cache/apt/ | grep -q 'Modify'; then echo_green "a. Mettre à jour le système"; else echo_red "a. Mettre à jour le système"; fi
tput cup 6  3; if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'; then echo_green "b. Créer une partition /dev/sda2 indépendante"; else echo_red "b. Créer une partition /dev/sda2 indépendante"; fi
tput cup 7  3; if /sbin/blkid /dev/sda2 2>/dev/null | grep -q 'crypto_LUKS'; then echo_green "c. Activer le cryptage sur la partition /dev/sda2"; else echo_red "c. Activer le cryptage sur la partition /dev/sda2"; fi
tput cup 8  3; if lsblk -o MOUNTPOINT -n /dev/mapper/cryptsda2 2>/dev/null | grep -q '/srv'; then echo_green "d. Decrypter la partition /dev/sda2 et la monter sur /srv"; else echo_red "d. Decrypter la partition /dev/sda2 et la monter sur /srv"; fi
tput cup 9  3; if grep -q "Port 7822" /etc/ssh/sshd_config; then echo_green "e. Sécuriser le serveur"; else echo_red "e. Sécuriser le serveur"; fi
tput cup 10  3; if [ -f "/etc/apache2/apache2.conf" ];	then echo_green "f. Installer le serveur web APACHE"; else echo_red "f. Installer le serveur web APACHE"; fi
tput cup 11 3; if [ -d "/srv/www" ]; then echo_green "g. Installer l'espace d'hébergement www"; else echo_red "g. Installer l'espace d'hébergement www"; fi
tput cup 12 3; if [ -d "/etc/php" ]; then echo_green "h. Installer PHP"; else echo_red "h. Installer PHP"; fi
tput cup 13 3; if [ -d "/srv/databases" ]; then echo_green "i. Installer MARIADB"; else echo_red "i. Installer MARIADB"; fi
tput cup 14 3; if [ -d "/srv/mailboxes" ]; then echo_green "j. Installer le serveur mail"; else echo_red "j. Installer le serveur mail"; fi
#14 WEBMAIL j
#15 CLOUD k
tput cup 17 3; if [ -d "/etc/letsencrypt" ]; then echo_green "l. Installer les certificats HTTPS"; else echo_red "l. Installer les certificats HTTPS"; fi

#tput cup 7 	3; if [ -f "/srv/installer/config.conf" ]; 	then echo -ne "\e[32m v. Set Installation Variables \e[0m"; 			else echo -ne "\e[31m v. Set Installation Variables \e[0m"; fi
#tput cup 8 	3; if [ -f "/srv/installer/config.conf" ]; 	then echo -ne "\e[32m d. Show DNS zone \e[0m"; 										else echo -ne "\e[31m d. Show DNS zone \e[0m"; fi
#tput cup 14 3; if [ -d "/srv/roundcube" ]; 							then echo -ne "\e[32m 4. Install ROUNDCUBE webmail \e[0m"; 				else echo -ne "\e[31m 4. Install ROUNDCUBE webmail \e[0m"; fi
#tput cup 15 3; if [ -d "/srv/owncloud" ]; 							then echo -ne "\e[32m 5. Install OWNCLOUD server \e[0m"; 					else echo -ne "\e[31m 5. Install OWNCLOUD server \e[0m"; fi
#tput cup 16 3; if [ -f "/etc/default/rsync" ]; 					then echo -ne "\e[32m 6. Install RSYNC backup \e[0m"; 						else echo -ne "\e[31m 6. Install RSYNC backup \e[0m"; fi
#tput cup 17 3; if [ -d "/srv/optimus" ]; 								then echo -ne "\e[32m 7. Install OPTIMUS-AVOCATS \e[0m"; 					else echo -ne "\e[31m 7. Install OPTIMUS-AVOCATS \e[0m"; fi
#tput cup 18 3; if [ -d "/srv/optimus" ]; 								then echo -ne "\e[32m 8. Create new OPTIMUS-AVOCATS user \e[0m";	else echo -ne "\e[31m 8. Create new OPTIMUS-AVOCATS user \e[0m"; fi
#tput cup 20 3; echo -ne "\e[32m b. DB backup \e[0m"

tput cup 20 3; echo_green "t. Afficher la configuration de la zone DNS"
tput cup 21 3; echo_green "u. Update Installer"
tput cup 22 3; echo_green "v. Reboot server"
tput cup 23 3; echo_green "x. Quit"

#tput cup 24 3; echo -ne "\e[32m s. Save \e[0m"

tput cup 25 3; echo -ne "\033[46;30m Select Option : \e[0m"; tput cup 25 21

read -n 1 y

case "$y" in

  a)
		tput reset
		clear
    DEBIAN_FRONTEND=noninteractive sudo apt-get --yes update
    DEBIAN_FRONTEND=noninteractive sudo apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
    DEBIAN_FRONTEND=noninteractive sudo apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
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
    source /installer/website/install.sh
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


  l)
    tput reset
    clear
    source /installer/letsencrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  t)
    tput reset
    clear
    source /installer/zonedns/install.sh
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
