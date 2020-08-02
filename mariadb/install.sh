source /installer/functions.sh
source /installer/config.sh

if [ ! $MARIADB_AREYOUSURE ]; then echo_green "Souhaitez vous installer le serveur de bases de données MARIADB ?"; read -p "(o)ui / (n)on ? " -n 1 -e MARIADB_AREYOUSURE; fi
if [[ $MARIADB_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Installation du serveur MARIADB..."

  debconf-set-selections <<< 'mariadb-server mysql-server/root_password password hopla'
  debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password hopla'
  verbose apt-get -qq -y install mariadb-server

  verbose systemctl stop mariadb

  if [ ! -d "/srv/databases" ]
  then
    verbose mv /var/lib/mysql /srv
    verbose mv /srv/mysql /srv/databases
    verbose ln -s /srv/databases /var/lib/mysql
  fi

  verbose systemctl start mariadb

  echo_magenta "Le serveur MARIADB a été installé avec succès !"

fi
