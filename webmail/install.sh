#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== INSTALLATION DU WEBMAIL ===="

if [ ! $DOMAIN ]; then echo_green "Merci d'indiquer votre nom de domaine"; read DOMAIN; fi

if [ ! $WEBMAIL_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement webmail.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e WEBMAIL_AREYOUSURE; fi
if [[ $WEBMAIL_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Création de l'espace d'hébergement webmail.$DOMAIN..."

  if [ ! -d "/srv/webmail" ]; then verbose mkdir /srv/webmail; fi
  if [ ! -f "/srv/webmail/index.html" ]; then echo "webmail" > /srv/webmail/index.html; fi
  if [ ! -f "/etc/apache2/sites-enabled/webmail.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /installer/webmail/vhost > /etc/apache2/sites-enabled/webmail.conf; fi

  if ! grep -q "<Directory /srv/webmail/>" /etc/apache2/apache2.conf
  then
    printf "<Directory /srv/webmail/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\n</Directory>\n\n" >> /etc/apache2/apache2.conf
  fi

  echo_magenta "Installation des extensions PHP nécessaires"
  #verbose apt-get install php-ldap php-intl
  #verbose pear install Net_SMTP
  #verbose pear install Auth_SASL
  #verbose pear install Net_IDNA2
  #verbose pear install Mail_mime

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
