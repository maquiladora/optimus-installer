#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo_magenta "Installation de RSYNC en cours..."
verbose apt-get -qq install rsync sendmail

echo_magenta "Test d'un require"
require DOMAIN

echo
echo_green "==== SAUVEGARDE AUTOMATIQUE DES BASES DE DONNEES ===="
if [ ! $BACKUP_AREYOUSURE ]; then echo_green "Souhaitez vous mettre en place les sauvegardes incrémentielles ?"; read -p "(o)ui / (n)on ? " -n 1 -e BACKUP_AREYOUSURE; fi
if [[ $BACKUP_AREYOUSURE =~ ^[YyOo]$ ]]
then
  verbose apt-get install rsync tar
  ssh-keygen -y -f /root/private.pem | ssh debian@192.168.0.9 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
  verbose mkdir -p /srv/db-backup
  verbose mkdir -p /srv/increments
  envsubst '${DOMAIN}' < /installer/backup/allspark-backup.sh > /srv/allspark-backup.php
  cp /installer/backup/allspark-backup.timer /etc/systemd/system/allspark-backup.timer
  cp /installer/backup/allspark-backup.service /etc/systemd/system/allspark-backup.service
  systemctl enable allspark-backup.timer
  systemctl start allspark-backup.timer
fi
