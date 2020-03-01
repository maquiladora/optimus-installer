#!/bin/bash

cp /installer/diskpart/resizefs_hook /etc/initramfs-tools/hooks/resizefs_hook
chmod +x /etc/initramfs-tools/hooks/resizefs_hook

cp /installer/diskpart/resizefs /etc/initramfs-tools/scripts/local-premount/resizefs
chmod +x /etc/initramfs-tools/scripts/local-premount/resizefs

cp /installer/diskpart/rc.local /etc/rc.local
chmod +x /etc/rc.local

update-initramfs -u

read -p "System needs to reboot to finish. Press [Enter] key to continue..."
reboot
