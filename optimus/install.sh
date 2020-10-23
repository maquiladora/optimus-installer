#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_OPTIMUS ]; then require MODULE_OPTIMUS yesno "Voulez-vous installer le client OPTIMUS ?"; source /root/.allspark; fi
if [ -z $OPTIMUS_MARIADB_USER ]; then require OPTIMUS_MARIADB_USER string "Veuillez renseigner le nom de l'administrateur MARIADB pour OPTIMUS :"; source /root/.allspark; fi
if [ -z $OPTIMUS_MARIADB_PASSWORD ] || [ $OPTIMUS_MARIADB_PASSWORD = "auto" ]; then require OPTIMUS_MARIADB_PASSWORD password "Veuillez renseigner le mot de passe de l'administrateur MARIADB pour OPTIMUS :"; source /root/.allspark; fi
if [ -z $AES_KEY ] || [ $AES_KEY = "auto" ]; then require AES_KEY aeskey "Veuillez renseigner une clé de chiffrement AES de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
if [ -z $API_SHA_KEY ] || [ $API_SHA_KEY = "auto" ]; then require API_SHA_KEY aeskey "Veuillez renseigner une clé de chiffrement SHA de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi

source /root/.allspark

if [ $MODULE_OPTIMUS = "Y" ]
then

  echo
  echo_green "==== INSTALLATION D'OPTIMUS AVOCATS ===="
  #if [ ! -f "/srv/optimus/config.custom.php" ]
  #then
    #echo_magenta "Sauvegarde de la configration personnalisée"
    #cp /srv/optimus/config.custom.php /root/.allspark/config.custom.php
  #fi

  #echo_magenta "Création de l'espace d'hébergement optimus.$DOMAIN"
  #rm -R /srv/optimus
  #verbose mkdir /srv/optimus
  #if [ ! -f "/srv/optimus/index.html" ]; then echo "optimus" > /srv/optimus/index.html; fi
  #if [ ! -f "/etc/apache2/sites-enabled/optimus.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/optimus/vhost > /etc/apache2/sites-enabled/optimus.conf; fi

  #echo_magenta "Installation du client OPTIMUS"
  #git clone https://github.com/MetallianFR68/optimus-avocats /srv/optimus
  #envsubst '${AES_KEY} ${SHA_KEY} ${DOMAIN} ${OPTIMUS_MARIADB_USER} ${OPTIMUS_MARIADB_PASSWORD}' < /etc/allspark/optimus/config.custom.php > /srv/optimus/config.custom.php

  echo_magenta "Creation de l'utilisateur MARIADB"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON optimus_user_1.* TO '$OPTIMUS_MARIADB_USER'@'localhost' IDENTIFIED BY '$OPTIMUS_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON optimus_structure_1.* TO '$OPTIMUS_MARIADB_USER'@'localhost' IDENTIFIED BY '$OPTIMUS_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON optimus_settings.* TO '$OPTIMUS_MARIADB_USER'@'localhost' IDENTIFIED BY '$OPTIMUS_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT ON users.users TO '$OPTIMUS_MARIADB_USER'@'localhost' IDENTIFIED BY '$OPTIMUS_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "FLUSH PRIVILEGES;"

	echo_magenta "installation du module api optimus"
	sudo rm -R /srv/api/api_optimus
	sudo mkdir /srv/api/api_optimus
	sudo git clone https://gitlab.com/cybertronprime/optimus-api.git /srv/api/api_optimus/.

  #echo_magenta "Installation de la base de données 'optimus_settings'"
  #for file in /etc/allspark/optimus/optimus_settings/*.sql
  #do
    #file="${file:39:-4}"
    #if [[ $file > $OPTIMUS_DB_VERSION ]]
    #then
      #echo_magenta "--> $file.sql exécuté"
      #mariadb < /etc/allspark/optimus/optimus_settings/$file.sql
      #update_conf OPTIMUS_DB_VERSION $file
    #else
      #echo_magenta "--> $file.sql ignoré"
    #fi
  #done


  echo_magenta "Installation de la base de données 'prime@demoptimus.fr'"
  verbose mariadb -u root -e "CREATE DATABASE IF NOT EXISTS `prime@demoptimus.fr` CHARACTER SET utf8 COLLATE utf8_general_ci;"
  verbose mariadb -u root -e "USE `prime@demoptimus.fr`;"
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
  verbose mariadb -u root -e "INSERT IGNORE INTO `prime@demoptimus.fr`.structures VALUES ('1','1','$DOMAIN','2020-01-01',NULL);"


  echo_magenta "Installation de la base de données 'optimus_structure_1'"
  verbose mariadb -u root -e "CREATE DATABASE IF NOT EXISTS optimus_structure_1 CHARACTER SET utf8 COLLATE utf8_general_ci;"
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
