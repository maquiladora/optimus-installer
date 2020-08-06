#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

mkdir /root/tmpramfs
mount ramfs /root/tmpramfs/ -t ramfs
wget -qO /root/tmpramfs/keyfile_encrypted https://decrypt.optimus-avocats.fr/$(</root/uid)_keyfile
echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
umount /root/tmpramfs
rmdir /root/tmpramfs

if [ -f /root/keyfile_encrypted ]
then
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
else
  echo -e "\e[35mOUVERTURE DE LA PARTITION CRYPTEE...\e[0m"
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
fi

mount /dev/mapper/cryptsda2 /srv

sleep 0.5

if [ -d /etc/mysql ]; then verbose systemctl restart mariadb; fi
if [ -d /etc/mailboxes ]
then
  verbose systemctl restart postfix
  verbose systemctl restart devocot
  verbose systemctl restart spamassassin
  verbose systemctl restart spamass-milter
  verbose systemctl restart clamav-daemon
  verbose systemctl restart clamav-milter
fi
