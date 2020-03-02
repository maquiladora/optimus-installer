#!/bin/bash

if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then
  echo -e "\e[35mINSTALLATION DES PAQUETS REQUIS...\e[0m"
  DEBIAN_FRONTEND=noninteractive apt-get -qq install keyboard-configuration
  apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  echo -e "\e[35mCREATION D'UNE CLE DE DECRYPTAGE...\e[0m"
  mkdir /root/tmpramfs
  mount ramfs /root/tmpramfs/ -t ramfs
  head -c 256 < /dev/urandom > /root/tmpramfs/keyfile
  chmod 0400 /root/tmpramfs/keyfile
  openssl genrsa -out /root/private.pem 4096 &> /dev/null
  openssl rsa -in /root/private.pem -outform PEM -pubout -out /root/tmpramfs/public.pem &> /dev/null
  openssl rsautl -encrypt -inkey /root/tmpramfs/public.pem -pubin -in /root/tmpramfs/keyfile -out /root/keyfile_encrypted &> /dev/null
  umount /root/tmpramfs
  rmdir /root/tmpramfs
  sleep 0.5
  echo -e "\e[35mACTIVATION DU CRYPTAGE SUR LA PARTITION /dev/sda2...\e[0m"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup --batch-mode luksFormat /dev/sda2
  sleep 0.5
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
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
