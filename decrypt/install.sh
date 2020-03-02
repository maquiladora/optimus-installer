#!/bin/bash

if [ -f /root/keyfile ]
then
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
else
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
fi

mount /dev/mapper/cryptsda2 /srv
