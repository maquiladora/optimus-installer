#!/bin/bash
source /etc/allspark/functions.sh
require DOMAIN
require CLOUD_MARIADB_USER
require CLOUD_MARIADB_PASSWORD password
source /root/.allspark

echo
echo_green "==== INSTALLATION DU CLOUD SABREDAV (WEBDAV) ===="

if [ ! $CLOUD_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement cloud.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e CLOUD_AREYOUSURE; fi
if [[ $CLOUD_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Création de l'espace d'hébergement cloud.$DOMAIN..."
  mkdir -p /srv/cloud
  if [ ! -f "/srv/cloud/index.html" ]; then echo "cloud" > /srv/cloud/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/cloud.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/cloud/vhost > /etc/apache2/sites-enabled/cloud.conf; fi

  echo_magenta "Installation du module SABREDAV ALLSPARK"
  cp /etc/allspark/cloud/composer.json /srv/cloud/composer.json
  cp -R /etc/allspark/cloud/allspark /srv/cloud/allspark
  envsubst '${AES_KEY}' < /etc/allspark/cloud/allspark/DAV/Auth/Backend/PDO.php > /srv/cloud/allspark/DAV/Auth/Backend/PDO.php
  envsubst '${DOMAIN} ${CLOUD_MARIADB_USER} ${CLOUD_MARIADB_PASSWORD}' < /etc/allspark/cloud/server.php > /srv/cloud/server.php

  echo_magenta "Création d'un SWAP temporaire"
  verbose /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024 >& /dev/null
  verbose chmod 600 /var/swap.1
  verbose /sbin/mkswap /var/swap.1
  verbose /sbin/swapon /var/swap.1
  echo_magenta "Installation de COMPOSER"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') != '$(wget -q -O - https://composer.github.io/installer.sig)') unlink('composer-setup.php'); echo PHP_EOL;"
  php composer-setup.php --install-dir /etc
  php -r "unlink('composer-setup.php');"

  echo_magenta "Création des dossiers et configuration des authorisations"
  chown -R www-data:www-data /srv/cloud;
  mkdir -p /srv/files
  chown -R www-data:www-data /srv/files

  echo_magenta "Installation de SABREDAV (et ses dépendances)"
  cd /srv/cloud
  sudo -u debian /etc/composer.phar install
  echo_magenta "Suppresion du SWAP temporaire"
  verbose /sbin/swapoff /var/swap.1

  echo_magenta "Installation des bases de données MARIADB"
  if [ -f "/srv/databases/CLOUD_DB_VERSION" ]; then db_version=$(cat /srv/databases/CLOUD_DB_VERSION); fi
  for file in /etc/allspark/cloud/*.sql
  do
    file="${file:20:-4}"
    if [[ $file > $db_version ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /etc/allspark/cloud/$file.sql
      update_conf CLOUD_DB_VERSION $file
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done

  echo_magenta "Création de l'utilisateur MARIADB"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON cloud.* TO '$CLOUD_MARIADB_USER'@'localhost' IDENTIFIED BY '$CLOUD_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT ON users.users TO '$CLOUD_MARIADB_USER'@'localhost' IDENTIFIED BY '$CLOUD_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "FLUSH PRIVILEGES"

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2

fi
