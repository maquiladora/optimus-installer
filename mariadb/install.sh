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
  #verbose mariadb -u root -e "SET PASSWORD for 'root'@'localhost' = PASSWORD('test');FLUSH PRIVILEGES;"

  if [ ! $MARIADB_REMOTEACCESS ]; then echo_green "Voulez-vous autoriser la connexion à distance ?"; read -p "(o)ui / (n)on ? " -n 1 -e MARIADB_REMOTEACCESS; fi
  if [[ $MARIADB_REMOTEACCESS =~ ^[YyOo]$ ]]
  then
    if [ $(which /sbin/ufw) ]; then verbose /sbin/ufw allow 3309; fi
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/#port                   = 3306/port                    = 3309/g' /etc/mysql/mariadb.conf.d/50-server.cnf
    verbose mariadb -u root -ptest -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY 'test' WITH GRANT OPTION;"
  fi

  echo_magenta "Le serveur MARIADB a été installé avec succès !"

fi
