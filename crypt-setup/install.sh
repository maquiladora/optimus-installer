#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

if lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then

  echo_green "==== CHIFFREMENT DU DISQUE ===="

  echo_magenta "Installation des paquets requis..."
  DEBIAN_FRONTEND=noninteractive apt-get -qq install keyboard-configuration &> /dev/null
  verbose apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  verbose apt-get -qq install curl

  echo_magenta "Création d'une clé de chiffrement..."
  mkdir ~/tmpramfs
  mount ramfs ~/tmpramfs/ -t ramfs
  </dev/urandom tr -dc A-Za-z0-9 | head -c${1:-256} > ~/tmpramfs/keyfile
  chmod 0400 ~/tmpramfs/keyfile
  openssl genrsa -out ~/private.pem 4096 &> /dev/null
  openssl rsa -in ~/private.pem -outform PEM -pubout -out ~/tmpramfs/public.pem &> /dev/null
  openssl rsautl -encrypt -inkey ~/tmpramfs/public.pem -pubin -in ~/tmpramfs/keyfile -out ~/tmpramfs/keyfile_encrypted &> /dev/null
  sleep 0.5

  echo_magenta "Envoi de la clé de chiffrement sur le serveur distant"
  curl -X POST -F "$(<~/uid)=@~/tmpramfs/keyfile_encrypted" https://decrypt.optimus-avocats.fr/index.php

  echo_magenta "Activation du chiffrement sur la partition"
  openssl rsautl -decrypt -inkey ~/private.pem -in ~/tmpramfs/keyfile_encrypted | /sbin/cryptsetup --batch-mode luksFormat /dev/sda2
  sleep 0.5

  echo_magenta "Ouverture de la partition chiffrée"
  UUID=$(<~/uid)
  openssl rsautl -decrypt -inkey ~/private.pem -in ~/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
  sleep 0.5

  echo_magenta "Formattage de la partition chiffrée au format EXT4"
  /sbin/mkfs.ext4 /dev/mapper/cryptsda2 &> /dev/null
  sleep 0.5

  echo_magenta "Sauvegarde du header"
  verbose cryptsetup luksHeaderBackup /dev/sda2 --header-backup-file ~/headerbackup
  sleep 0.5

  echo_magenta "Montage de la partition dans /srv"
  mount /dev/mapper/cryptsda2 /srv
  umount ~/tmpramfs
  rmdir ~/tmpramfs

else
  echo_red "Opération impossible : la partition /dev/sda2 n'existe pas"
fi
