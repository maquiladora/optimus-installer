#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo_green "==== ZONE DNS ===="

PUBLIC_IP=$(  wget -qO- ipinfo.io/ip )
LOCAL_IP=$( ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )

echo_magenta "Voici les enregistrements DNS à renseigner dans votre nom de domaine $DOMAIN :"
echo ""

sed -e 's/$domain/'$DOMAIN'/g' -e 's/$public_ip/'$PUBLIC_IP'/g' /srv/installer/dns/zone.conf
cat /etc/dkim/keys/$DOMAIN/mail.txt
echo ""


echo_magenta "Dans votre routeur, ces ports doivent être redirigés vers le serveur dont l'adresse locale est : $LOCAL_IP :"
echo ""
echo "22   SSH"
echo "80   HTTP"
echo "143  IMAP"
echo "443  HTTPS"
echo "465  SMTPS"
echo "587  SMTPS"
echo "993  IMAPS"
echo "3306 MYSQL"
