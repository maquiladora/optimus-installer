#!/bin/bash

echo
read -p "Voulez vous mettre à jour le système ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y update
  apt-get -qq -y upgrade
fi

echo
read -p "Voulez vous modifier le mot de passe root ? " -n 1 -r
echo
echo "suggestion sécurisée : "
< /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32};echo;
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
    passwd
fi

echo
read -p "Voulez vous remplacer le port de connexion SSH par le port 7822 ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
    sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
    systemctl restart ssh
fi

if [ ! -d "/home/optimus" ]
then
  echo
  read -p "Voulez vous créer un utilisateur secondaire dénommé optimus ? " -n 1 -r
  echo
  echo "suggestion sécurisée : "
  < /dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32};echo;
  echo
  if [[ $REPLY =~ ^[YyOo]$ ]]
  then
      adduser optimus
      if [ -f "/root/.google_authenticator" ]
      then
        cp /root/.google_authenticator /home/optimus/.google_authenticator
      fi
  fi
fi

echo
read -p "Voulez vous interdire l'accès SSH à l'utilisateur root ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  if [ $(getent passwd optimus) ]
  then
    sed -i 's/PermitRootLogin yes/PermitRootLogin yes no/g' /etc/ssh/sshd_config
    systemctl restart ssh
  else
    echo "L'accès SSH de l'utilisateur root ne peut pas être désactivé si l'utilisateur optimus n'a pas été créé préalablement"
  fi
fi

echo
read -p "Voulez vous installer FAIL2BAN ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y install fail2ban
  fail2ban-client status
fi

echo
read -p "Voulez vous activer le firewall ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y install ufw
  ufw allow 22
  ufw enable
fi

echo
