#!/bin/bash
source /etc/allspark/functions.sh
require PART_TO_ENCRYPT
require UUID uuid
source /root/.allspark

if lsblk -o NAME -n /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q $PART_TO_ENCRYPT && [ ! -e /dev/mapper/crypt${PART_TO_ENCRYPT} ]
then

  echo_green "==== CHIFFREMENT DU DISQUE ===="

  echo_magenta "Installation des paquets requis..."
  DEBIAN_FRONTEND=noninteractive apt-get -qq install keyboard-configuration &> /dev/null
  verbose apt-get -qq install cryptsetup cryptsetup-bin > /dev/null
  verbose apt-get -qq install curl

  if mountpoint -q /srv
  then
    echo_magenta "Démontage de la partition"
    verbose umount /srv
  fi

  echo_magenta "Création d'une clé de chiffrement..."
  mkdir /root/tmpramfs
  mount ramfs /root/tmpramfs/ -t ramfs
  </dev/urandom tr -dc A-Za-z0-9 | head -c 256 > /root/tmpramfs/keyfile
  chmod 0400 /root/tmpramfs/keyfile
  openssl genrsa -out /root/private.pem 4096 &> /dev/null
  openssl rsa -in /root/private.pem -outform PEM -pubout -out /root/public.pem &> /dev/null
  openssl rsautl -encrypt -inkey /root/public.pem -pubin -in /root/tmpramfs/keyfile -out /root/tmpramfs/keyfile_encrypted &> /dev/null
  sleep 0.5

  echo_magenta "Envoi de la clé de chiffrement sur le serveur distant"
  curl -X POST -F "$UUID=@/root/tmpramfs/keyfile_encrypted" https://decrypt.optimus-avocats.fr/index.php

  echo_magenta "Activation du chiffrement sur la partition"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup --batch-mode luksFormat /dev/$PART_TO_ENCRYPT
  sleep 0.5

  echo_magenta "Ouverture de la partition chiffrée"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
  sleep 0.5

  echo_magenta "Formattage de la partition chiffrée au format EXT4"
  /sbin/mkfs.ext4 /dev/mapper/crypt$PART_TO_ENCRYPT &> /dev/null
  sleep 0.5

  echo_magenta "Sauvegarde du header"
  verbose cryptsetup luksHeaderBackup /dev/$PART_TO_ENCRYPT --header-backup-file /root/headerbackup
  sleep 0.5

  echo_magenta "Montage de la partition dans /srv"
  mount /dev/mapper/crypt$PART_TO_ENCRYPT /srv
  umount /root/tmpramfs
  rmdir /root/tmpramfs

else
  if lsblk -o NAME -n /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q $PART_TO_ENCRYPT
  then
    echo_red "Opération impossible : la partition /dev/$PART_TO_ENCRYPT n'existe pas"
  fi

  if [ ! -e /dev/mapper/crypt${PART_TO_ENCRYPT} ]
  then
    echo_red "Opération impossible : la partition est déjà crypté"
  fi
fi
