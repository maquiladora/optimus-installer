#!/bin/bash
source /etc/allspark/functions.sh
require DOMAIN
source /root/.allspark

echo
echo_green "==== ZONE DNS ===="
echo

PUBLIC_IP=$( wget -qO- ipinfo.io/ip )
LOCAL_IP=$( /sbin/ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' )

echo_magenta "Voici les enregistrements DNS à renseigner dans votre nom de domaine $DOMAIN :"
echo

echo "@ 10800 IN A $PUBLIC_IP"
echo "api 10800 IN A $PUBLIC_IP"
echo "cloud 10800 IN A $PUBLIC_IP"
echo "mail 10800 IN A $PUBLIC_IP"
echo "optimus 10800 IN A $PUBLIC_IP"
echo "webmail 10800 IN A $PUBLIC_IP"
echo "www 10800 IN A $PUBLIC_IP"
echo "@ 10800 IN MX 50 mail.$DOMAIN."
echo '@ 10800 IN TXT "v=spf1 mx ~all"'
echo '_dmarc TXT v=DMARC1;p=quarantine;sp=quarantine;pct=100;adkim=r;aspf=r;fo=1;ri=86400;rua=mailto:postmaster@'$DOMAIN';ruf=mailto:postmaster@'$DOMAIN';rf=afrf'

sed -e 's/IN/10800 IN/g' -e ':a;N;$!ba;s/\n/\ /g' -e 's/\t/ /g' /etc/dkim/keys/$DOMAIN/mail.txt

echo
echo_magenta "Pensez à renseigner le reverse DNS de votre serveur : $DOMAIN"

echo
echo_magenta "Dans votre routeur, ces ports doivent être redirigés vers le serveur dont l'adresse locale est : $LOCAL_IP :"
echo ""
if grep -q "Port 7822" /etc/ssh/sshd_config
then
  echo "7822 SSH"
else
  echo "22   SSH"
fi
echo "80   HTTP"
echo "25   SMTP"
echo "143  IMAP"
if [ -d /etc/letsencrypt ]; then echo "443  HTTPS"; fi
echo "465  SMTPS"
echo "587  SMTPS"
echo "993  IMAPS"
echo "3306 MYSQL"


echo
