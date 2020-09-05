#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_MARIADB ]; then require MODULE_MARIADB yesno "Voulez-vous installer le serveur de bases de données MARIADB"; source /root/.allspark; fi
if [ -z $MODULE_MARIADB_REMOTE_ACCESS ]; then require MODULE_MARIADB_REMOTE_ACCESS yesno "Voulez-vous autoriser la connexion à distance à la base de données ?"; source /root/.allspark; fi
if [ -z $MARIADB_REMOTE_ROOT_PASSWORD ] || [ $MARIADB_REMOTE_ROOT_PASSWORD = "auto" ]; then require MARIADB_REMOTE_ROOT_PASSWORD password "Veuillez renseigner le mot de passe de connexion à distance de l'utilisateur 'root' :"; source /root/.allspark; fi
if [ -z $MARIADB_ADMIN_USER ]; then require MARIADB_ADMIN_USER string "Veuillez renseigner le nom de l'administrateur MARIADB :"; source /root/.allspark; fi
if [ -z $MARIADB_ADMIN_PASSWORD ] || [ $MARIADB_ADMIN_PASSWORD = "auto" ]; then require MARIADB_ADMIN_PASSWORD password "Veuillez renseigner le mot de passe de l'administrateur MARIADB :"; source /root/.allspark; fi
if [ -z $AES_KEY ] || [ $AES_KEY = "auto" ]; then require AES_KEY aeskey "Veuillez renseigner une clé de chiffrement AES de 16 caractères [A-Za-z0-9]"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_MARIADB = "Y" ]
then

  echo
  echo_green "==== INSTALLATION DU SERVEUR DE BASES DE DONNEES MARIADB ===="

  echo_magenta "Installation des paquets requis"
  verbose apt-get -qq -y install mariadb-server
  verbose systemctl stop mariadb

  echo_magenta "Création des dossiers"
  if [ ! -d "/srv/databases" ]
  then
    verbose mv /var/lib/mysql /srv
    verbose mv /srv/mysql /srv/databases
    verbose ln -s /srv/databases /var/lib/mysql
  fi
  sleep 0.5

  echo_magenta "Démarrage du service"
  verbose systemctl start mariadb

  echo_magenta "Installation de la base de données 'users'"
  for file in /etc/allspark/mariadb/*.sql
  do
    file="${file:22:-4}"
    if [[ $file > $MARIADB_DB_VERSION ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /etc/allspark/mariadb/$file.sql
      update_conf MARIADB_DB_VERSION $file
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done

  echo_magenta "Creation de l'utilisateur 'admin'"
  verbose mariadb -u root -e "INSERT IGNORE INTO users.users VALUES ('1', '1', '$MARIADB_ADMIN_USER', AES_ENCRYPT('$MARIADB_ADMIN_PASSWORD','$AES_KEY'), '$(date +"%F %T")', null, null, null);"
  verbose mariadb -u root -e "ALTER TABLE users.users AUTO_INCREMENT = 9;"


  if [[ $MODULE_MARIADB_REMOTE_ACCESS =~ ^[YyOo]$ ]]
  then
    echo_magenta "Activation de la connexion à distance sur le port 3306 pour l'utilisateur root"
    if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 3306; fi
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
    verbose mariadb -u root -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY '$MARIADB_REMOTE_ROOT_PASSWORD' WITH GRANT OPTION;"
  else
    echo_magenta "Désactication de la connexion à distance sur le port 3306 pour l'utilisateur root"
    if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw deny 3306; fi
    sed -i 's/0.0.0.0/127.0.0.1/g' /etc/mysql/mariadb.conf.d/50-server.cnf
    verbose mariadb -u root -e "DENY ALL ON *.* to 'root'@'%' IDENTIFIED BY '$MARIADB_REMOTE_ROOT_PASSWORD' WITH GRANT OPTION;"
  fi

  echo_magenta "Redémarrage des services"
  verbose systemctl restart mariadb

fi
