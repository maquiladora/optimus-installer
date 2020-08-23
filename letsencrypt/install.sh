#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_LETSENCRYPT ]; then require MODULE_LETSENCRYPT yesno "Voulez-vous générer des certificats SSL pour sécuriser les communications ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_LETSENCRYPT = "Y" ]
then

  echo
  echo_green "==== INSTALLATION DES CERTIFICATS SSL LETSENCRYPT ===="

  if [ ! -f /etc/letsencrypt/live/demoptimus.fr/fullchain.pem ]
  then

      echo_magenta "Installation des paquets requis"
      verbose apt-get -qq -y install letsencrypt python-certbot-apache

      echo_magenta "Installation des certificats pour les sous domaines web"
      if [ -d "/srv/www" ]; then DOMAINS_TO_INSTALL="-d $DOMAIN -d www.$DOMAIN"; fi
      if [ -d "/srv/cloud" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d cloud.$DOMAIN"; fi
      if [ -d "/srv/webmail" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d webmail.$DOMAIN"; fi
      if [ -d "/srv/api" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d api.$DOMAIN"; fi
      if [ -d "/srv/optimus" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d optimus.$DOMAIN"; fi
      if [ -d "/srv/shared" ]; then DOMAINS_TO_INSTALL="${DOMAINS_TO_INSTALL} -d partage.$DOMAIN"; fi
      certbot run -n --apache --redirect --agree-tos --email prime@$DOMAIN $DOMAINS_TO_INSTALL

      if [ -d "/srv/mailboxes" ]
      then
        echo_magenta "Extension du certificat pour le serveur mail.$DOMAIN"
        verbose systemctl stop apache2
        certbot certonly -n --standalone --agree-tos --email prime@$DOMAIN --expand $DOMAINS_TO_INSTALL -d mail.$DOMAIN
      fi

      echo_magenta "Ouverture du port 443 dans le firewall"
      if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 443; fi

      echo_magenta "Redémarrage des services"
      verbose systemctl restart apache2
      verbose systemctl restart postfix
      verbose systemctl restart dovecot
      verbose systemctl restart opendkim

  else
    echo_magenta "Les certificats SSL ont déjà été générés !"
  fi

fi
