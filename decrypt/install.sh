#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_DECRYPT ]; then require MODULE_DECRYPT yesno "Voulez-vous chiffrer la partition qui stocke vos données ?"; source /root/.allspark; fi
if [ -z $PART_TO_ENCRYPT ]; then require PART_TO_ENCRYPT string "Veuillez indiquer le nom de la partition à encrypter :"; source /root/.allspark; fi
if [ -z $UUID ]; then require UUID uuid "Veuillez choisir et renseigner un identifiant unique de 16 caractères [A-Z0-9]"; source /root/.allspark; fi
source /root/.allspark

if [[ $MODULE_DECRYPT =~ ^[YyOo]$ ]]
then

  echo
  echo_green "==== DECHIFFREMENT DE LA PARTITION ===="

  if [ ! -e /dev/mapper/crypt${PART_TO_ENCRYPT} ]
  then

    echo_magenta "Ouverture de la partition cryptée via le serveur de clé distant"
    mkdir -p /root/tmpramfs
    mount ramfs /root/tmpramfs/ -t ramfs
    wget -qO /root/tmpramfs/keyfile_encrypted https://decrypt.optimus-avocats.fr/${UUID}_keyfile
    openssl rsautl -decrypt -inkey /root/private.pem -in /root/tmpramfs/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
    umount /root/tmpramfs
    rmdir /root/tmpramfs

    if ! lsblk -o NAME -n /dev/mapper/crypt$PART_TO_ENCRYPT 2>/dev/null | grep -q crypt$PART_TO_ENCRYPT
    then
      if [ -f /root/keyfile_encrypted ]
      then
        echo_magenta "Ouverture de la partition chiffrée avec une clé locale"
        openssl rsautl -decrypt -inkey /root/private.pem -in /root/keyfile_encrypted | /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
      else
        echo_magenta "Ouverture de la partition chiffrée avec une clé saisie dans le terminal"
        /sbin/cryptsetup luksOpen /dev/$PART_TO_ENCRYPT crypt$PART_TO_ENCRYPT
      fi
    fi

    echo_magenta "Montage de la partition chiffrée sur /srv"
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

  else
    echo_red "La partition est déjà déchiffrée !"
  fi

fi
