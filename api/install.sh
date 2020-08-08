#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT API ===="

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $API_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement api.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e API_AREYOUSURE; fi
if [[ $API_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Création de l'espace d'hébergement api.$DOMAIN..."

  if [ ! -d "/srv/api" ]; then verbose mkdir /srv/api; fi
  if [ ! -f "/srv/api/index.html" ]; then echo "API" > /srv/api/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/api.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /installer/api/vhost > /etc/apache2/sites-enabled/api.conf; fi

  if ! grep -q "<Directory /srv/api/>" /etc/apache2/apache2.conf
  then
    printf "<Directory /srv/api/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n" >> /etc/apache2/apache2.conf
  fi

  verbose systemctl restart apache2
  echo_magenta "L'espace d'hébergement api.$DOMAIN a été installé avec succès !"
fi
