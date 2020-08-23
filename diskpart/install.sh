#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_DISKPART ]; then require MODULE_DISKPART yesno "Voulez-vous créer une nouvelle partition pour accueillir vos données ?"; source /root/.allspark; fi
source /root/.allspark


if [ $MODULE_DISKPART = "Y" ]
then

  echo
  echo_green "==== CREATION D'UNE NOUVELLE PARTITION ===="

  if [ -z $DISKPART_DISK_TO_PART ]
  then
    if [ -e /dev/nvme0n1 ]
    then
      update_conf DISKPART_DISK_TO_PART nvme0n1
      update_conf PART_TO_ENCRYPT nvme0n1p2
      source /root/.allspark
    elif [ -e /dev/sda ]
    then
      update_conf DISKPART_DISK_TO_PART sda
      update_conf PART_TO_ENCRYPT sda2
      source /root/.allspark
    else
      require DISKPART_DISK_TO_PART string "Veuillez indiquer sur quel disque se trouve la partition à partitionner :";
      require PART_TO_ENCRYPT string "Veuillez indiquer le nom de la nouvelle partition a créér :";
      source /root/.allspark
    fi
  fi

  if [ -e /dev/$DISKPART_DISK_TO_PART ] && [ ! -e /dev/$PART_TO_ENCRYPT ]
  then
    FREESPACE=$(/usr/sbin/sfdisk --list-free --quiet /dev/$DISKPART_DISK_TO_PART | grep -v "Size" |  awk '{print $NF}')
    FIRSTSECTOR=$(/usr/sbin/sfdisk --list-free --quiet /dev/$DISKPART_DISK_TO_PART | grep -v "Size" |  awk '{print $1}')

    if [ ! -z "$FREESPACE" ]
    then
      require DISKPART_USE_FREESPACE yesno "Souhaitez vous utiliser les $FREESPACE non partitionnés de $DISKPART_DISK_TO_PART";
      source /root/.allspark
      if [ $DISKPART_USE_FREESPACE = "Y" ]
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

      require DISKPART_RESIZE_PARTITION yesno "Souhaitez vous redimensionner le disque $DISKPART_DISK_TO_PART ?";
      source /root/.allspark
      if [ $DISKPART_RESIZE_PARTITION = "Y" ]
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
    echo_green "La partition /dev/$PART_TO_ENCRYPT existe déjà"
  fi

fi
