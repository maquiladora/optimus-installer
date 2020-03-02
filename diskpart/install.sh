#!/bin/bash

echo -e "\e[31m!! ATTENTION !!\e[0m"
echo -e "\e[31mCETTE OPERATION ET RISQUEE\e[0m"
echo -e "\e[31mELLE PEUT CORROMPRE LE DISQUE ET LE SYSTEME\e[0m"
echo -e "\e[31mIL N'EST RECOMMANDE DE LA LANCER QUE SUR UN SYSTEME VIERGE DE TOUTES DONNEES\e[0m"
echo

read -p $'\e[32mETES VOUS SUR (o/n) ? \e[0m' -n 1 -r
echo
if [[ $REPLY =~ ^[YyOo]$ ]]
then
  echo -e "\e[35mCREATION DES SCRIPTS DE REPARTITIONNEMENT...\e[0m"

  cp /installer/diskpart/resizefs_hook /etc/initramfs-tools/hooks/resizefs_hook
  chmod +x /etc/initramfs-tools/hooks/resizefs_hook

  cp /installer/diskpart/resizefs /etc/initramfs-tools/scripts/local-premount/resizefs
  chmod +x /etc/initramfs-tools/scripts/local-premount/resizefs

  cp /installer/diskpart/rc.local /etc/rc.local
  chmod +x /etc/rc.local

  update-initramfs -u > /dev/null

  echo
  echo -e "\e[35LE SERVEUR DOIT REDEMARRER POUR REDIMENSIONNER LES PARTITIONS\e[0m"
  echo -e "\e[32APPUYER SUR [ENTREE] POUR REDEMARRER\e[0m"
  read -n 1
  reboot
fi
