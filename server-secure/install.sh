#!/bin/bash

read -p "Voulez vous modifier le mot de passe root ? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    passwd
fi

read -p "Voulez vous modifier le port de connexion SSH par défaut ? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "hopla"
fi

read -p "Press [Enter] to exit"
