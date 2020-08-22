#!/bin/bash
source /etc/allspark/functions.sh
require DOMAIN
require MAILSERVER_MARIADB_USER
require MAILSERVER_MARIADB_PASSWORD password
require WEBMAIL_DES_KEY deskey
source /root/.allspark

echo
echo_green "==== INSTALLATION DU WEBMAIL ===="

if [ ! $WEBMAIL_AREYOUSURE ]; then echo_green "Voulez-vous installer l'espace d'hébergement webmail.$DOMAIN ?"; read -p "(o)ui / (n)on ? " -n 1 -e WEBMAIL_AREYOUSURE; fi
if [[ $WEBMAIL_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Création de l'espace d'hébergement webmail.$DOMAIN..."
  mkdir -p /srv/webmail
  if [ ! -f "/etc/apache2/sites-enabled/webmail.conf" ]; then sed -e 's/%DOMAIN%/'$DOMAIN'/g' /etc/allspark/webmail/vhost > /etc/apache2/sites-enabled/webmail.conf; fi

  echo_magenta "Installation des extensions PHP nécessaires"
  verbose apt-get -qq -y install php-ldap php-intl
  #verbose pear install Net_SMTP
  #verbose pear install Auth_SASL
  #verbose pear install Net_IDNA2
  #verbose pear install Mail_mime

  echo_magenta "Installation de ROUNDCUBE"
  cd /srv/webmail
  verbose git clone --depth=1 https://github.com/roundcube/roundcubemail .
  envsubst '${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD} ${WEBMAIL_DES_KEY}' < /etc/allspark/webmail/config.inc.php > /srv/webmail/config/config.inc.php


  echo_magenta "Installation de COMPOSER"
  apt-get -qq -y install composer

  echo_magenta "Installation des dépendances et plugins"
  cd /srv/webmail
  chown debian:debian /srv/webmail
  cp /etc/allspark/webmail/composer.json /srv/webmail/composer.json
  sudo -u debian composer install
  chown -R www-data:www-data /srv/webmail

  echo_magenta "Creation des bases de données ROUNDCUBE"
  verbose mariadb -u root -e "CREATE DATABASE roundcubemail CHARACTER SET utf8 COLLATE utf8_general_ci;"

  echo_magenta "Creation de l'utilisateur MARIADB 'roundcube'"
  verbose mariadb -u root -e "GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY 'password';"
  verbose mariadb -u root -e "FLUSH PRIVILEGES;"
  mariadb roundcubemail < /srv/webmail/SQL/mysql.initial.sql

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
