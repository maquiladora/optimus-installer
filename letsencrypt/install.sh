#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $LETSENCRYPT_AREYOUSURE ]; then echo_green "Souhaitez vous installer les certificats SSL HTTPS ?"; read -p "(o)ui / (n)on ? " -n 1 -e LETSENCRYPT_AREYOUSURE; fi
if [[ $LETSENCRYPT_AREYOUSURE =~ ^[YyOo]$ ]]
then

    echo_magenta "Installation de letsencrypt en cours..."
    verbose apt-get -qq -y install letsencrypt python-certbot-apache

    if [ -d "/srv/www" ]; then DOMAINS_TO_INSTALL="-d $DOMAIN -d www.$DOMAIN"; fi
    if [ -d "/srv/cloud" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d cloud.$DOMAIN"; fi
    if [ -d "/srv/webmail" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d webmail.$DOMAIN"; fi
    if [ -d "/srv/api" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d api.$DOMAIN"; fi
    if [ -d "/srv/mailboxes" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d mail.$DOMAIN"; fi

    verbose certbot run -n --apache --agree-tos --email postmaster@$DOMAIN --expand $DOMAINS_TO_INSTALL

    echo_magenta "les certificats SSL ont été installés avec succès..."

fi
