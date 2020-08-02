#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

if [ ! $PHP_AREYOUSURE ]; then echo_green "Souhaitez vous installer PHP ?"; read -p "(o)ui / (n)on ? " -n 1 -e PHP_AREYOUSURE; fi
if [[ $PHP_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Installation de PHP en cours..."
  verbose apt-get -qq install php5 php5-mysql php5-mcrypt php5-imap php5-xmlrpc php5-curl
  echo_magenta "PHP a été installé avec succès !"

fi
