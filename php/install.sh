#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_PHP ]; then require MODULE_PHP yesno "Voulez-vous installer PHP ?"; source /root/.allspark; fi
source /root/.allspark

if [[ $MODULE_PHP =~ ^[YyOo]$ ]]
then

  echo
  echo_green "==== INSTALLATION DE PHP ===="

  echo_magenta "Installation de PHP en cours..."
  verbose apt-get -qq install php php-mysql php-imap php-xmlrpc php-curl php-zip php-xml php-mbstring php-gd php-pear

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
