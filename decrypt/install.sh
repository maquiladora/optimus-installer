#!/bin/bash

if [ -f /root/keyfile ]
then
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2 --key-file < openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted
else
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
fi

mount /dev/mapper/cryptsda2 /srv
