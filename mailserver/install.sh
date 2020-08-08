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
  verbose mariadb -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE mailserver.* TO '$MAILSERVER_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_MARIADB_PASSWORD';"
  verbose mariadb -u root -e "GRANT SELECT ON users.users TO '$MAILSERVER_MARIADB_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_MARIADB_PASSWORD';"

  echo_magenta "Installation des bases de données MARIADB"
  if [ -f "/srv/databases/MAIL_DB_VERSION" ]; then db_version=$(cat /srv/databases/MAIL_DB_VERSION); fi

  for file in /installer/mailserver/*.sql
  do
    file="${file:22:-4}"
    if [[ $file > $db_version ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /installer/mailserver/$file.sql
      echo $file > /srv/databases/MAIL_DB_VERSION
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done

  echo_magenta "Création de la boite mail initiale postmaster@$DOMAIN"
  verbose mariadb -u root -e "INSERT IGNORE INTO server.mailboxes VALUES (NULL, '$MAILSERVER_POSTMASTER_MAILBOX_USER', AES_ENCRYPT('$MAILSERVER_POSTMASTER_MAILBOX_PASSWORD','$AES_KEY'), '0', '1', null, null, null, null, null);"
  verbose mariadb -u root -e "INSERT IGNORE INTO server.mailboxes_domains VALUES (NULL, 1, '$DOMAIN');"

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
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/saslauthd > /etc/default/saslauthd
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/aliases.cf > /etc/postfix/aliases.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/maildirs.cf > /etc/postfix/maildirs.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/main.cf > /etc/postfix/main.cf
  cp /installer/mailserver/postfix/master.cf /etc/postfix/
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/recipient_bcc.cf > /etc/postfix/recipient_bcc.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/redirections.cf > /etc/postfix/redirections.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/sender_bcc.cf > /etc/postfix/sender_bcc.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/smtpauth.cf > /etc/postfix/smtpauth.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/transport.cf > /etc/postfix/transport.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/virtual_domains.cf > /etc/postfix/virtual_domains.cf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/postfix/smtpd.conf > /etc/postfix/sasl/smtpd.conf

  echo_magenta "Installation des paquets de DOVECOT"
  verbose apt-get -qq -y install dovecot-imapd dovecot-mysql dovecot-sieve dovecot-managesieved

  echo_magenta "Modification des fichiers de configuration de DOVECOT"
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/dovecot/dovecot.conf > /etc/dovecot/dovecot.conf
  cat /installer/mailserver/dovecot/dovecot-sql.conf > /etc/dovecot/dovecot-sql.conf
  sed -e 's/$aes_key/'$AES_KEY'/g' -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/dovecot/dovecot-dict-sql.conf > /etc/dovecot/dovecot-dict-sql.conf


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
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/spamassassin/spamassassin > /etc/default/spamassassin
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_MARIADB_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_MARIADB_PASSWORD'/g' /installer/mailserver/spamassassin/local.cf > /etc/spamassassin/local.cf
  sed -e 's/$domain/'$DOMAIN'/g' /installer/mailserver/spamassassin/spamass-milter > /etc/default/spamass-milter
  verbose sa-update


  echo_magenta "Installation des paquets de CLAMAV"
  verbose apt-get -qq -y install clamav-milter

  echo_magenta "Modification des fichiers de configuration de CLAMAV"
  verbose cp /installer/mailserver/clamav/clamav-milter.conf /etc/clamav/
  verbose cp /installer/mailserver/clamav/clamav-milter /etc/default/
  sed -e 's/$domain/'$DOMAIN'/g' /installer/mailserver/clamav/virusaction.sh > /etc/clamav/virusaction.sh
  verbose chown clamav:clamav /etc/clamav/virusaction.sh
  verbose chmod 755 /etc/clamav/virusaction.sh


  echo_magenta "Installation d'OPENDKIM"
  verbose apt-get -qq -y install opendkim opendkim-tools
  verbose mkdir -p /etc/dkim/keys/$DOMAIN
  verbose opendkim-genkey -D /etc/dkim/keys/$DOMAIN -d $DOMAIN -s mail
  verbose chown opendkim:opendkim -R /etc/dkim
  verbose cp /installer/mailserver/opendkim/opendkim.conf /etc/
  echo "mail._domainkey.$DOMAIN $DOMAIN:mail:/etc/dkim/keys/$DOMAIN/mail.private" >> /etc/dkim/KeyTable
  echo "*@$DOMAIN mail._domainkey.$DOMAIN" >> /etc/dkim/SigningTable
  echo "$DOMAIN" >> /etc/dkim/TrustedHosts
  verbose sed -i 's/SOCKET=local:$RUNDIR\/opendkim.sock/SOCKET="inet:8891:localhost"/g' /etc/default/opendkim

  echo_magenta "Redémarrage des services"
  verbose systemctl restart clamav-daemon
  verbose systemctl restart clamav-milter
  verbose systemctl restart spamassassin
  verbose systemctl restart spamass-milter
  verbose systemctl restart postfix
  verbose systemctl restart dovecot
  verbose systemctl restart opendkim

fi
