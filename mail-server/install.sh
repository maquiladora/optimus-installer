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

  echo_magenta "Détermination du nom d'hôte"
  verbose echo $DOMAIN > /etc/hostname

  echo_magenta "Création de l'utilisateur MARIADB"
  verbose mariadb -u root -e "GRANT ALL ON server.mailboxes TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.mailboxes_acl TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.mailboxes_acl_anyone TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.mailboxes_domains TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.awl TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.bayes_expire TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.bayes_global_vars TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.bayes_token TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.bayes_vars TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"
  verbose mariadb -u root -e "GRANT ALL ON server.userpref TO '$MAILSERVER_USER'@'127.0.0.1' IDENTIFIED BY '$MAILSERVER_PASSWORD';"

  echo_magenta "Installation des bases de données MARIADB"
  if [ -f "/srv/databases/MAIL_DB_VERSION" ]; then verbose db_version=$(cat /srv/databases/MAIL_DB_VERSION); fi

  for file in /installer/mail-server/*.sql
  do
    file="${file:23:-4}"
    if [[ $file > $db_version ]]
    then
      echo -e "$file.sql exécuté"
      mariadb < /installer/mail-server/$file.sql
      echo $file > /srv/databases/MAIL_DB_VERSION
    else
      echo -e "$file.sql ignoré"
    fi
  done

  echo_magenta "Création de la boite mail initiale postmaster@$DOMAIN"
  verbose mariadb -u root -e "INSERT IGNORE INTO server.mailboxes VALUES (NULL, 'postmaster@$DOMAIN', '$MAILSERVER_PASSWORD', '0', '1', 'root@$DOMAIN', null, null, null, null);"
  verbose mariadb -u root -e "INSERT IGNORE INTO server.mailboxes_domains VALUES (NULL, 1, '$DOMAIN');"

  echo_magenta "Ouverture des ports du Firewall"
  if [ $(which /sbin/ufw) ]
  then
    verbose /sbin/ufw allow 993
    verbose /sbin/ufw allow 587
    verbose /sbin/ufw allow 465
    verbose /sbin/ufw allow 25
  fi

  echo_magenta "Installation des paquets de POSTFIX"
  DEBIAN_FRONTEND=noninteractive verbose apt-get -qq -y install postfix postfix-mysql sasl2-bin libsasl2-modules libsasl2-modules-sql

  echo_magenta "Modification des fichiers de configuration de POSTFIX"
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/saslauthd > /etc/default/saslauthd
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/aliases.cf > /etc/postfix/aliases.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/maildirs.cf > /etc/postfix/maildirs.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/main.cf > /etc/postfix/main.cf
  cp /installer/mail-server/master.cf /etc/postfix/
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/recipient_bcc.cf > /etc/postfix/recipient_bcc.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/redirections.cf > /etc/postfix/redirections.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/sender_bcc.cf > /etc/postfix/sender_bcc.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/smtpauth.cf > /etc/postfix/smtpauth.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/transport.cf > /etc/postfix/transport.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/virtual_domains.cf > /etc/postfix/virtual_domains.cf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/smtpd.conf > /etc/postfix/sasl/smtpd.conf

  echo_magenta "Installation des paquets de DOVECOT"
  verbose apt-get -qq -y install dovecot-imapd dovecot-mysql dovecot-sieve dovecot-managesieved

  echo_magenta "Modification des fichiers de configuration de DOVECOT"
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/dovecot.conf > /etc/dovecot/dovecot.conf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/dovecot-sql.conf > /etc/dovecot/dovecot-sql.conf
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/dovecot-dict-sql.conf > /etc/dovecot/dovecot-dict-sql.conf


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
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/spamassassin > /etc/default/spamassassin
  sed -e 's/$domain/'$DOMAIN'/g' -e 's/$mysql_mail_user/'$MAILSERVER_USER'/g' -e 's/$mysql_mail_password/'$MAILSERVER_PASSWORD'/g' /installer/mail-server/local.cf > /etc/spamassassin/local.cf
  sed -e 's/$domain/'$DOMAIN'/g' /installer/mail-server/spamass-milter > /etc/default/spamass-milter
  verbose sa-update


  echo_magenta "Installation des paquets de CLAMAV"
  verbose apt-get -qq -y install clamav-milter

  echo_magenta "Modification des fichiers de configuration de CLAMAV"
  verbose cp /installer/mail-server/clamav-milter.conf /etc/clamav/
  verbose cp /installer/mail-server/clamav-milter /etc/default/
  sed -e 's/$domain/'$DOMAIN'/g' /installer/mail-server/virusaction.sh > /etc/clamav/virusaction.sh
  verbose chown clamav:clamav /etc/clamav/virusaction.sh
  verbose chmod 755 /etc/clamav/virusaction.sh

  echo_magenta "Redémarrage des services"
  verbose service clamav-daemon restart
  verbose service clamav-milter restart
  verbose service spamassassin restart
  verbose service spamass-milter restart
  verbose service postfix restart
  verbose service dovecot restart

fi
