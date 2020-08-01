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
fi

if [ ! $APACHE_DEFAULSITE_AREYOUSURE ]; then echo_green "Etes vous sûr ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_DEFAULSITE_AREYOUSURE; fi
if [[ $APACHE_DEFAULSITE_AREYOUSURE =~ ^[YyOo]$ ]]
then
  if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi
  echo_magenta "Création du site par défaut www.$DOMAIN"
  verbose mkdir /srv/website
  verbose cp /installer/apache/index.html /srv/website
  verbose sed -e 's/$DOMAIN/'$DOMAIN'/g' /srv/installer/apache/default_vhost > /etc/apache2/sites-enabled/$DOMAIN.config
fi
