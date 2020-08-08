#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== INSTALLATION DU CLOUD SABREDAV (WEBDAV) ===="

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

    echo_magenta "L'espace d'hébergement cloud.$DOMAIN a été installé avec succès !"

  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') != 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') unlink('composer-setup.php'); echo PHP_EOL;"
  php composer-setup.php --install-dir /srv/cloud
  php -r "unlink('composer-setup.php');"
  #chown -R debian:debian /srv/cloud;
chown -R www-data:www-data /srv/cloud;
  verbose sudo -u www-data /srv/cloud/composer.phar require sabre/dav ~3.2.0



  verbose systemctl restart apache2



fi
