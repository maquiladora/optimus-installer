#!/bin/bash

if [ -f /root/keyfile_encrypted ]
then
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
else
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
fi

mount /dev/mapper/cryptsda2 /srv
