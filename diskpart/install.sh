#!/bin/bash

if ! lsblk -o NAME -n /dev/sda2 2>/dev/null | grep -q 'sda2'
then
  echo -e "\e[31m!! ATTENTION !!\e[0m"
  echo -e "\e[31mCETTE OPERATION ET RISQUEE\e[0m"
  echo -e "\e[31mELLE PEUT CORROMPRE LE DISQUE ET LE SYSTEME\e[0m"
  echo -e "\e[31mIL N'EST RECOMMANDE DE LA LANCER QUE SUR UN SYSTEME VIERGE DE TOUTES DONNEES\e[0m"
  echo


  if [ ! $DISKPART_AREYOUSURE ]; then echo_green "Etes vous sûr ?"; read -p "(O)ui / (N)on ? " -i "O" -e DISKPART_AREYOUSURE; fi

  if [ $DISKPART_AREYOUSURE = "O" ]
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
    apt-get remove -qq cryptsetup-initramfs > /dev/null
    update-initramfs -u > /dev/null

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
