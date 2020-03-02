#!/bin/bash

echo
read -p $'\e[32mVoulez vous mettre à jour le système -> update/upgrade (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y update
  apt-get -y upgrade
fi

echo
read -p $'\e[32mVoulez vous modifier le mot de passe root (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  read -p $'\e[32mVoulez vous générer un mot de passe automatiquement (o/n) ? \e[0m' -n 1 -r
  echo
  if [[ $REPLY =~ ^[YyOo]$ ]]
  then
    newrootpass=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
    echo -e "$newrootpass\n$newrootpass" | passwd root &> /dev/null
    echo "Le nouveau mot de passe de l'utilisateur root est : $newrootpass"
  else
    passwd
  fi
fi


if [ ! -d "/home/optimus" ]
then
  echo
  read -p $'\e[32mVoulez vous créer un utilisateur secondaire dénommé optimus (o/n) ? \e[0m' -n 1 -r
  echo
  if [[ $REPLY =~ ^[YyOo]$ ]]
  then
    adduser --disabled-login --gecos "" optimus
    if [ -f "/root/.google_authenticator" ]
    then
      cp /root/.google_authenticator /home/optimus/.google_authenticator
    fi
  fi
fi


if [ -d "/home/optimus" ]
then
  echo
  read -p $'\e[32mVoulez vous modifier le mot de passe de l\'utilisateur optimus (o/n) ? \e[0m' -n 1 -r
  echo
  if [[ $REPLY =~ ^[YyOo]$ ]]
  then
    read -p $'\e[32mVoulez vous générer un mot de passe automatiquement (o/n) ? \e[0m' -n 1 -r
    echo
    if [[ $REPLY =~ ^[YyOo]$ ]]
    then
      newoptimuspass=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
      echo -e "$newoptimuspass\n$newoptimuspass" | passwd optimus &> /dev/null
      echo "Le nouveau mot de passe de l'utilisateur optimus est : $newoptimuspass"
    else
      passwd
    fi
  fi
fi


echo
read -p $'\e[32mVoulez vous activer le firewall (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y install ufw
  if grep -q "Port 7822" /etc/ssh/sshd_config
  then
    ufw allow 7822
  else
    ufw allow 22
  fi
  ufw --force enable
else
  ufw --force disable
fi


echo
read -p $'\e[32mVoulez vous remplacer le port de connexion SSH par le port 7822 (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
  ufw allow 7822
  ufw deny 22
  systemctl restart ssh
else
  sed -i 's/Port 7822/#Port 22/g' /etc/ssh/sshd_config
  ufw deny 7822
  ufw allow 22
  systemctl restart ssh
fi


echo
read -p $'\e[32mVoulez vous interdire l\'accès SSH à l\'utilisateur root (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  if [ $(getent passwd optimus) ]
  then
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    systemctl restart ssh
  else
    echo "L'accès SSH de l'utilisateur root ne peut pas être désactivé si l'utilisateur optimus n'a pas été créé préalablement"
  fi
else
  sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
  systemctl restart ssh
fi

echo
read -p $'\e[32mVoulez vous installer FAIL2BAN (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y install fail2ban
  fail2ban-client status
fi

echo
