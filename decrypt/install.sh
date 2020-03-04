#!/bin/bash

mkdir /root/tmpramfs
mount ramfs /root/tmpramfs/ -t ramfs
wget -O /root/tmpramfs/keyfile_encrypted https://installer.optimus-avocats.fr/autodecryptor/$(</root/uid)_keyfile
openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
umount /root/tmpramfs
rmdir /root/tmpramfs

#if [ -f /root/keyfile_encrypted ]
#then
  #echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  #openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
#else
  #echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  #/sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
#fi

mount /dev/mapper/cryptsda2 /srv
