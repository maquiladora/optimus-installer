#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_OPTIMUS ]; then require MODULE_OPTIMUS yesno "Voulez-vous installer le client OPTIMUS ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_OPTIMUS = "Y" ]
then

  echo
  echo_green "==== INSTALLATION DU CLIENT OPTIMUS ===="

  echo_magenta "Création de l'espace d'hébergement optimus.$DOMAIN"
  if [ ! -d "/srv/optimus" ]; then verbose mkdir /srv/optimus; fi
  if [ ! -f "/srv/optimus/index.html" ]; then echo "optimus" > /srv/optimus/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/optimus.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/optimus/vhost > /etc/apache2/sites-enabled/optimus.conf; fi

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2

fi
