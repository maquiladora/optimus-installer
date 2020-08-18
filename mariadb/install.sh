source /etc/allspark/functions.sh
require MARIADB_ADMIN_USER
require MARIADB_ADMIN_PASSWORD password
require MARIADB_REMOTE_ROOT_PASSWORD password
require AES_KEY aeskey
source /root/.allspark

echo
echo_green "==== INSTALLATION DU SERVEUR DE BASES DE DONNEES MARIADB ===="
if [ ! $MARIADB_AREYOUSURE ]; then echo_green "Souhaitez vous installer le serveur de bases de données MARIADB ?"; read -p "(o)ui / (n)on ? " -n 1 -e MARIADB_AREYOUSURE; fi
if [[ $MARIADB_AREYOUSURE =~ ^[YyOo]$ ]]
then
  echo_magenta "Installation du serveur MARIADB..."

  verbose apt-get -qq -y install mariadb-server
  verbose systemctl stop mariadb
  if [ ! -d "/srv/databases" ]
  then
    verbose mv /var/lib/mysql /srv
    verbose mv /srv/mysql /srv/databases
    verbose ln -s /srv/databases /var/lib/mysql
  fi
  sleep 0.5

  echo_magenta "Démarrage du service..."
  verbose systemctl start mariadb

  echo_magenta "Installation de la base de donnée 'users'"
  for file in /etc/allspark/mariadb/*.sql
  do
    file="${file:22:-4}"
    if [[ $file > $db_version ]]
    then
      echo_magenta "--> $file.sql exécuté"
      mariadb < /etc/allspark/mariadb/$file.sql
      echo $file > /srv/databases/USERS_DB_VERSION
    else
      echo_magenta "--> $file.sql ignoré"
    fi
  done

  echo_magenta "Creation de l'utilisateur 'admin'"
  verbose mariadb -u root -e "INSERT IGNORE INTO users.users VALUES ('1', '1', '$MARIADB_ADMIN_USER', AES_ENCRYPT('$MARIADB_ADMIN_PASSWORD','$AES_KEY'), '$(date +"%F %T")', null, null, null);"
fi

echo
echo_green "==== CONNEXION A DISTANCE A LA BASE DE DONNEES ===="
if [ ! $MARIADB_REMOTEACCESS ]; then echo_green "Voulez-vous autoriser la connexion à distance ?"; read -p "(o)ui / (n)on ? " -n 1 -e MARIADB_REMOTEACCESS; fi
if [[ $MARIADB_REMOTEACCESS =~ ^[YyOo]$ ]]
then
  if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 3306; fi
  sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
  verbose mariadb -u root -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY '$MARIADB_REMOTE_ROOT_PASSWORD' WITH GRANT OPTION;"
  verbose systemctl restart mariadb
  echo_magenta "L'accès à distance à la base de données MARIADB a été ouvert avec succès sur le port 3306 !"
  echo_magenta "Le mot de passe de l'utilisateur ROOT distant est : "
  echo_cyan $MARIADB_REMOTE_ROOT_PASSWORD
fi
