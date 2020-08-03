#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== INSTALLATION DU SERVEUR WEB APACHE ===="

if [ ! $APACHE_AREYOUSURE ]; then echo_green "Souhaitez vous installer le serveur apache ?"; read -p "(o)ui / (n)on ? " -n 1 -e APACHE_AREYOUSURE; fi
if [[ $APACHE_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Installation du serveur Apache en cours..."
  verbose apt-get -qq install apache2
  if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 80; fi
  verbose rm /var/www/html/index.html
  verbose touch /var/www/html/index.html
  verbose systemctl restart apache2
  echo_magenta "Le serveur Apache a été installé avec succès !"
fi
