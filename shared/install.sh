#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_SHARED ]; then require MODULE_SHARED yesno "Souhaitez vous installer l'espace d'hébèrgement partage.$DOMAIN ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_SHARED = "Y" ]
then
  echo
  echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT PARTAGE ===="

  echo_magenta "Création de l'espace d'hébergement partage.$DOMAIN"
  if [ ! -d "/srv/shared" ]; then verbose mkdir /srv/shared; fi
  if [ ! -f "/etc/apache2/sites-enabled/shared.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/shared/vhost > /etc/apache2/sites-enabled/shared.conf; fi

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
