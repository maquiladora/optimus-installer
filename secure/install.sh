#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_SECURE_UPDATE ]; then require MODULE_SECURE_UPDATE yesno "Voulez vous mettre à jour le système -> update/upgrade ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_ENABLEFW ]; then require MODULE_SECURE_ENABLEFW yesno "Voulez vous installer le pare-feu UFW ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_FAIL2BAN ]; then require MODULE_SECURE_FAIL2BAN yesno "Voulez vous installer FAIL2BAN ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_CHANGEROOTPASS ]; then require MODULE_SECURE_CHANGEROOTPASS yesno "Voulez vous modifier le mot de passe root ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_CHANGEDEBIANPASS ]; then require MODULE_SECURE_CHANGEDEBIANPASS yesno "Voulez vous modifier le mot de passe de l'utilisateur 'debian' ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_SSH_REPLACEDEFAULTPORT ]; then require MODULE_SECURE_SSH_REPLACEDEFAULTPORT yesno "Voulez vous remplacer le port de connexion SSH par le port 7822 ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_SSH_DISABLEROOTACCESS ]; then require MODULE_SECURE_SSH_DISABLEROOTACCESS yesno "Voulez vous interdire l'accès SSH à l'utilisateur root ?"; source /root/.allspark; fi
if [ -z $MODULE_SECURE_SSH_2FA ]; then require MODULE_SECURE_SSH_2FA yesno "Voulez vous protéger l'accès SSH avec une authentification 2 à deux facteurs (authenticator) ?"; source /root/.allspark; fi
source /root/.allspark


if [ $MODULE_SECURE_UPDATE = "Y" ]
then
  echo
  echo_green "==== MISE A JOUR DU SYSTEME ===="
  echo_magenta "Téléchargement et installation des mises à jour"
  apt-get -qq update
  apt-get -qq upgrade
fi

if [ $MODULE_SECURE_ENABLEFW = "Y" ]
then
  echo
  echo_green "==== PARE FEU ===="
  echo_magenta "Installation des paquets requis"
  verbose apt-get -qq install ufw
  echo_magenta "Ouverture du port SSH"
  if grep -q "Port 7822" /etc/ssh/sshd_config
  then
    verbose /sbin/ufw allow 7822
  else
    verbose /sbin/ufw allow 22
  fi
  echo_magenta "Activation du pare feu"
  verbose /sbin/ufw --force enable
else
  echo
  echo_green "==== PARE FEU ===="
  if [ $(which /sbin/ufw) ]
  then
    echo_magenta "Désactivation du firewall"
    verbose /sbin/ufw --force disable
  fi
fi

if [ $MODULE_SECURE_FAIL2BAN = "Y" ]
then
  echo
  echo_green "==== FAIL2BAN ===="
  echo_magenta "Installation des paquets requis"
  verbose apt-get -qq install fail2ban
  echo_magenta "Installation des prisons locales"
  cp /etc/allspark/secure/jail.local /etc/fail2ban/jail.local
  #commit suggéré sur fail2ban mais pas encore implémenté
  sed -i '/mdpr-ddos = lost connection after(?! DATA)/c\mdpr-ddos = (?:lost connection after(?! DATA) [A-Z]+|disconnect(?= from \S+(?: \S+=\d+)* auth=0/(?:[1-9]|\d\d+)))' /etc/fail2ban/filter.d/postfix.conf
  echo_magenta "Redémarrage des services"
  systemctl restart fail2ban
else
  echo
  echo_green "==== FAIL2BAN ===="
  echo_magenta "Désinstallation des paquets"
  verbose apt-get -qq remove fail2ban
fi

if [ $MODULE_SECURE_CHANGEROOTPASS = "Y" ]
then
  echo
  echo_green "==== MODIFICATION DU MOT DE PASSE ROOT ===="
  echo_magenta "Modification du mot de passe root"
  require SECURE_ROOT_PASSWORD password "Veuillez renseigner le nouveau mot de passe root :"
  source /root/.allspark
  echo -e "$SECURE_ROOT_PASSWORD\n$SECURE_ROOT_PASSWORD" | passwd root &> /dev/null
fi

if [ $MODULE_SECURE_CHANGEDEBIANPASS = "Y" ]
then
  echo
  echo_green "==== MODIFICATION DU MOT DE PASSE DE L'UTILISATEUR DEBIAN ===="
  echo_magenta "Modification du mot de passe de l'utilisateur 'debian'"
  require SECURE_DEBIAN_PASSWORD password "Veuillez renseigner le nouveau mot de passe pour l'utilisateur 'debian':"
  source /root/.allspark
  echo -e "$SECURE_DEBIAN_PASSWORD\n$SECURE_DEBIAN_PASSWORD" | passwd debian &> /dev/null
fi


if [ $MODULE_SECURE_SSH_REPLACEDEFAULTPORT = "Y" ]
then
  echo
  echo_green "==== PORT DU SERVEUR SSH ===="
  echo_magenta "Remplacement du port 22 par le port 7822"
  verbose sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
  echo_magenta "Ouverture du port 7822 et fermeture du port 22"
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw allow 7822
    verbose /sbin/ufw deny 22
  fi
  echo_magenta "Redémarrage des services"
  verbose systemctl restart ssh
else
  echo
  echo_green "==== PORT DU SERVEUR SSH ===="
  echo_magenta "Remplacement du port 7822 par le port 22"
  verbose sed -i 's/Port 7822/#Port 22/g' /etc/ssh/sshd_config
  echo_magenta "Ouverture du port 22 et fermeture du port 7822"
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw deny 7822
    verbose /sbin/ufw allow 22
  fi
  echo_magenta "Redémarrage des services"
  verbose systemctl restart ssh
fi

if [ $MODULE_SECURE_SSH_DISABLEROOTACCESS = "Y" ]
then
  echo
  echo_green "==== ACCESS SSH DE L'UTILISATEUR ROOT ===="
  if [ $(getent passwd debian) ]
  then
    echo_magenta "Désactivation de l'accès SSH de l'utilisateur root"
    verbose sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    verbose sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
    echo_magenta "Redémarrage des services"
    verbose systemctl restart ssh
  else
    echo_red "L'accès SSH de l'utilisateur root ne peut pas être désactivé si l'utilisateur debian n'existe pas"
  fi
else
  echo_magenta "Résactivation de l'accès SSH de l'utilisateur root"
  verbose sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
  verbose sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
  echo_magenta "Redémarrage des services"
  verbose systemctl restart ssh
fi


if [ $MODULE_SECURE_SSH_2FA = "Y" ]
then
  echo
  echo_green "==== SECURISATION DE L'ACCESS SSH AVEC UN CODE A DEUX FACTEURS ===="

  if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez indiquer votre nom de domaine :"; source /root/.allspark; fi

  echo_magenta "Installation des paquets requis"
  verbose apt-get -qq -y install libpam-google-authenticator qrencode ntp

  echo_magenta "Activation de l'authentification à deux facteurs"
  if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd
  then
    echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
  fi
  verbose sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config

  verbose sed -i 's/@include common-auth/#@include common-auth/g' /etc/pam.d/sshd

  if ! grep -q "Match User debian/nAuthenticationMethods publickey,keyboard-interactive password,keyboard-interactive" /etc/ssh/sshd_config
  then
    echo 'Match User debian/nAuthenticationMethods publickey,keyboard-interactive' >> /etc/ssh/sshd_config
  fi

  echo_magenta "Génération des clés d'accès"
  google-authenticator --time-based --force --quiet --disallow-reuse --window-size=3 --rate-limit=3 --rate-time=30 --emergency-codes=4 --label=debian@$DOMAIN --issuer=ALLSPARK
  update_conf SECURE_GOOGLEAUTH_KEY $(cat /root/.google_authenticator | head -1)

  echo_magenta "Copie des codes d'accès dans les paramètres de l'utilisateur 'debian'"
  if [ -d "/home/debian" ]
  then
    verbose cp /root/.google_authenticator /home/debian/.google_authenticator
    verbose chown debian:debian /home/debian/.google_authenticator
  fi

  echo_magenta "Redémarrage des services"
  verbose systemctl restart sshd

else

  echo
  echo_green "==== SECURISATION DE L'ACCESS SSH AVEC UN CODE A DEUX FACTEURS ===="
  echo_magenta "Désactivation de l'authentification à deux facteurs"
  verbose sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
  verbose sed -i 's/#@include common-auth/@include common-auth/g' /etc/pam.d/sshd
  verbose rm /root/.google_authenticator
  verbose rm /home/debian/.google_authenticator
  echo_magenta "Redémarrage des services"
  verbose systemctl restart sshd

fi


if [ ! -f /root/.google_authenticator ]
then
  echo_magenta "L'accès SSH est sécurisé par le code 2FA GOOGLE AUTHENTICATOR suivant :"
  qrencode -t ansi "otpauth://totp/debian@demoptimus.fr?secret=$(cat /root/.google_authenticator | head -1)&issuer=ALLSPARK"
fi
