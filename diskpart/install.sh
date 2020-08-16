#!/bin/bash
source /installer/functions.sh
require PART_TO_ENCRYPT
source /root/.allspark

FREESPACE=$(/usr/sbin/sfdisk --list-free --quiet /dev/$PART_TO_ENCRYPT | grep -v "Size" |  awk '{print $NF}')
FIRSTSECTOR=$(/usr/sbin/sfdisk --list-free --quiet /dev/$PART_TO_ENCRYPT | grep -v "Size" |  awk '{print $1}')

if ! lsblk -o NAME -n /dev/$PART_TO_ENCRYPT 2>/dev/null | grep -q $PART_TO_ENCRYPT
then
  echo_red "!! ATTENTION !!"
  echo_red "CETTE OPERATION ET RISQUEE"
  echo_red "ELLE PEUT CORROMPRE LE DISQUE ET LE SYSTEME"
  echo_red "IL N'EST RECOMMANDE DE LA LANCER QUE SUR UN SYSTEME VIERGE DE TOUTES DONNEES"
  echo

  if [ ! $DISKPART_USE_FREESPACE ]; then echo_green "Souhaitez vous utiliser l'espace non partitionné de $FREESPACE"; read -p "(o)ui / (n)on ? " -n 1 -e DISKPART_USE_FREESPACE; fi
  if [[ $DISKPART_USE_FREESPACE =~ ^[Yy]$ ]]
  then
    echo $FIRSTSECTOR | /usr/sbin/sfdisk /dev/$PART_TO_ENCRYPT --append --force
    /usr/sbin/mkfs.ext4 /dev/$PART_TO_ENCRYPT
    mount /dev/$PART_TO_ENCRYPT /srv
  else
    if [ ! $DISKPART_AREYOUSURE ]; then echo_green "Souhaitez vous repartitionner la partition système ?"; read -p "(o)ui / (n)on ? " -n 1 -e DISKPART_AREYOUSURE; fi
    if [[ $DISKPART_AREYOUSURE =~ ^[YyOo]$ ]]
    then
      echo_magenta "Mise en place des scripts de partitionnement..."
      verbose cp /installer/diskpart/resizefs_hook /etc/initramfs-tools/hooks/resizefs_hook
      verbose chmod +x /etc/initramfs-tools/hooks/resizefs_hook
      verbose cp /installer/diskpart/resizefs /etc/initramfs-tools/scripts/local-premount/resizefs
      verbose chmod +x /etc/initramfs-tools/scripts/local-premount/resizefs
      verbose cp /installer/diskpart/rc.local /etc/rc.local
      verbose chmod +x /etc/rc.local
      sleep 0.5

      echo_magenta "Mise à jour du module INITRAMFS..."
      verbose apt-get remove -qq cryptsetup-initramfs
      verbose update-initramfs -u

      echo
      echo_red "Un redémarrage est nécessaire pour finaliser le partitionnement"
      echo_red "APPUYER SUR [ENTREE] POUR CONTINUER"
      read -p ""
      reboot
    fi
  fi
else
  echo_red "Opération impossible : la partition /dev/$PART_TO_ENCRYPT existe déjà"
  echo_red "APPUYER SUR [ENTREE] POUR CONTINUER"
  read -p ""
fi
