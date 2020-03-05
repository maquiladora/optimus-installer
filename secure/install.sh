#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== MISE A JOUR DU SYSTEME ===="
if [ ! $SECURE_UPDATE ]; then echo_green "Voulez vous mettre à jour le système -> update/upgrade ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_UPDATE; fi
if [[ $SECURE_UPDATE =~ ^[YyOo]$ ]]
then
  echo_magenta "Téléchargement et installation des mises à jour..."
  verbose apt-get -qq update
  verbose apt-get -qq upgrade
  echo_magenta "Mises à jour effectuées avec succès !"
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
    echo_magenta "Nouveau mot de passe root : $newrootpass"
  else
    passwd root
  fi
fi

echo
if [ ! -d "/home/optimus" ]
then
  echo_green "==== CREATION DE L'UTILISATEUR OPTIMUS ===="
  if [ ! $SECURE_CREATEOPTIMUSUSER ]; then echo_green "Voulez vous créer l'utilisateur secondaire dénommé optimus ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_CREATEOPTIMUSUSER; fi
  if [[ $SECURE_CREATEOPTIMUSUSER =~ ^[YyOo]$ ]]
  then
    verbose adduser --disabled-login --gecos "" optimus
    if [ -f "/root/.google_authenticator" ]
    then
      verbose cp /root/.google_authenticator /home/optimus/.google_authenticator
    fi
    echo_magenta "L'utilisateur optimus a été créé avec succès !\e[0m"
  fi
fi

echo
if [ -d "/home/optimus" ]
then
  echo_green "==== MODIFICATION DU MOT DE PASSE DE L'UTILISATEUR OPTIMUS ===="
  if [ ! $SECURE_CHANGEOPTIMUSPASS ]; then echo_green "Voulez vous modifier le mot de passe root ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_CHANGEOPTIMUSPASS; fi
  if [[ $SECURE_CHANGEOPTIMUSPASS =~ ^[YyOo]$ ]]
  then
    if [ ! $SECURE_GENERATEOPTIMUSPASS ]; then echo_green "Voulez vous générer un mot de passe automatiquement ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_GENERATEOPTIMUSPASS; fi
    if [[ $SECURE_GENERATEOPTIMUSPASS =~ ^[YyOo]$ ]]
    then
      newoptimuspass=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
      echo -e "$newoptimuspass\n$newoptimuspass" | passwd optimus &> /dev/null
      echo_magenta "Nouveau mot de passe optimus : $newoptimuspass"
    else
      passwd optimus
    fi
  fi
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
echo_green "==== SERVEUR SSH ===="
if [ ! $SECURE_SSHREPLACEDEFAULTPORT ]; then echo_green "Voulez vous remplacer le port de connexion SSH par le port 7822 ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_SSHREPLACEDEFAULTPORT; fi
if [[ $SECURE_SSHREPLACEDEFAULTPORT =~ ^[YyOo]$ ]]
then
  verbose sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
  if [ $(which /sbin/ufw) ]
  then
     /sbin/ufw allow 7822
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
  if [ $(getent passwd optimus) ]
  then
    verbose sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    verbose systemctl restart ssh
    echo_magenta "L'accès SSH est désormais interdit à l'utilisateur root"
  else
    echo_red "L'accès SSH de l'utilisateur root ne peut pas être désactivé si l'utilisateur optimus n'existe pas"
  fi
else
  verbose sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
  verbose systemctl restart ssh
  echo_magenta "L'accès SSH est désormais autorisé pour l'utilisateur root"
fi


if [ ! $SECURE_ACTIVATEGOOGLEAUTH ]; then echo_green "Voulez vous protéger l'accès SSH avec GOOGLE AUTHENTICATOR ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_ACTIVATEGOOGLEAUTH; fi
if [[ $SECURE_ACTIVATEGOOGLEAUTH =~ ^[YyOo]$ ]]
then
  verbose apt-get -qq -y install libpam-google-authenticator
  if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd
  then
    verbose echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
  fi
  verbose sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  verbose systemctl restart sshd
  google-authenticator -t -f -d -w 3 -r 3 -R 30 -e 4
  if [ -d "/home/optimus" ]
  then
    verbose cp /root/.google_authenticator /home/optimus/.google_authenticator
  fi
  echo_magenta "L'accès SSH du serveur est désormais sécurisé par un code 2FA GOOGLE AUTHENTICATOR"
else
  verbose sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
  verbose systemctl restart sshd
  echo_magenta "L'accès SSH du serveur n'est désormais plus sécurisé par Google Authenticator"
fi

echo
echo_green "==== FAIL2BAN ===="
if [ ! $SECURE_INSTALLFAIL2BAN ]; then echo_green "Voulez vous protéger l\'accès SSH avec GOOGLE AUTHENTICATOR ?"; read -n 1 -p "(o)ui / (n)on ? " -e SECURE_INSTALLFAIL2BAN; fi
if [[ $SECURE_INSTALLFAIL2BAN =~ ^[YyOo]$ ]]
then
  verbose apt-get -qq install fail2ban
  echo_magenta "FAIL2BAN a été installé avec succès"
fi

echo
