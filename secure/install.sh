#!/bin/bash
source /etc/allspark/functions.sh
require DOMAIN
source /root/.allspark

echo $DOMAIN > /etc/hostname; fi

echo_green "==== MISE A JOUR DU SYSTEME ===="
if [ ! $SECURE_UPDATE ]; then echo_green "Voulez vous mettre à jour le système -> update/upgrade ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_UPDATE; fi
if [[ $SECURE_UPDATE =~ ^[YyOo]$ ]]
then
  echo_magenta "Téléchargement et installation des mises à jour..."
  apt-get -qq update
  apt-get -qq upgrade
  echo_magenta "Mises à jour effectuées avec succès !"
fi

echo
echo_green "==== FIREWALL ===="
if [ ! $SECURE_ENABLEFW ]; then echo_green "Voulez vous activer le firewall ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_ENABLEFW; fi
if [[ $SECURE_ENABLEFW =~ ^[YyOo]$ ]]
then
  verbose apt-get -qq install ufw
  if grep -q "Port 7822" /etc/ssh/sshd_config
  then
    verbose /sbin/ufw allow 7822
  else
    verbose /sbin/ufw allow 22
  fi
  verbose /sbin/ufw --force enable
  echo_magenta "Le Firewall a été activé avec succès !"
else
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw --force disable
    echo_magenta "Le Firewall a été désactivé"
  fi
fi

echo
echo_green "==== FAIL2BAN ===="
if [ ! $SECURE_INSTALLFAIL2BAN ]; then echo_green "Voulez vous installer FAIL2BAN ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_INSTALLFAIL2BAN; fi
if [[ $SECURE_INSTALLFAIL2BAN =~ ^[YyOo]$ ]]
then
  verbose apt-get -qq install fail2ban
  echo_magenta "FAIL2BAN a été installé avec succès"
else
  verbose apt-get -qq remove fail2ban
  echo_magenta "FAIL2BAN a été desinstallé avec succès"
fi

echo
echo_green "==== MODIFICATION DU MOT DE PASSE ROOT ===="
if [ ! $SECURE_CHANGEROOTPASS ]; then echo_green "Voulez vous modifier le mot de passe root ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_CHANGEROOTPASS; fi
if [[ $SECURE_CHANGEROOTPASS =~ ^[YyOo]$ ]]
then
  if [ ! $SECURE_GENERATEROOTPASS ]; then echo_green "Voulez vous générer un mot de passe automatiquement ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_GENERATEROOTPASS; fi
  if [[ $SECURE_GENERATEROOTPASS =~ ^[YyOo]$ ]]
  then
    newrootpass=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
    echo -e "$newrootpass\n$newrootpass" | passwd root &> /dev/null
    echo_magenta "Nouveau mot de passe root : "
    echo_cyan $newrootpass
  else
    passwd root
  fi
fi

echo
echo_green "==== MODIFICATION DU MOT DE PASSE DE L'UTILISATEUR DEBIAN ===="
if [ ! $SECURE_CHANGEDEBIANPASS ]; then echo_green "Voulez vous modifier le mot de passe de l'utilisateur DEBIAN ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_CHANGEDEBIANPASS; fi
if [[ $SECURE_CHANGEDEBIANPASS =~ ^[YyOo]$ ]]
then
  if [ ! $SECURE_GENERATEDEBIANPASS ]; then echo_green "Voulez vous générer un mot de passe automatiquement ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_GENERATEDEBIANPASS; fi
  if [[ $SECURE_GENERATEDEBIANPASS =~ ^[YyOo]$ ]]
  then
    newdebianpass=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
    echo -e "$newdebianpass\n$newdebianpass" | passwd debian &> /dev/null
    echo_magenta "Nouveau mot de passe de l'utilisateur DEBIAN : ";
    echo_cyan $newdebianpass
  else
    passwd debian
  fi
fi


echo
echo_green "==== SERVEUR SSH ===="
if [ ! $SECURE_SSHREPLACEDEFAULTPORT ]; then echo_green "Voulez vous remplacer le port de connexion SSH par le port 7822 ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_SSHREPLACEDEFAULTPORT; fi
if [[ $SECURE_SSHREPLACEDEFAULTPORT =~ ^[YyOo]$ ]]
then
  verbose sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw allow 7822
    verbose /sbin/ufw deny 22
  fi
  verbose systemctl restart ssh
  echo_magenta "Le serveur SSH écoute désormais sur le port 7822"
else
  verbose sed -i 's/Port 7822/#Port 22/g' /etc/ssh/sshd_config
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw deny 7822
    verbose /sbin/ufw allow 22
    echo_magenta "Le serveur SSH écoute désormais sur le port par défaut 22"
  fi
  verbose systemctl restart ssh
fi


if [ ! $SECURE_SSHDISABLEROOTACCESS ]; then echo_green "Voulez vous interdire l'accès SSH à l'utilisateur root ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_SSHDISABLEROOTACCESS; fi
if [[ $SECURE_SSHDISABLEROOTACCESS =~ ^[YyOo]$ ]]
then
  if [ $(getent passwd debian) ]
  then
    verbose sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    verbose sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
    verbose systemctl restart ssh
    echo_magenta "L'accès SSH est désormais interdit à l'utilisateur root"
  else
    echo_red "L'accès SSH de l'utilisateur root ne peut pas être désactivé si l'utilisateur debian n'existe pas"
  fi
else
  verbose sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
  verbose sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
  verbose systemctl restart ssh
  echo_magenta "L'accès SSH est désormais autorisé pour l'utilisateur root"
fi


if [ ! $SECURE_ACTIVATEGOOGLEAUTH ]; then echo_green "Voulez vous protéger l'accès SSH avec GOOGLE AUTHENTICATOR ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_ACTIVATEGOOGLEAUTH; fi
if [[ $SECURE_ACTIVATEGOOGLEAUTH =~ ^[YyOo]$ ]]
then

  verbose apt-get -qq -y install libpam-google-authenticator

  if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd
  then
    echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
  fi
  verbose sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config

  verbose sed -i 's/@include common-auth/#@include common-auth/g' /etc/pam.d/sshd

  if ! grep -q "AuthenticationMethods  publickey,keyboard-interactive" /etc/ssh/sshd_config
  then
    echo 'AuthenticationMethods  publickey,keyboard-interactive' >> /etc/ssh/sshd_config
  fi

  google-authenticator -t -f -d -w 3 -r 3 -R 30 -e 4

  if [ -d "/home/debian" ]
  then
    verbose cp /root/.google_authenticator /home/debian/.google_authenticator
    verbose chown debian:debian /home/debian/.google_authenticator
  fi

  verbose systemctl restart sshd
  echo_magenta "L'accès SSH du serveur est désormais sécurisé par un code 2FA GOOGLE AUTHENTICATOR"

else
  verbose sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
  verbose sed -i 's/#@include common-auth/@include common-auth/g' /etc/pam.d/sshd
  verbose systemctl restart sshd
  echo_magenta "L'accès SSH du serveur n'est désormais plus sécurisé par Google Authenticator"
fi

echo
