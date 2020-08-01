#!/bin/bash

source functions.sh
source config.sh

while : ; do

clear

tput cup 2 	4; echo -ne  "\033[46;30m          OPTIMUS INSTALLER          \e[0m"
tput cup 3 	4; echo -ne  "\033[46;30m                V1.07                \e[0m"

tput cup 5  3; if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'; then echo -ne "\e[32m a. Créer une partition /dev/sda2 indépendante \e[0m"; else echo -ne "\e[31m a. Créer une partition /dev/sda2 indépendante \e[0m"; fi
tput cup 6  3; if /sbin/blkid /dev/sda2 2>/dev/null | grep -q 'crypto_LUKS'; then echo -ne "\e[32m b. Activer le cryptage sur la partition /dev/sda2 \e[0m"; else echo -ne "\e[31m b. Activer le cryptage sur la partition /dev/sda2 \e[0m"; fi
tput cup 7  3; if lsblk -o MOUNTPOINT -n /dev/mapper/cryptsda2 2>/dev/null | grep -q '/srv'; then echo -ne "\e[32m c. Decrypter la partition /dev/sda2 et la monter sur /srv \e[0m"; else echo -ne "\e[31m c. Decrypter la partition /dev/sda2 et la monter sur /srv \e[0m"; fi
tput cup 8  3; if grep -q "Port 7822" /etc/ssh/sshd_config; then echo -ne "\e[32m d. Sécuriser le serveur \e[0m"; else echo -ne "\e[31m d. Sécuriser le serveur \e[0m"; fi
tput cup 9  3; if [ -f "/etc/apache2/apache2.conf" ];	then echo -ne "\e[32m e. Installer le serveur web APACHE \e[0m"; else echo -ne "\e[31m e. Installer le serveur web APACHE \e[0m"; fi
#lsblk -o MOUNTPOINT -n /dev/sda2

#tput cup 5 	3; if [ -f "/etc/srv" ]; 		                then echo -ne "\e[32m c. Create /srv partition \e[0m"; 		        else echo -ne "\e[31m c. Create /srv partitions \e[0m"; fi
#tput cup 6 	3; if [ -f "/etc/init.d/cryptomount" ]; 		then echo -ne "\e[32m c. Crypt /srv partition \e[0m"; 		        else echo -ne "\e[31m c. Crypt srv partitions \e[0m"; fi
#tput cup 7 	3; if [ -f "/srv/installer/config.conf" ]; 	then echo -ne "\e[32m v. Set Installation Variables \e[0m"; 			else echo -ne "\e[31m v. Set Installation Variables \e[0m"; fi
#tput cup 8 	3; if [ -f "/srv/installer/config.conf" ]; 	then echo -ne "\e[32m d. Show DNS zone \e[0m"; 										else echo -ne "\e[31m d. Show DNS zone \e[0m"; fi

#tput cup 10 3; if [ -d "/etc/letsencrypt" ]; 						then echo -ne "\e[32m 0. Install TLS certificates \e[0m"; 				else echo -ne "\e[31m 0. Install TLS certificates \e[0m"; fi
#tput cup 11 3; if [ -f "/etc/mysql/my.cnf" ]; 					then echo -ne "\e[32m 1. Install MYSQL database server \e[0m"; 		else echo -ne "\e[31m 1. Install MYSQL database server \e[0m"; fi
#tput cup 12 3; if [ -f "/etc/apache2/apache2.conf" ]; 	then echo -ne "\e[32m 2. Install APACHE web server \e[0m"; 				else echo -ne "\e[31m 2. Install APACHE web server \e[0m"; fi
#tput cup 13 3; if [ -f "/etc/dovecot/dovecot.conf" ]; 	then echo -ne "\e[32m 3. Install MAIL server \e[0m"; 							else echo -ne "\e[31m 3. Install MAIL server \e[0m"; fi
#tput cup 14 3; if [ -d "/srv/roundcube" ]; 							then echo -ne "\e[32m 4. Install ROUNDCUBE webmail \e[0m"; 				else echo -ne "\e[31m 4. Install ROUNDCUBE webmail \e[0m"; fi
#tput cup 15 3; if [ -d "/srv/owncloud" ]; 							then echo -ne "\e[32m 5. Install OWNCLOUD server \e[0m"; 					else echo -ne "\e[31m 5. Install OWNCLOUD server \e[0m"; fi
#tput cup 16 3; if [ -f "/etc/default/rsync" ]; 					then echo -ne "\e[32m 6. Install RSYNC backup \e[0m"; 						else echo -ne "\e[31m 6. Install RSYNC backup \e[0m"; fi
#tput cup 17 3; if [ -d "/srv/optimus" ]; 								then echo -ne "\e[32m 7. Install OPTIMUS-AVOCATS \e[0m"; 					else echo -ne "\e[31m 7. Install OPTIMUS-AVOCATS \e[0m"; fi
#tput cup 18 3; if [ -d "/srv/optimus" ]; 								then echo -ne "\e[32m 8. Create new OPTIMUS-AVOCATS user \e[0m";	else echo -ne "\e[31m 8. Create new OPTIMUS-AVOCATS user \e[0m"; fi

#tput cup 20 3; echo -ne "\e[32m b. DB backup \e[0m"

tput cup 20 3; echo -ne "\e[32m u. Update Installer \e[0m"
tput cup 21 3; echo -ne "\e[32m q. Quit \e[0m"

#tput cup 24 3; echo -ne "\e[32m s. Save \e[0m"

tput cup 25 3; echo -ne "\033[46;30m Select Option : \e[0m"; tput cup 25 21

read -n 1 y

case "$y" in

  a)
		tput reset
		clear
		source /installer/diskpart/install.sh
		;;

  b)
  	tput reset
  	clear
  	source /installer/crypt-setup/install.sh
  	read -p "Appuyez sur [ENTREE] pour continuer..."
  	;;

  c)
    tput reset
    clear
    source /installer/decrypt/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;

  d)
    tput reset
    clear
    source /installer/secure/install.sh
    read -p "Appuyez sur [ENTREE] pour continuer..."
    ;;









	v)
		tput reset
		clear
		source config.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	d)
		tput reset
		clear
		source /srv/installer/dns/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	0)
		tput reset
		clear
		source /srv/installer/letsencrypt/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	1)
		tput reset
		clear
		source /srv/installer/mysql/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	2)
		tput reset
		clear
		source /srv/installer/apache/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	3)
		tput reset
		clear
		source /srv/installer/mail/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	4)
		tput reset
		clear
		source /srv/installer/roundcube/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	5)
		tput reset
		clear
		source /srv/installer/owncloud/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	6)
		tput reset
		clear
		source /srv/installer/rsync/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	7)
		tput reset
		clear
		source /srv/installer/optimus/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	8)
		tput reset
		clear
		source /srv/installer/optimus_user/install.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	b)
		tput reset
		clear
		source /srv/installer/db_backup.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

  q)
    tput reset
    clear
    exit 1
    ;;

  u)
		tput reset
		clear
    bash <(wget -qO-  https://raw.githubusercontent.com/MetallianFR68/optimus-installer/vest/install.sh)
		;;

	s)
		tput reset
		clear
		source saver.sh
		read -p "Appuyez sur [ENTREE] pour continuer..."
		;;

	*)
		tput cup 26 21
		read -p "Unknown command. Press [Enter] key to continue..."
		tput reset
		clear
		;;
esac
done
