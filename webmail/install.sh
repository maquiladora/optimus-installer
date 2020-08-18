#!/bin/bash
source /installer/functions.sh
require DOMAIN
source /root/.allspark

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
    printf "<Directory /srv/webmail/>\n\tOptions Indexes FollowSymLinks\n\tAllowOverride None\n\tRequire all granted\nphp_flag display_errors Off\n\tphp_flag log_errors On\n\tphp_value error_log logs/errors\n\tphp_value upload_max_filesize 20M\n\tphp_value post_max_size 24M\n\tphp_value memory_limit 64M\n\tphp_flag zlib.output_compression Off\n\tphp_flag suhosin.session.encrypt Off\n\tphp_flag session.auto_start Off\n\tphp_value session.gc_maxlifetime 21600\n\tphp_value session.gc_divisor 500\n\tphp_value session.gc_probability 1\n\t</Directory>\n\n" >> /etc/apache2/apache2.conf
  fi
  
  echo_magenta "Installation des extensions PHP nécessaires"
  #verbose apt-get install php-ldap php-intl
  #verbose pear install Net_SMTP
  #verbose pear install Auth_SASL
  #verbose pear install Net_IDNA2
  #verbose pear install Mail_mime

  echo_magenta "Installation de ROUNDCUBE"
  cd /srv/webmail
  wget -q https://github.com/roundcube/roundcubemail/releases/download/1.4.8/roundcubemail-1.4.8-complete.tar.gz
  tar xfz roundcubemail-1.4.8-complete.tar.gz --strip 1
  verbose rm roundcubemail-1.4.8-complete.tar.gz
  verbose chown -R www-data:www-data /srv/webmail

  echo_magenta "Creation des bases de données ROUNDCUBE"
  verbose mariadb -u root -e "CREATE DATABASE roundcubemail CHARACTER SET utf8 COLLATE utf8_general_ci;"

  echo_magenta "Creation de l'utilisateur 'admin'"
  verbose mariadb -u root -e "GRANT ALL PRIVILEGES ON roundcubemail.* TO roundcube@localhost IDENTIFIED BY 'password';"
  verbose mariadb -u root -e "FLUSH PRIVILEGES;"
  mariadb < /srv/webmail/SQL/mysql.initial.sql



  #echo_magenta "Installation de COMPOSER"
  #php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  #php -r "if (hash_file('sha384', 'composer-setup.php') != 'e5325b19b381bfd88ce90a5ddb7823406b2a38cff6bb704b0acc289a09c8128d4a8ce2bbafcd1fcbdc38666422fe2806') unlink('composer-setup.php'); echo PHP_EOL;"
  #php composer-setup.php --install-dir /etc
  #php -r "unlink('composer-setup.php');"

  #sudo -u debian /etc/composer.phar require sabre/dav ~3.2.0

  #echo_magenta "Installation du module SABREDAV OPTIMUS"
  #cp -R /installer/cloud/optimus /srv/cloud/vendor/optimus
  #sed -e 's/%DOMAIN%/'$DOMAIN'/g' /installer/cloud/server.php > /srv/cloud/server.php

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
