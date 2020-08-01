#!/bin/bash
source /installer/functions.sh
source /installer/config.sh


if [ ! $APACHE_AREYOUSURE ]; then echo_green "Souhaitez vous installer le serveur apache ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_AREYOUSURE; fi
if [[ $APACHE_AREYOUSURE =~ ^[YyOo]$ ]]
then
  verbose apt-get -qq install apache2

  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw allow 80
    verbose /sbin/ufw allow 443
  fi

  sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/srv\/website/g' /etc/apache2/sites-enabled/000-default.conf

  if grep -q "<Directory /srv/website/>" "/etc/apache2/apache2.conf"
  then
    printf '<Directory /srv/website/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n' >> /etc/apache2/apache2.conf
  fi

  if [ ! -d "/srv/website" ];  then  verbose mkdir /srv/website; fi
  if [ ! -f "/srv/website/index.html" ]; then touch /srv/website/index.html; fi

  <Directory /srv/website/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>

  verbose systemctl restart apache2
fi


if [ ! $APACHE_DEFAULSITE_AREYOUSURE ]; then echo_green "Voulez-vous installer les hébergements par défaut ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_DEFAULSITE_AREYOUSURE; fi
if [[ $APACHE_DEFAULSITE_AREYOUSURE =~ ^[YyOo]$ ]]
then

  if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

  if [ ! $APACHE_WWW_AREYOUSURE ]; then echo_green "Voulez-vous installer l'hébergement de www.$DOMAIN' ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_WWW_AREYOUSURE; fi
  if [[ $APACHE_WWW_AREYOUSURE =~ ^[YyOo]$ ]]
  then
    echo_magenta "Création du site par défaut www.$DOMAIN"
    if [ ! -d "/srv/website" ];  then  verbose mkdir /srv/website; fi
    if [ ! -f "/srv/website/index.html" ]; then verbose cp /installer/apache/index.html /srv/website; fi
    if [ ! -f "/etc/apache2/sites-enabled/www.$DOMAIN.conf" ]; then sed -e 's/$DOMAIN/'$DOMAIN'/g' /installer/apache/default_vhost > /etc/apache2/sites-enabled/www.$DOMAIN.conf; fi
    verbose systemctl restart apache2
  fi

fi
