#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $DOMAIN ]; then require DOMAIN string "Veuillez renseigner votre nom de domaine :"; source /root/.allspark; fi
if [ -z $MODULE_BACKUP ]; then require MODULE_BACKUP yesno "Voulez-vous installer le module de sauvegarde ?"; source /root/.allspark; fi
if [ -z $BACKUP_SERVER ]; then require BACKUP_SERVER string "Veuillez renseigner l'adresse IP du serveur de sauvegarde"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_BACKUP = "Y" ]
then
  echo
  echo_green "==== SAUVEGARDE AUTOMATIQUE DES BASES DE DONNEES ===="

  echo_magenta "Installation des paquets requis"
  verbose apt-get -qq install rdiff-backup sendmail tar

  echo_magenta "Envoi de la clé publique au serveur distant"
  ssh-keygen -y -f /root/private.pem | ssh debian@$BACKUP_SERVER "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

  echo_magenta "Installation des paquets requis sur le serveur distant"
  ssh -i /root/private.pem debian@$BACKUP_SERVER sudo apt-get install -qq -y rdiff-backup
  ssh -i /root/private.pem debian@$BACKUP_SERVER sudo chown debian:debian /srv

  echo_magenta "Création des dossiers"
  verbose mkdir -p /srv/db-backup

  echo_magenta "Installation du script de sauvegarde"
  envsubst '${DOMAIN} ${BACKUP_SERVER}' < /etc/allspark/backup/allspark-backup.sh > /srv/allspark-backup.sh
  chmod 744 /srv/allspark-backup.sh

  echo_magenta "Création de la tâche automatique quotidienne"
  cp /etc/allspark/backup/allspark-backup.timer /etc/systemd/system/allspark-backup.timer
  cp /etc/allspark/backup/allspark-backup.service /etc/systemd/system/allspark-backup.service
  systemctl enable allspark-backup.timer
  systemctl start allspark-backup.timer
fi
