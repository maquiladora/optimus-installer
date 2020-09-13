#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_WEBMAIL ]; then require MODULE_WEBMAIL yesno "Voulez-vous installer le webmail ROUNDCUBE ?"; source /root/.allspark; fi
if [ -z $MAILSERVER_MARIADB_USER ]; then require MAILSERVER_MARIADB_USER string "Veuillez renseigner le nom de l'utilisateur mail MARIADB :"; source /root/.allspark; fi
if [ -z $MAILSERVER_MARIADB_PASSWORD ] || [ $MAILSERVER_MARIADB_PASSWORD = "auto" ]; then require MAILSERVER_MARIADB_PASSWORD password "Veuillez renseigner le mot de passe de l'utilisateur mail MARIADB :"; source /root/.allspark; fi
if [ -z $AES_KEY ] || [ $AES_KEY = "auto" ]; then require AES_KEY aeskey "Veuillez renseigner une clé de chiffrement AES de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
if [ -z $API_SHA_KEY ] || [ $API_SHA_KEY = "auto" ]; then require API_SHA_KEY aeskey "Veuillez renseigner une clé de chiffrement SHA de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
if [ -z $WEBMAIL_DES_KEY ] || [ $WEBMAIL_DES_KEY = "auto" ]; then require WEBMAIL_DES_KEY deskey "Veuillez renseigner une clé de chiffrement DES de 24 caractères [A-Za-z0-9]"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_WEBMAIL = "Y" ]
then
  echo
  echo_green "==== INSTALLATION DU WEBMAIL ===="

  echo_magenta "Création de l'espace d'hébergement webmail.$DOMAIN"
  mkdir -p /srv/webmail
  if [ ! -f "/etc/apache2/sites-enabled/webmail.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/webmail/vhost > /etc/apache2/sites-enabled/webmail.conf; fi

  echo_magenta "Installation des extensions PHP nécessaires"
  verbose apt-get -qq -y install gnupg php-ldap php-intl curl

  echo_magenta "Recherche de la version la plus récente de roundcube"
  latest=$(curl --silent "https://api.github.com/repos/roundcube/roundcubemail/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  echo_magenta $latest

  echo_magenta "Installation de ROUNDCUBE"
  cd /srv/webmail
  wget -q https://github.com/roundcube/roundcubemail/releases/download/$latest/roundcubemail-$latest-complete.tar.gz
  tar xfz roundcubemail-$latest-complete.tar.gz --strip 1
  verbose rm roundcubemail-$latest-complete.tar.gz
  verbose chown -R www-data:www-data /srv/webmail
  mkdir -p /var/log/roundcube
  chown www-data:www-data /var/log/roundcube
  envsubst '${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD} ${WEBMAIL_DES_KEY}' < /etc/allspark/webmail/config.inc.php > /srv/webmail/config/config.inc.php
  cp /etc/allspark/webmail/logo.svg /srv/webmail/skins/elastic/images/logo.svg
  cp /etc/allspark/webmail/favicon.ico /srv/webmail/skins/elastic/images/favicon.ico


  echo_magenta "Installation de COMPOSER"
  verbose apt-get -qq -y install composer

  echo_magenta "Installation des dépendances et plugins"
  cd /srv/webmail
  chown -R debian:debian /srv/webmail
  cp /etc/allspark/webmail/composer.json /srv/webmail/composer.json
  verbose sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=512
  verbose chmod 600 /var/swap.1
  verbose sudo /sbin/mkswap /var/swap.1
  verbose sudo /sbin/swapon /var/swap.1
  sudo -u debian composer install --no-interaction --no-dev
  sudo -u debian composer update --no-interaction  --no-dev
  verbose sudo /sbin/swapoff /var/swap.1
  vervose rm /var/swap.1
  chown -R www-data:www-data /srv/webmail

  echo_magenta "Modification de la configuration du plugin SAUSERPREFS"
  sed -i "s#mysql://username:password@localhost/database#mysql://$MAILSERVER_MARIADB_USER:$MAILSERVER_MARIADB_PASSWORD@127.0.0.1/mailserver#g" /srv/webmail/plugins/sauserprefs/config.inc.php

  echo_magenta "Modification de la configuration du plugin ENIGMA"
  mkdir -p /srv/mailboxes/gpg-keys
  chown www-data:www-data /srv/mailboxes/gpg-keys
  cp /etc/allspark/webmail/enigma/config.inc.php /srv/webmail/plugins/enigma/config.inc.php
  chown www-data:www-data /srv/webmail/plugins/enigma/config.inc.php

  echo_magenta "Modification de la configuration du plugin CONTEXTMENU_FOLDER"
  cp /etc/allspark/webmail/contextmenu_folder/localization/fr_FR.inc /srv/webmail/plugins/contextmenu_folder/localization/fr_FR.inc

  echo_magenta "Modification de la configuration du plugin HOTKEYS"
  cp /etc/allspark/webmail/hotkeys/default.inc.php /srv/webmail/plugins/hotkeys/default.inc.php
  cp /etc/allspark/webmail/hotkeys/hotkeys.json /srv/webmail/plugins/hotkeys/hotkeys.json
  cp /etc/allspark/webmail/hotkeys/localization/fr_FR.inc /srv/webmail/plugins/hotkeys/localization/fr_FR.inc

  echo_magenta "Modification de la configuration du plugin MANAGESIEVE"
  cp /etc/allspark/webmail/managesieve/config.inc.php /srv/webmail/plugins/managesieve/config.inc.php

  echo_magenta "Modification de la configuration du plugin ALLSPARK_AUTOLOGIN"
  mkdir -p /srv/webmail/plugins/allspark_autologin
  envsubst '${AES_KEY} ${API_SHA_KEY}' < /etc/allspark/webmail/allspark_autologin/allspark_autologin.php > /srv/webmail/plugins/allspark_autologin/allspark_autologin.php
  cp /etc/allspark/api/JWT.php /srv/webmail/plugins/allspark_autologin/JWT.php

  echo_magenta "Creation des bases de données ROUNDCUBE"
  verbose mariadb -u root -e "CREATE DATABASE IF NOT EXISTS roundcube CHARACTER SET utf8 COLLATE utf8_general_ci;"
  mariadb roundcube < /srv/webmail/SQL/mysql.initial.sql

  echo_magenta "Creation de l'utilisateur MARIADB"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON roundcube.* TO '$MAILSERVER_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT ON users.users TO '$MAILSERVER_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "FLUSH PRIVILEGES;"

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
