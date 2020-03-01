#!/bin/bash

read -p "\nVoulez vous modifier le mot de passe root ? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    passwd
fi

read -p "\nVoulez vous modifier le port de connexion SSH par défaut ? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "hopla"
fi
