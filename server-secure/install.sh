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
    echo "Nouveau mot de passe root : $newrootpass"
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
      echo "Nouveau mot de passe utilisateur optimus : $newoptimuspass"
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
  if ! which ufw > /dev/null
  then
    if grep -q "Port 7822" /etc/ssh/sshd_config
    then
      ufw allow 7822
    else
      ufw allow 22
    fi
  fi
  ufw --force enable
else
  if ! which ufw > /dev/null
  then
    ufw --force disable
  fi
fi


echo
read -p $'\e[32mVoulez vous remplacer le port de connexion SSH par le port 7822 (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
  if ! which ufw > /dev/null
  then
    ufw allow 7822
    ufw deny 22
  fi
  systemctl restart ssh
else
  sed -i 's/Port 7822/#Port 22/g' /etc/ssh/sshd_config
  if ! which ufw > /dev/null
  then
    ufw deny 7822
    ufw allow 22
  fi
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
read -p $'\e[32mVoulez vous protéger l\'accès SSH avec GOOGLE AUTHENTICATOR (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq -y install libpam-google-authenticator
  if ! grep -q "auth required pam_google_authenticator.so" /etc/pam.d/sshd
  then
    echo 'auth required pam_google_authenticator.so' >> /etc/pam.d/sshd
  fi
  sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config
  systemctl restart sshd
  google-authenticator -t -f -d -w 3 -r 3 -R 30 -e 4
  if [ -d "/home/optimus" ]
  then
    cp /root/.google_authenticator /home/optimus/.google_authenticator
  fi
else
  sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
  systemctl restart sshd
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
