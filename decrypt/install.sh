#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== DECHIFFREMENT DE LA PARTITION CHIFREE ===="

mkdir /root/tmpramfs
mount ramfs /root/tmpramfs/ -t ramfs
wget -qO /root/tmpramfs/keyfile_encrypted https://decrypt.optimus-avocats.fr/$(</root/uid)_keyfile
echo_magenta "Ouverture de la partition cryptée via le serveur de clé distant..."
openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
umount /root/tmpramfs
rmdir /root/tmpramfs

if [ -f /root/keyfile_encrypted ]
then
  echo_magenta "Ouverture de la partition chiffrée avec une clé locale..."
  openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
else
  echo_magenta "Ouverture de la partition chiffrée avec une clé saisie dans le terminal..."
  /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
fi

echo_magenta "Montage de la partition chiffrée..."
mount /dev/mapper/cryptsda2 /srv

sleep 0.5

echo_magenta "Redémarrage des services"
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
