#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== DECHIFFREMENT DE LA PARTITION CHIFFREE ===="

echo_magenta "Ouverture de la partition cryptée via le serveur de clé distant..."
mkdir /root/tmpramfs
mount ramfs /root/tmpramfs/ -t ramfs
wget -qO /root/tmpramfs/keyfile_encrypted https://decrypt.optimus-avocats.fr/$(</root/uid)_keyfile
openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
umount /root/tmpramfs
rmdir /root/tmpramfs

if ! lsblk -o NAME -n /dev/mapper/cryptsda2 2>/dev/null | grep -q cryptsda2
then
  if [ -f /root/keyfile_encrypted ]
  then
    echo_magenta "Ouverture de la partition chiffrée avec une clé locale..."
    openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
  else
    echo_magenta "Ouverture de la partition chiffrée avec une clé saisie dans le terminal..."
    /sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
  fi
fi

echo_magenta "Montage de la partition chiffrée..."
mount /dev/mapper/cryptsda2 /srv

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
