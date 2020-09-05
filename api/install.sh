#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MARIADB_ADMIN_USER ]; then require MARIADB_ADMIN_USER string "Veuillez renseigner le nom de l'administrateur MARIADB :"; source /root/.allspark; fi
if [ -z $MARIADB_ADMIN_PASSWORD ] || [ $MARIADB_ADMIN_PASSWORD = "auto" ]; then require MARIADB_ADMIN_PASSWORD password "Veuillez renseigner le mot de passe de l'administrateur MARIADB :"; source /root/.allspark; fi
if [ -z $AES_KEY ] || [ $AES_KEY = "auto" ]; then require AES_KEY aeskey "Veuillez renseigner une clé de chiffrement AES de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
if [ -z $API_SHA_KEY ] || [ $API_SHA_KEY = "auto" ]; then require API_SHA_KEY aeskey "Veuillez renseigner une clé de chiffrement SHA de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
if [ -z $MODULE_API ]; then require MODULE_API yesno "Voulez-vous installer l'espace d'hébergement api.$DOMAIN ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_API = "Y" ]
then
  echo
  echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT API ===="

  echo_magenta "Création de l'espace d'hébergement api.$DOMAIN..."
  if [ ! -d "/srv/api" ]; then verbose mkdir /srv/api; fi
  if [ ! -f "/etc/apache2/sites-enabled/api.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/api/vhost > /etc/apache2/sites-enabled/api.conf; fi
  chown -R www-data:www-data /srv/api

  cd /srv/api
  cp -R /etc/allspark/api/install/. /srv/api/
  envsubst '${MARIADB_ADMIN_USER} ${MARIADB_ADMIN_PASSWORD} ${DOMAIN} ${AES_KEY} ${API_SHA_KEY}' < /etc/allspark/api/install/config.php > /srv/api/config.php
  envsubst '${MARIADB_ADMIN_USER} ${MARIADB_ADMIN_PASSWORD} ${DOMAIN} ${AES_KEY} ${API_SHA_KEY}' < /etc/allspark/api/install/connect.php > /srv/api/connect.php

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
