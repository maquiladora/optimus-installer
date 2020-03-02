#!/bin/bash

if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then
  echo -e "\e[35mINSTALLATION DES PAQUETS REQUIS...\e[0m"
  apt-get -qq install keyboard-configuration > /dev/null
  apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  echo -e "\e[35mACTIVATION DU CRYPTAGE SUR LA PARTITION /dev/sda2...\e[0m"
  /sbin/cryptsetup --batch-mode luksFormat /dev/sda2
  sleep 0.5
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
  sleep 0.5
  echo -e "\e[35mFORMATAGE DE LA PARTITION CRYPTEE EN EXT4...\e[0m"
  /sbin/mkfs.ext4 /dev/mapper/cryptsda2
  sleep 0.5
  echo -e "\e[35mMONTAGE DE LA PARTITION DANS /srv...\e[0m"
  mount /dev/mapper/cryptsda2 /srv
else
  echo -e "\e[31mOPERATION IMPOSSIBLE : AUCUNE PARTITION /dev/sda2 DETECTEE\e[0m"
fi
