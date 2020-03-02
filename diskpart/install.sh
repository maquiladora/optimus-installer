#!/bin/bash

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
