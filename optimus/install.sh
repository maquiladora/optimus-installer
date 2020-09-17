#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_OPTIMUS ]; then require MODULE_OPTIMUS yesno "Voulez-vous installer le client OPTIMUS ?"; source /root/.allspark; fi
if [ -z $OPTIMUS_MARIADB_USER ]; then require OPTIMUS_MARIADB_USER string "Veuillez renseigner le nom de l'administrateur MARIADB pour OPTIMUS :"; source /root/.allspark; fi
if [ -z $OPTIMUS_MARIADB_PASSWORD ] || [ $OPTIMUS_MARIADB_PASSWORD = "auto" ]; then require OPTIMUS_MARIADB_PASSWORD password "Veuillez renseigner le mot de passe de l'administrateur MARIADB pour OPTIMUS :"; source /root/.allspark; fi

source /root/.allspark

if [ $MODULE_OPTIMUS = "Y" ]
then

  echo
  echo_green "==== INSTALLATION D'OPTIMUS AVOCATS ===="

  echo_magenta "Création de l'espace d'hébergement optimus.$DOMAIN"
  if [ ! -d "/srv/optimus" ]; then verbose mkdir /srv/optimus; fi
  if [ ! -f "/srv/optimus/index.html" ]; then echo "optimus" > /srv/optimus/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/optimus.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/optimus/vhost > /etc/apache2/sites-enabled/optimus.conf; fi

  echo_magenta "Installation du client OPTIMUS"
  git clone https://github.com/MetallianFR68/optimus-avocats /srv/optimus
  envsubst '${AES_KEY} ${DOMAIN} ${OPTIMUS_MARIADB_USER} ${OPTIMUS_MARIADB_PASSWORD}' < /etc/allspark/optimus/config.custom.php > /srv/optimus/config.custom.php

  echo_magenta "Creation de l'utilisateur MARIADB"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON optimus.* TO '$OPTIMUS_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$OPTIMUS_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT ON users.users TO '$OPTIMUS_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$OPTIMUS_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "FLUSH PRIVILEGES;"


  echo_magenta "Installation de la base de données 'optimus_settings'"
  for file in /etc/allspark/optimus/optimus_settings/*.sql
  do
    file="${file:39:-4}"
    if [[ $file > $OPTIMUS_DB_VERSION ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /etc/allspark/optimus/optimus_settings/$file.sql
      update_conf OPTIMUS_DB_VERSION $file
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done


  echo_magenta "Installation de la base de données 'optimus_user_1'"
  verbose mariadb -u root -e "CREATE DATABASE IF NOT EXISTS optimus_user_1 CHARACTER SET utf8 COLLATE utf8_general_ci;"
  verbose mariadb -u root -e "USE optimus_user_1;"
  for file in /etc/allspark/optimus/optimus_user/*.sql
  do
    file="${file:35:-4}"
    if [[ $file > $OPTIMUS_DB_CLIENT_VERSION ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /etc/allspark/optimus/optimus_user/$file.sql
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done
  verbose mariadb -u root -e "INSERT INTO optimus_user_1.structures VALUES ('1','1','$DOMAIN','2020-01-01','');"


  echo_magenta "Installation de la base de données 'optimus_structure_1'"
  verbose mariadb -u root -e "CREATE DATABASE IF NOT EXISTS optimus_user_1 CHARACTER SET utf8 COLLATE utf8_general_ci;"
  verbose mariadb -u root -e "USE optimus_structure_1;"
  for file in /etc/allspark/optimus/optimus_structure/*.sql
  do
    file="${file:40:-4}"
    if [[ $file > $OPTIMUS_DB_STRUCTURE_VERSION ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /etc/allspark/optimus/optimus_structure/$file.sql
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done


  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2

fi
