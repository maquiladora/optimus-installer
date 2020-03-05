#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

if [ ! lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2' ]
then
  echo_red "!! ATTENTION !!"
  echo_red "CETTE OPERATION ET RISQUEE"
  echo_red "ELLE PEUT CORROMPRE LE DISQUE ET LE SYSTEME"
  echo_red "IL N'EST RECOMMANDE DE LA LANCER QUE SUR UN SYSTEME VIERGE DE TOUTES DONNEES"
  echo


  if [ ! $DISKPART_AREYOUSURE ]; then echo_green "Etes vous sûr ?"; read -p "(O)ui / (N)on ? " -i "O" -e DISKPART_AREYOUSURE; fi
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

    echo_red "Un redémarrage est nécessaire pour finaliser le partitionnement"
    echo_red "APPUYER SUR [ENTREE] POUR CONTINUER"
    read -p ""
    reboot
  fi
else
  echo_red "Opération impossible : la partition /dev/sda2 existe déjà"
  echo_red "APPUYER SUR [ENTREE] POUR CONTINUER"
  read -p ""
fi
