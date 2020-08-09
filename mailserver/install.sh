#!/bin/bash
source /installer/functions.sh
source /installer/config.sh

echo
echo_green "==== INSTALLATION DU SERVEUR MAIL ===="
if [ ! $MAILSERVER_AREYOUSURE ]; then echo_green "Souhaitez vous installer le serveur mail ?"; read -p "(o)ui / (n)on ? " -n 1 -e MAILSERVER_AREYOUSURE; fi
if [[ $MAILSERVER_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Création de l'utilisateur/groupe mailboxes"
  [ $(getent group mailboxes) ] || verbose groupadd mailboxes --gid 203
  [ $(getent passwd mailboxes) ] || verbose useradd -g mailboxes -s /bin/false -d /srv/mailboxes --uid 203 mailboxes

  echo_magenta "Création des dossiers"
  verbose mkdir -p /srv/mailboxes
  verbose chown mailboxes:mailboxes /srv/mailboxes

  echo_magenta "Création de l'utilisateur MARIADB"
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE ON mailserver.* TO '$MAILSERVER_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT ON users.users TO '$MAILSERVER_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_MARIADB_PASSWORD';"

  echo_magenta "Installation des bases de données MARIADB"
  if [ -f "/srv/databases/MAILSERVER_DB_VERSION" ]; then db_version=$(cat /srv/databases/MAILSERVER_DB_VERSION); fi

  for file in /installer/mailserver/*.sql
  do
    file="${file:22:-4}"
    if [[ $file > $db_version ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /installer/mailserver/$file.sql
      echo $file > /srv/databases/MAILSERVER_DB_VERSION
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done

  echo_magenta "Création de la boite mail initiale postmaster@$DOMAIN"
  verbose mariadb -u root -e "INSERT IGNORE INTO mailserver.mailboxes VALUES (NULL, '1', '$MAILSERVER_POSTMASTER_MAILBOX_USER', AES_ENCRYPT('$MAILSERVER_POSTMASTER_MAILBOX_PASSWORD','$AES_KEY'), '0', '1', null, null, null, null, null);"
  verbose mariadb -u root -e "INSERT IGNORE INTO mailserver.mailboxes_domains VALUES (NULL, 1, '$DOMAIN');"

  echo_magenta "Ouverture des ports du Firewall"
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw allow 993
    verbose /sbin/ufw allow 587
    verbose /sbin/ufw allow 465
    verbose /sbin/ufw allow 143
    verbose /sbin/ufw allow 25
  fi

  echo_magenta "Installation des paquets de POSTFIX"
  DEBIAN_FRONTEND=noninteractive verbose apt-get -qq -y install postfix postfix-mysql sasl2-bin libsasl2-modules libsasl2-modules-sql

  echo_magenta "Modification des fichiers de configuration de POSTFIX"
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/saslauthd > /etc/default/saslauthd
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/aliases.cf > /etc/postfix/aliases.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/maildirs.cf > /etc/postfix/maildirs.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/main.cf > /etc/postfix/main.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/master.cf > /etc/postfix/master.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/recipient_bcc.cf > /etc/postfix/recipient_bcc.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/redirections.cf > /etc/postfix/redirections.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/sender_bcc.cf > /etc/postfix/sender_bcc.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/smtpauth.cf > /etc/postfix/smtpauth.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/transport.cf > /etc/postfix/transport.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/virtual_domains.cf > /etc/postfix/virtual_domains.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/postfix/smtpd.conf > /etc/postfix/sasl/smtpd.conf

  echo_magenta "Installation des paquets de DOVECOT"
  verbose apt-get -qq -y install dovecot-imapd dovecot-mysql dovecot-sieve dovecot-managesieved

  echo_magenta "Modification des fichiers de configuration de DOVECOT"
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/dovecot/dovecot.conf > /etc/dovecot/dovecot.conf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/dovecot/dovecot-sql.conf > /etc/dovecot/dovecot-sql.conf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/dovecot/dovecot-dict-sql.conf > /etc/dovecot/dovecot-dict-sql.conf
  chmod +666 /var/log/dovecot.log
  chmod +666 /var/log/dovecot-info.log
  chmod +666 /var/log/dovecot-debug.log

  echo_magenta "Installation des paquets de SPAMASSASSIN"
  verbose apt-get -qq -y install spamass-milter

  echo_magenta "Création de l'utilisateur/groupe spamd"
  [ $(getent group spamd) ] || verbose groupadd spamd --gid 202
  [ $(getent passwd spamd) ] || verbose useradd -g spamd -s /bin/false -d /var/log/spamassassin --uid 202 spamd

  echo_magenta "Création du fichier de log SPAMASSASSIN"
  verbose mkdir -p /var/log/spamassassin
  verbose chown spamd:spamd /var/log/spamassassin

  echo_magenta "Activation de SPAMASSASSIN au lancement de la machine"
  verbose systemctl -q enable spamassassin

  echo_magenta "Modification des fichiers de configuration de SPAMASSASSIN"
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/spamassassin/spamassassin > /etc/default/spamassassin
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/spamassassin/local.cf > /etc/spamassassin/local.cf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/spamassassin/spamass-milter > /etc/default/spamass-milter
  verbose sa-update


  echo_magenta "Installation des paquets de CLAMAV"
  verbose apt-get -qq -y install clamav-milter

  echo_magenta "Modification des fichiers de configuration de CLAMAV"
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/clamav/clamav-milter.conf > /etc/clamav/clamav-milter.conf
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/clamav/clamav-milter > /etc/default/clamav-milter
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/clamav/virusaction.sh > /etc/clamav/virusaction.sh
  verbose chown clamav:clamav /etc/clamav/virusaction.sh
  verbose chmod 755 /etc/clamav/virusaction.sh


  echo_magenta "Installation d'OPENDKIM"
  verbose apt-get -qq -y install opendkim opendkim-tools
  if [ ! -f /etc/dkim/keys/$DOMAIN/mail.private ]
  then
    verbose mkdir -p /etc/dkim/keys/$DOMAIN
    verbose opendkim-genkey -D /etc/dkim/keys/$DOMAIN -d $DOMAIN -s mail
    verbose chown opendkim:opendkim -R /etc/dkim
fi
  envsubst '${AES_KEY} ${DOMAIN} ${MAILSERVER_MARIADB_USER} ${MAILSERVER_MARIADB_PASSWORD}' < /installer/mailserver/opendkim/opendkim.conf > /etc/opendkim.conf

  if ! grep -q "mail._domainkey.$DOMAIN $DOMAIN:mail:/etc/dkim/keys/$DOMAIN/mail.private" /etc/dkim/KeyTable
  then
    echo "mail._domainkey.$DOMAIN $DOMAIN:mail:/etc/dkim/keys/$DOMAIN/mail.private" >> /etc/dkim/KeyTable
  fi

  if ! grep -q "*@$DOMAIN mail._domainkey.$DOMAIN" /etc/dkim/SigningTable
  then
    echo "*@$DOMAIN mail._domainkey.$DOMAIN" >> /etc/dkim/SigningTable
  fi

  if ! grep -q "$DOMAIN" /etc/dkim/TrustedHosts
  then
    echo "$DOMAIN" >> /etc/dkim/TrustedHosts
  fi
  verbose sed -i 's/SOCKET=local:$RUNDIR\/opendkim.sock/SOCKET="inet:8891:localhost"/g' /etc/default/opendkim

  echo_magenta "Installation d'OPENDMARC"
  verbose apt-get -qq -y install opendmarc
  envsubst '${DOMAIN}' < /installer/mailserver/opendmarc/opendmarc.conf > /etc/opendmarc.conf
  sudo mkdir -p /etc/opendmarc/
  sudo mkdir -p /var/spool/postfix/opendmarc
  sudo chown opendmarc:opendmarc /var/spool/postfix/opendmarc -R
  sudo chmod 750 /var/spool/postfix/opendmarc/ -R
  sudo adduser postfix opendmarc
  echo "localsost" > /etc/opendmarc/ignore.hosts
  echo "10.0.0.0/24" >> /etc/opendmarc/ignore.hosts
  verbose sed -i 's/SOCKET=local:$RUNDIR\/opendmarc.sock/SOCKET="inet:8892@localhost"/g' /etc/default/opendmarc
  verbose systemctl enable opendmarc


  echo_magenta "Redémarrage des services"
  verbose systemctl restart clamav-daemon
  verbose systemctl restart clamav-milter
  verbose systemctl restart spamassassin
  verbose systemctl restart spamass-milter
  verbose systemctl restart postfix
  verbose systemctl restart dovecot
  verbose systemctl restart opendkim
  verbose systemctl restart opendmarc

fi
