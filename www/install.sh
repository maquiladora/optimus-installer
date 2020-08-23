#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_WWW ]; then require MODULE_WWW  yesno "Souhaitez vous installer l'espace d'hébèrgement www.$DOMAIN ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_WWW = "Y" ]
then
  echo
  echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT WWW ===="

  echo_magenta "Création de l'espace d'hébergement www.$DOMAIN..."
  if [ ! -d "/srv/www" ]; then verbose mkdir /srv/www; fi
  if [ ! -f "/srv/www/index.html" ]; then echo "WWW" > /srv/www/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/www.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/www/vhost > /etc/apache2/sites-enabled/www.conf; fi
  chown -R www-data:www-data /srv/www

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
