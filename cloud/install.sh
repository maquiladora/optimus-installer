#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez renseigner votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_CLOUD ]; then require MODULE_CLOUD yesno "Voulez-vous installer l'espace d'hébergement cloud.$DOMAIN ?"; source /root/.allspark; fi
if [ -z $API_SHA_KEY ] || [ $API_SHA_KEY = "auto" ]; then require API_SHA_KEY aeskey "Veuillez renseigner une clé de chiffrement SHA de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
if [ -z $CLOUD_MARIADB_USER ]; then require CLOUD_MARIADB_USER string "Veuillez renseigner le nom de l'utilisateur principal MARIADB :"; source /root/.allspark; fi
if [ -z $CLOUD_MARIADB_PASSWORD ] || [ $CLOUD_MARIADB_PASSWORD = "auto" ]; then require CLOUD_MARIADB_PASSWORD password "Voulez renseigner le mot de passe de l'utilisateur principal MARIADB :"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_CLOUD = "Y" ]
then
  echo
  echo_green "==== INSTALLATION DU CLOUD SABREDAV (WEBDAV) ===="

  echo_magenta "Création de l'espace d'hébergement cloud.$DOMAIN..."
  mkdir -p /srv/cloud
  if [ ! -f "/etc/apache2/sites-enabled/cloud.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/cloud/vhost > /etc/apache2/sites-enabled/cloud.conf; fi
  chown -R www-data:www-data /srv/cloud;

  echo_magenta "Installation du module SABREDAV ALLSPARK"
  cp /etc/allspark/cloud/composer.json /srv/cloud/composer.json
  cp /etc/allspark/cloud/JWT.php /srv/cloud/JWT.php
  cp -R /etc/allspark/cloud/allspark /srv/cloud/allspark
  envsubst '${AES_KEY} ${API_SHA_KEY}' < /etc/allspark/cloud/allspark/DAV/Auth/Backend/PDO.php > /srv/cloud/allspark/DAV/Auth/Backend/PDO.php
  envsubst '${AES_KEY} ${API_SHA_KEY}' < /etc/allspark/cloud/allspark/DAV/Auth/Backend/JWT.php > /srv/cloud/allspark/DAV/Auth/Backend/JWT.php
  envsubst '${DOMAIN} ${CLOUD_MARIADB_USER} ${CLOUD_MARIADB_PASSWORD} ${API_SHA_KEY}' < /etc/allspark/cloud/server.php > /srv/cloud/server.php

  echo_magenta "Création des dossiers et configuration des autorisations"
  mkdir -p /srv/files
  chown -R www-data:www-data /srv/files

  echo_magenta "Installation de SABREDAV (et ses dépendances)"
  verbose apt-get -qq -y install composer
  cd /srv/cloud
  chown -R debian:debian /srv/cloud
  sudo -u debian composer install --no-interaction --no-dev
  sudo -u debian composer update --no-interaction --no-dev
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
