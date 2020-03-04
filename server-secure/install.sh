#!/bin/bash

echo
read -p $'\e[32mVoulez vous mettre à jour le système -> update/upgrade (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  echo -e "\e[35mTELECHARGEMENT ET INSTALLATION DES MISES A JOUR...\e[0m"
  apt-get -qq update &> /dev/null
  apt-get -qq upgrade &> /dev/null
  echo -e "\e[35mMISES A JOUR EFFECTUEES AVEC SUCCES...\e[0m"
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
    echo -e "\e[35mNOUVEAU MOT DE PASSE ROOT\e[0m \e[33m: $newrootpass\e[0m"
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
    adduser --disabled-login --gecos "" optimus &> /dev/null
    if [ -f "/root/.google_authenticator" ]
    then
      cp /root/.google_authenticator /home/optimus/.google_authenticator
    fi
    echo -e "\e[35mUTILISATEUR optimus CREE AVEC SUCCES...\e[0m"
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
      echo -e "\e[35mNOUVEAU MOT DE PASSE UTILISATEUR OPTIMUS\e[0m \e[33m: $newoptimuspass\e[0m"
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
  apt-get -qq install ufw &> /dev/null
  if grep -q "Port 7822" /etc/ssh/sshd_config
  then
    /sbin/ufw allow 7822 &> /dev/null
  else
    /sbin/ufw allow 22 &> /dev/null
  fi
  /sbin/ufw --force enable &> /dev/null
  echo -e "\e[35mLE FIREWALL A ETE ACTIVE AVEC SUCCES...\e[0m"
else
  if which /sbin/ufw > /dev/null
  then
    /sbin/ufw --force disable &> /dev/null
    echo -e "\e[35mLE FIREWALL A ETE DESACTIVE...\e[0m"
  fi
fi


echo
read -p $'\e[32mVoulez vous remplacer le port de connexion SSH par le port 7822 (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  sed -i 's/#Port 22/Port 7822/g' /etc/ssh/sshd_config
  if which /sbin/ufw > /dev/null
  then
    /sbin/ufw allow 7822 &> /dev/null
    /sbin/ufw deny 22 &> /dev/null
  fi
  systemctl restart ssh
  echo -e "\e[35mLE SERVEUR SSH ECOUTE DESORMAIS LE PORT 7822\e[0m"
else
  sed -i 's/Port 7822/#Port 22/g' /etc/ssh/sshd_config
  if which /sbin/ufw > /dev/null
  then
    /sbin/ufw deny 7822 &> /dev/null
    /sbin/ufw allow 22 &> /dev/null
    echo -e "\e[35mLE SERVEUR SSH ECOUTE DESORMAIS LE PORT PAR DEFAUT 22\e[0m"
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
    echo -e "\e[35mL'UTILISATEUR ROOT NE PEUT PLUS SE CONNECTER AU SERVEUR SSH\e[0m"
  else
    echo -e "\e[31mL'ACCES SSH DE L'UTILISATEUR ROOT NE PEUT PAS ETRE DESACTIVE SI L'UTILISATEUR OPTIMUS N'A PAS ETE CREE PREALABLEMENT\e[0m"
  fi
else
  sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
  systemctl restart ssh
  echo -e "\e[35mL'UTILISATEUR ROOT EST AUTORISE A SE CONNECTER AU SERVEUR SSH\e[0m"
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
  echo -e "\e[35mL'ACCES AU SERVEUR SSH A ETE SECURISE PAR UN CODE GOOGLE AUTHENTICATOR\e[0m"
else
  sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
  systemctl restart sshd
  echo -e "\e[35mGOOGLE AUTHENTICATOR A ETE DESACTIVE SUR LE SERVEUR SSH\e[0m"
fi


echo
read -p $'\e[32mVoulez vous installer FAIL2BAN (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  apt-get -qq install fail2ban &> /dev/null
  echo -e "\e[35mFAIL2BAN A ETE INSTALLE AVEC SUCCES\e[0m"
fi

echo
