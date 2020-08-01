#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $APACHE_DEFAULSITE_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement www.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_DEFAULSITE_AREYOUSURE; fi
if [[ $APACHE_DEFAULSITE_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Création de l'espace d'hébergement www.$DOMAIN..."

  if [ ! -d "/srv/www.$DOMAIN" ]; then verbose mkdir /srv/www.$DOMAIN; fi
  if [ ! -f "/srv/www.$DOMAIN/index.html" ]; then verbose echo "HELLO WORLD !" > /srv/www.$DOMAIN/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/www.$DOMAIN.conf" ]; then sed -e 's/%DOMAIN%/$DOMAIN/g' /installer/apache/default_vhost > /etc/apache2/sites-enabled/www.$DOMAIN.conf; fi

  if grep -q "<Directory /srv/www.$DOMAIN/>" "/etc/apache2/apache2.conf"
  then
    printf '<Directory /srv/www.$DOMAIN/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n' >> /etc/apache2/apache2.conf
  fi

  verbose systemctl restart apache2
  echo_magenta "L'espace d'hébergement www.$DOMAIN a été créé avec succès dans /srv/www.$DOMAIN !"
fi
