#!/bin/bash

echo -e "\e[31m!! ATTENTION !!\e[0m"
echo -e "\e[31mCETTE OPERATION ET RISQUEE ET PEUT CORROMPRE LE DISQUE ET LE SYSTEME\e[0m"
echo -e "\e[31mIL N'EST RECOMMANDE DE LA LANCER QUE SUR UN SYSTEME VIERGE QUI VIENT D'ETRE INSTALLE\e[0m"
echo

cp /installer/diskpart/resizefs_hook /etc/initramfs-tools/hooks/resizefs_hook
chmod +x /etc/initramfs-tools/hooks/resizefs_hook

cp /installer/diskpart/resizefs /etc/initramfs-tools/scripts/local-premount/resizefs
chmod +x /etc/initramfs-tools/scripts/local-premount/resizefs

cp /installer/diskpart/rc.local /etc/rc.local
chmod +x /etc/rc.local

update-initramfs -u

echo
read -p "Le serveur doit redémarrer pour prendre en compte les changements\nPressez [Entrée] pour continuer..."
reboot
