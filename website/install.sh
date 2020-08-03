#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo_green "==== INSTALLATION DE L'ESPACE D'HERGEMENT WWW ===="

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $APACHE_DEFAULSITE_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement www.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_DEFAULSITE_AREYOUSURE; fi
if [[ $APACHE_DEFAULSITE_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Création de l'espace d'hébergement www.$DOMAIN..."

  if [ ! -d "/srv/www" ]; then verbose mkdir /srv/www; fi
  if [ ! -f "/srv/www/index.html" ]; then verbose echo "HELLO WORLD !" > /srv/www/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/www.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /installer/website/vhost > /etc/apache2/sites-enabled/www.conf; fi

  if ! grep -q "<Directory /srv/www/>" /etc/apache2/apache2.conf
  then
    printf "<Directory /srv/www/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n" >> /etc/apache2/apache2.conf
  fi

  verbose systemctl restart apache2
  echo_magenta "L'espace d'hébergement www.$DOMAIN a été installé avec succès !"
fi
