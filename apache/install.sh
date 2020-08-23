#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_APACHE ]; then require MODULE_APACHE yesno "Souhaitez vous installer le serveur web apache ?"; source /root/.allspark; fi
source /root/.allspark

if [[ $MODULE_APACHE =~ ^[YyOo]$ ]]
then
  echo
  echo_green "==== INSTALLATION DU SERVEUR WEB APACHE ===="

  echo_magenta "Installation des paquets"
  verbose apt-get -qq install apache2

  echo_magenta "Activation du module rewrite"
  verbose a2enmod rewrite

  echo_magenta "Ouverture du port 80 sur le firewall"
  if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 80; fi

  echo_magenta "Configuration de l'hébergement par défaut"
  verbose rm /var/www/html/index.html
  verbose touch /var/www/html/index.html

  echo_magenta "Redémarrage des services"
  verbose systemctl restart apache2
fi
