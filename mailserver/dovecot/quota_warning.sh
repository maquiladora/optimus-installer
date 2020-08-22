#!/bin/sh
PERCENT=$1
USER=$2
cat << EOF | /usr/local/libexec/dovecot/dovecot-lda -d $USER -o "plugin/quota=maildir:User quota:noenforcing"
From: prime@$DOMAIN
Subject: Alerte quota

Votre boite mail a atteint un taux de remplissage de $PERCENT%.
EOF
