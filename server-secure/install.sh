#!/bin/bash

echo
read -p "Voulez vous modifier le mot de passe root ? " -n 1 -r
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
    service sshd restart
fi

echo
read -p "Voulez vous créer un utilisateur secondaire dénommé optimus ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
    adduser optimus
fi

echo
read -p "Voulez vous interdire l'accès SSH à l'utilisateur root ? " -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  if [ $(getent passwd optimus) ]
  then
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
    service sshd restart
  else
    echo "L'accès SSD de l'utilisateur root ne peut pas être désactivé si l'utilisateur optimus n'a pas été créé"
  fi
fi

echo
