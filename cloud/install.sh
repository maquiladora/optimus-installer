#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT CLOUD ===="

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $CLOUD_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement cloud.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e CLOUD_AREYOUSURE; fi
if [[ $CLOUD_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Création de l'espace d'hébergement cloud.$DOMAIN..."

  if [ ! -d "/srv/cloud" ]; then verbose mkdir /srv/cloud; fi
  if [ ! -f "/srv/cloud/index.html" ]; then echo "cloud" > /srv/cloud/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/cloud.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /installer/cloud/vhost > /etc/apache2/sites-enabled/cloud.conf; fi

  if ! grep -q "<Directory /srv/cloud/>" /etc/apache2/apache2.conf
  then
    printf "<Directory /srv/cloud/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n" >> /etc/apache2/apache2.conf
  fi

  verbose systemctl restart apache2
  echo_magenta "L'espace d'hébergement cloud.$DOMAIN a été installé avec succès !"
fi
