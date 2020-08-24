#!/usr/bin/env bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

VIRUS=$1
FILE=$2
SENDER=$3
RECIPIENT=$4
SUBJECT=$5
MSGID=$6
DATE=$7

cat -v << EOF | mail -s "***VIRUS*** $SUBJECT" $RECIPIENT -aFrom:prime@$DOMAIN
Le courriel ci-dessous contenait un virus.
Le message est mis en quarantaine.

Signature    :  $VIRUS
Date         :  $DATE
Sujet        :  $SUBJECT
Expediteur   :  $SENDER
Destinataire :  $RECIPIENT
Fichier      :  $FILE
EOF
