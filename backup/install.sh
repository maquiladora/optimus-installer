#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_BACKUP ]; then require MODULE_BACKUP yesno "Voulez-vous installer le module de sauvegarde ?"; source /root/.allspark; fi
if [ -z $BACKUP_SERVER ]; then require BACKUP_SERVER string "Veuillez renseigner l'adresse IP du serveur de sauvegarde"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_BACKUP = "Y" ]
then
  echo
  echo_green "==== SAUVEGARDE AUTOMATIQUE DES BASES DE DONNEES ===="

  echo_magenta "Installation des paquets requis"
  verbose apt-get -qq install rsync-backup sendmail tar

  echo_magenta "Envoi de la clé publique au serveur distant"
  ssh-keygen -y -f /root/private.pem | ssh debian@$BACKUP_SERVER "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
  verbose mkdir -p /srv/db-backup
  verbose mkdir -p /srv/increments
  envsubst '${DOMAIN}' < /etc/allspark/backup/allspark-backup.sh > /srv/allspark-backup.sh
  cp /etc/allspark/backup/allspark-backup.timer /etc/systemd/system/allspark-backup.timer
  cp /etc/allspark/backup/allspark-backup.service /etc/systemd/system/allspark-backup.service
  systemctl enable allspark-backup.timer
  systemctl start allspark-backup.timer
fi
