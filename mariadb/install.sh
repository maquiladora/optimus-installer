source /installer/functions.sh
source /installer/config.sh

if [ ! $MARIADB_AREYOUSURE ]; then echo_green "Souhaitez vous installer le serveur de bases de données MARIADB ?"; read -p "(o)ui / (n)on ? " -n 1 -e MARIADB_AREYOUSURE; fi
if [[ $MARIADB_AREYOUSURE =~ ^[YyOo]$ ]]
then

  echo_magenta "Installation du serveur MARIADB..."

  if [ ! -d "/srv/databases" ]; then verbose mkdir /srv/databases; fi

  debconf-set-selections <<< 'mysql-server mysql-server/root_password password hopla'
  debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password hopla'
  debconf-set-selections <<< 'mysql-community-server mysql-community-server/data-dir /srv/databases'
  verbose apt-get -qq -y install mariadb-server

  #verbose sed -i 's/\/var\/lib\/mysql/\/srv\/databases/g' /etc/mysql/mariadb.conf.d/50-server.cnf

  #verbose chown mysql:mysql /srv/databases
  #verbose chmod +755 /srv/databases

  echo_magenta "Le serveur MARIADB a été installé avec succès !"

fi
