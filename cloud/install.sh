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
  if [ ! -f "/etc/apache2/sites-enabled/cloud.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/cloud/vhost > /etc/apache2/sites-enabled/cloud.conf; fi
  chown -R www-data:www-data /srv/cloud;

  echo_magenta "Installation du module SABREDAV ALLSPARK"
  cp /etc/allspark/cloud/composer.json /srv/cloud/composer.json
  cp -R /etc/allspark/cloud/allspark /srv/cloud/allspark
  envsubst '${AES_KEY}' < /etc/allspark/cloud/allspark/DAV/Auth/Backend/PDO.php > /srv/cloud/allspark/DAV/Auth/Backend/PDO.php
  envsubst '${DOMAIN} ${CLOUD_MARIADB_USER} ${CLOUD_MARIADB_PASSWORD}' < /etc/allspark/cloud/server.php > /srv/cloud/server.php

  echo_magenta "Création des dossiers et configuration des autorisations"
  mkdir -p /srv/files
  chown -R www-data:www-data /srv/files

  echo_magenta "Installation de SABREDAV (et ses dépendances)"
  apt-get -qq -y install composer
  cd /srv/cloud
  chown -R debian:debian /srv/cloud
  sudo -u debian composer install
  sudo -u debian composer update
  chown -R www-data:www-data /srv/cloud

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
