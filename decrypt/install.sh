#!/bin/bash
source /installer/functions.sh
require PART_TO_ENCRYPT
require UUID uuid
source /root/.allspark

echo
echo_green "==== DECHIFFREMENT DE LA PARTITION CHIFFREE ===="

echo_magenta "Ouverture de la partition cryptée via le serveur de clé distant..."
mkdir /root/tmpramfs
mount ramfs /root/tmpramfs/ -t ramfs
wget -qO /root/tmpramfs/keyfile_encrypted https://decrypt.optimus-avocats.fr/$UUID&&_keyfile
openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
umount /root/tmpramfs
rmdir /root/tmpramfs

if ! lsblk -o NAME -n /dev/mapper/crypt$PART_TO_ENCRYPT 2>/dev/null | grep -q crypt$PART_TO_ENCRYPT
then
  if [ -f /root/keyfile_encrypted ]
  then
    echo_magenta "Ouverture de la partition chiffrée avec une clé locale..."
    openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
  else
    echo_magenta "Ouverture de la partition chiffrée avec une clé saisie dans le terminal..."
    /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
  fi
fi

echo_magenta "Montage de la partition chiffrée..."
mount /dev/mapper/crypt$PART_TO_ENCRYPT /srv

sleep 0.5

echo_magenta "Redémarrage des services"
if [ -d /srv/www ] || [ -d /srv/api ] || [ -d /srv/cloud ] || [ -d /srv/webmail ]; then verbose systemctl restart apache2; fi
if [ -d /srv/databases ]; then verbose systemctl restart mariadb; fi
if [ -d /srv/mailboxes ]
then
  verbose systemctl restart postfix
  verbose systemctl restart dovecot
  verbose systemctl restart spamassassin
  verbose systemctl restart spamass-milter
  verbose systemctl restart clamav-daemon
  verbose systemctl restart clamav-milter
fi
