#!/bin/bash
source /installer/functions.sh

echo
echo_green "==== INSTALLATION DE PHP ===="

if [ ! $PHP_AREYOUSURE ]; then echo_green "Souhaitez vous installer PHP ?"; read -p "(o)ui / (n)on ? " -n 1 -e PHP_AREYOUSURE; fi
if [[ $PHP_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Installation de PHP en cours..."
  verbose apt-get -qq install php php-mysql php-imap php-xmlrpc php-curl php-zip php-xml php-mbstring php-gd php-pear

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
