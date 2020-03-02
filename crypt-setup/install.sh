#!/bin/bash

if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then
  echo -e "\e[35mINSTALLATION DES PAQUETS REQUIS...\e[0m"
  apt-get -qq -y install keyboard-configuration
  apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  echo -e "\e[35mCREATION D'UNE CLE DE DECRYPTAGE...\e[0m"
  dd if=/dev/urandom of=/root/keyfile bs=1024 count=4 > /dev/null
  chmod 0400 /root/keyfile
  #cryptsetup luksAddKey /dev/sda2 /root/keyfile
  openssl genrsa -out /root/private.pem 2048
  openssl rsa -in /root/private.pem -outform PEM -pubout -out /root/public.pem
  openssl rsautl -encrypt -inkey /root/public.pem -pubin -in /root/keyfile -out /root/keyfile_encrypted
  sleep 0.5
  echo -e "\e[35mACTIVATION DU CRYPTAGE SUR LA PARTITION /dev/sda2...\e[0m"
  /sbin/cryptsetup --batch-mode luksFormat /dev/sda2 /root/keyfile
  sleep 0.5
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted -out /root/keyfile_decrypted
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2 --key-file /root/keyfile_decrypted
  sleep 0.5
  echo -e "\e[35mFORMATAGE DE LA PARTITION CRYPTEE EN EXT4...\e[0m"
  /sbin/mkfs.ext4 /dev/mapper/cryptsda2 > /dev/null
  sleep 0.5
  echo -e "\e[35mSAUVEGARDE DU HEADER...\e[0m"
  cryptsetup luksHeaderBackup /dev/sda1 --header-backup-file /root/headerbackup
  sleep 0.5
  echo -e "\e[35mMONTAGE DE LA PARTITION DANS /srv...\e[0m"
  mount /dev/mapper/cryptsda2 /srv
else
  echo -e "\e[31mOPERATION IMPOSSIBLE : AUCUNE PARTITION /dev/sda2 DETECTEE\e[0m"
fi
