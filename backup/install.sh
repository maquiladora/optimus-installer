#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

verbose apt-get install rsync sendmail

echo
echo_green "==== SAUVEGARDE AUTOMATIQUE DES BASES DE DONNES ===="
if [ ! $BACKUP_DBBACKUP_AREYOUSURE ]; then echo_green "Souhaitez vous sauvegarder automatiquement les bases de données chaque jour à 23h30 ?"; read -p "(o)ui / (n)on ? " -n 1 -e BACKUP_DBBACKUP_AREYOUSURE; fi
if [[ $BACKUP_DBBACKUP_AREYOUSURE =~ ^[YyOo]$ ]]
then
  verbose apt-get install php php-mysql php-zip
  verbose mkdir -p /srv/db-backup
  envsubst '${DOMAIN}' < /installer/backup/db-backup.php > /srv/db-backup.php
  cp /installer/backup/db-backup.timer /etc/systemd/system/db-backup.timer
  cp /installer/backup/db-backup.service /etc/systemd/system/db-backup.service
  systemctl enable db-backup.timer
  systemctl start db-backup.timer
fi

echo
echo_green "==== SAUVEGARDE INCREMENTIELLE A DISTANCE ===="
if [ ! $BACKUP_INCREMENTS_AREYOUSURE ]; then echo_green "Souhaitez vous effectuer une sauvegarde incrémentielle chaque jour à 2h30 ?"; read -p "(o)ui / (n)on ? " -n 1 -e BACKUP_INCREMENTS_AREYOUSURE; fi
if [[ $BACKUP_INCREMENTS_AREYOUSURE =~ ^[YyOo]$ ]]
then
  verbose apt-get install rsync
  envsubst '${DOMAIN}' < /installer/backup/increments-backup.sh > /srv/increments-backup.sh
  cp /installer/backup/increments-backup.timer /etc/systemd/system/increments-backup.timer
  cp /installer/backup/increments-backup.service /etc/systemd/system/increments-backup.service
  systemctl enable increments-backup.timer
  systemctl start increments-backup.timer

  ssh-keygen -y -f /root/private.pem | ssh debian@192.168.0.9 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"


fi
