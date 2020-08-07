source /installer/functions.sh
source /installer/config.sh

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
  verbose systemctl start mariadb

  echo_magenta "Le serveur MARIADB a été installé avec succès !"
fi

echo
echo_green "==== CONNEXION A DISTANCE A LA BASE DE DONNEES ===="
if [ ! $MARIADB_REMOTEACCESS ]; then echo_green "Voulez-vous autoriser la connexion à distance ?"; read -p "(o)ui / (n)on ? " -n 1 -e MARIADB_REMOTEACCESS; fi
if [[ $MARIADB_REMOTEACCESS =~ ^[YyOo]$ ]]
then
  if [ ! $MARIADB_REMOTE_ROOT_PASSWORD ]
  then
    echo_green "Voulez vous générer un mot de passe automatiquement ?"
    read -n 1 -p "(o)ui / (n)on ? " -e MARIADB_REMOTE_ROOT_PASSWORD_GENERATE
    if [[$MARIADB_REMOTE_ROOT_PASSWORD_GENERATE =~ ^[YyOo]$ ]]
    then
      MARIADB_REMOTE_ROOT_PASSWORD=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
    else
      echo_magenta "Veuillez renseigner le mot de passe de l'utilisateur ROOT distant : "
      read MARIADB_REMOTE_ROOT_PASSWORD;
    fi
  fi

  if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 3306; fi
  sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
  verbose mariadb -u root -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY '$MARIADB_REMOTE_ROOT_PASSWORD' WITH GRANT OPTION;"
  verbose systemctl restart mariadb
  echo_magenta "L'accès à distance à la base de données MARIADB a été ouvert avec succès sur le port 3306 !"
  echo_magenta "Le mot de passe de l'utilisateur ROOT distant est : "
  echo_cyan $MARIADB_REMOTE_ROOT_PASSWORD
fi
