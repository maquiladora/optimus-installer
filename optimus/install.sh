#!/bin/bash
source /etc/allspark/functions.sh
require DOMAIN
source /root/.allspark

echo
echo_green "==== INSTALLATION DU CLIENT OPTIMUS ===="

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $OPTIMUS_AREYOUSURE ]; then echo_green "Voulez-vous installer le client OPTIMUS ?"; read -p "(o)ui / (n)on ? " -n 1 -e OPTIMUS_AREYOUSURE; fi
if [[ $OPTIMUS_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Création de l'espace d'hébergement optimus.$DOMAIN..."

  if [ ! -d "/srv/optimus" ]; then verbose mkdir /srv/optimus; fi
  if [ ! -f "/srv/optimus/index.html" ]; then echo "optimus" > /srv/optimus/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/optimus.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/optimus/vhost > /etc/apache2/sites-enabled/optimus.conf; fi

  if ! grep -q "<Directory /srv/optimus/>" /etc/apache2/apache2.conf
  then
    printf "<Directory /srv/optimus/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n" >> /etc/apache2/apache2.conf
  fi

  verbose systemctl restart apache2
  echo_magenta "L'espace d'hébergement optimus.$DOMAIN a été installé avec succès !"
fi
