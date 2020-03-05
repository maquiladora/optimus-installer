#!/bin/bash

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
    cp /installer/diskpart/resizefs_hook /etc/initramfs-tools/hooks/resizefs_hook
    chmod +x /etc/initramfs-tools/hooks/resizefs_hook
    cp /installer/diskpart/resizefs /etc/initramfs-tools/scripts/local-premount/resizefs
    chmod +x /etc/initramfs-tools/scripts/local-premount/resizefs
    cp /installer/diskpart/rc.local /etc/rc.local
    chmod +x /etc/rc.local
    sleep 0.5

    echo_magenta "Mise à jour du module INITRAMFS..."
    apt-get remove -qq cryptsetup-initramfs
    update-initramfs -u

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
