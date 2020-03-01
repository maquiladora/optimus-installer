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
    echo "hopla"
    sed -i 's/Port 22/Port 7822/g' /etc/ssh/sshd_config
    service sshd restart
fi

echo
