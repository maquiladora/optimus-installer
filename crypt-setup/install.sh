#!/bin/bash

if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then
  echo_green "==== CHIFFREMENT DU DISQUE ===="
  echo_magenta "Installation des paquets requis..."
  DEBIAN_FRONTEND=noninteractive apt-get -qq install keyboard-configuration &> /dev/null
  apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  apt-get -qq install curl
  echo_magenta "Création d'une clé de chiffrement..."
  mkdir /root/tmpramfs
  mount ramfs /root/tmpramfs/ -t ramfs
  </dev/urandom tr -dc A-Za-z0-9 | head -c${1:-256} > /root/tmpramfs/keyfile
  chmod 0400 /root/tmpramfs/keyfile
  openssl genrsa -out /root/private.pem 4096 &> /dev/null
  openssl rsa -in /root/private.pem -outform PEM -pubout -out /root/tmpramfs/public.pem &> /dev/null
  openssl rsautl -encrypt -inkey /root/tmpramfs/public.pem -pubin -in /root/tmpramfs/keyfile -out /root/tmpramfs/keyfile_encrypted &> /dev/null
  sleep 0.5
  echo_magenta "Envoi de la clé de chiffrement sur le serveur distant"
  curl -X POST -F "$(</root/uid)=@/root/tmpramfs/keyfile_encrypted" https://decrypt.optimus-avocats.fr/autodecryptor/index.php
  echo_magenta "Activation du chiffrement sur la partition"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup --batch-mode luksFormat /dev/sda2
  sleep 0.5
  echo_magenta "Ouverture de la partition chiffrée"
  UUID=$(</root/uid)
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
  sleep 0.5
  echo_magenta "Formattage de la partition chiffrée au format EXT4"
  /sbin/mkfs.ext4 /dev/mapper/cryptsda2 &> /dev/null
  sleep 0.5
  echo_magenta "Sauvegarde du header"
  cryptsetup luksHeaderBackup /dev/sda2 --header-backup-file /root/headerbackup
  sleep 0.5
  echo_magenta "Montage de la partition dans /srv"
  mount /dev/mapper/cryptsda2 /srv
  umount /root/tmpramfs
  rmdir /root/tmpramfs
else
  echo_red "Opération impossible : la partition /dev/sda2 n'existe pas"
fi
