#!/bin/bash

if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then
  echo -e "\e[35mINSTALLATION DES PAQUETS REQUIS...\e[0m"
  DEBIAN_FRONTEND=noninteractive apt-get -qq install keyboard-configuration &> /dev/null
  apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  apt-get -qq install curl
  echo -e "\e[35mCREATION D'UNE CLE DE CHIFFREMENT...\e[0m"
  mkdir /root/tmpramfs
  mount ramfs /root/tmpramfs/ -t ramfs
  </dev/urandom tr -dc A-Za-z0-9 | head -c${1:-256} > /root/tmpramfs/keyfile
  chmod 0400 /root/tmpramfs/keyfile
  openssl genrsa -out /root/private.pem 4096 &> /dev/null
  openssl rsa -in /root/private.pem -outform PEM -pubout -out /root/tmpramfs/public.pem &> /dev/null
  openssl rsautl -encrypt -inkey /root/tmpramfs/public.pem -pubin -in /root/tmpramfs/keyfile -out /root/tmpramfs/keyfile_encrypted &> /dev/null
  sleep 0.5
  echo -e "\e[35mENVOI DE LA CLE DE CHIFFREMENT SUR LE SERVEUR DISTANT\e[0m"
  curl -X POST -F "$(</root/uid)=@/root/tmpramfs/keyfile_encrypted" https://installer.optimus-avocats.fr/autodecryptor/index.php
  echo -e "\e[35mACTIVATION DU CHIFFREMENT SUR LA PARTITION /dev/sda2...\e[0m"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup --batch-mode luksFormat /dev/sda2
  sleep 0.5
  echo -e "\e[35mOUVERTURE DE LA PARTITION CHIFFREE...\e[0m"
  UUID=$(</root/uid)
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
  sleep 0.5
  echo -e "\e[35mFORMATAGE DE LA PARTITION CHIFFREE EN EXT4...\e[0m"
  /sbin/mkfs.ext4 /dev/mapper/cryptsda2 &> /dev/null
  sleep 0.5
  echo -e "\e[35mSAUVEGARDE DU HEADER...\e[0m"
  cryptsetup luksHeaderBackup /dev/sda2 --header-backup-file /root/headerbackup
  sleep 0.5
  echo -e "\e[35mMONTAGE DE LA PARTITION DANS /srv...\e[0m"
  mount /dev/mapper/cryptsda2 /srv
  umount /root/tmpramfs
  rmdir /root/tmpramfs
else
  echo -e "\e[31mOPERATION IMPOSSIBLE : AUCUNE PARTITION /dev/sda2 DETECTEE\e[0m"
fi
