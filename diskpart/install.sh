#!/bin/bash
source /etc/allspark/functions.sh
source /root/.allspark

if [ -z $DISKPART_DISK_TO_PART ]
then
  if [ -e /dev/nvme0n1 ]
  then
    export DISKPART_DISK_TO_PART=nvme0n1
    export PART_TO_ENCRYPT=nvme0n1p2
  elif [ -e /dev/sda ]
  then
    export DISKPART_DISK_TO_PART=sda
    export PART_TO_ENCRYPT=sda2
  else
    require DISKPART_DISK_TO_PART
    require PART_TO_ENCRYPT
  fi
  update_conf DISKPART_DISK_TO_PART $DISKPART_DISK_TO_PART
  update_conf PART_TO_ENCRYPT $PART_TO_ENCRYPT
fi


if [ -e /dev/$DISKPART_DISK_TO_PART ] && [ ! -e /dev/$PART_TO_ENCRYPT ]
then
  FREESPACE=$(/usr/sbin/sfdisk --list-free --quiet /dev/$DISKPART_DISK_TO_PART | grep -v "Size" |  awk '{print $NF}')
  FIRSTSECTOR=$(/usr/sbin/sfdisk --list-free --quiet /dev/$DISKPART_DISK_TO_PART | grep -v "Size" |  awk '{print $1}')

  if [ ! -z "$FREESPACE" ]
  then
    if [ ! $DISKPART_USE_FREESPACE ]; then echo_green "Souhaitez vous utiliser les $FREESPACE non partitionnés de $DISKPART_DISK_TO_PART"; read -p "(o)ui / (n)on ? " -n 1 -e DISKPART_USE_FREESPACE; fi
    if [[ $DISKPART_USE_FREESPACE =~ ^[Yy]$ ]]
    then
      echo $FIRSTSECTOR | /usr/sbin/sfdisk /dev/$PART_TO_ENCRYPT --append --force
      /usr/sbin/mkfs.ext4 /dev/$PART_TO_ENCRYPT
      mount /dev/$PART_TO_ENCRYPT /srv
    fi
  else
    echo_red "!! ATTENTION !!"
    echo_red "CETTE OPERATION ET RISQUEE"
    echo_red "ELLE PEUT CORROMPRE LE DISQUE ET LE SYSTEME"
    echo_red "IL N'EST RECOMMANDE DE LA LANCER QUE SUR UN SYSTEME VIERGE DE TOUTES DONNEES"
    echo

    if [ ! $DISKPART_RESIZE_PARTITION_AREYOUSURE ]; then echo_green "Souhaitez vous redimensionner le disque $DISKPART_DISK_TO_PART ?"; read -p "(o)ui / (n)on ? " -n 1 -e DISKPART_RESIZE_PARTITION_AREYOUSURE; fi
    if [[ $DISKPART_RESIZE_PARTITION_AREYOUSURE =~ ^[YyOo]$ ]]
    then
      echo_magenta "Mise en place des scripts de partitionnement..."
      verbose cp /etc/allspark/diskpart/resizefs_hook /etc/initramfs-tools/hooks/resizefs_hook
      verbose chmod +x /etc/initramfs-tools/hooks/resizefs_hook
      verbose cp /etc/allspark/diskpart/resizefs /etc/initramfs-tools/scripts/local-premount/resizefs
      verbose chmod +x /etc/initramfs-tools/scripts/local-premount/resizefs
      verbose cp /etc/allspark/diskpart/rc.local /etc/rc.local
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
