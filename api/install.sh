#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_API ]; then require MODULE_API yesno "Voulez-vous installer l'espace d'hébergement api.$DOMAIN ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_API = "Y" ]
then
  echo
  echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT API ===="

  echo_magenta "Création de l'espace d'hébergement api.$DOMAIN..."
  if [ ! -d "/srv/api" ]; then verbose mkdir /srv/api; fi
  if [ ! -f "/srv/api/index.html" ]; then echo "API" > /srv/api/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/api.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/api/vhost > /etc/apache2/sites-enabled/api.conf; fi
  chown -R www-data:www-data /srv/api

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
