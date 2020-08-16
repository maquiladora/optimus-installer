#!/bin/bash
if [ ! -f /root/allspark/config.sh ]
then
  mkdir -p /root/allspark
  cp /installer/config.sh /root/.allspark/.config.sh
fi

if [ $1 ]
then
  echo $1
  source $1
else
  source /root/.allspark/.config.sh
fi


verbose()
(
  if [ $VERBOSE = 1 ]
  then
    (set -o pipefail;"$@" 2>&1>&3|sed $'s,.*,\e[31m&\e[m,'>&2)3>&1
  elif [ $VERBOSE = 2 ]
  then
    set -o pipefail;"$@" 2> >(sed $'s,.*,\e[31m&\e[m,'>&2) 1>/dev/null
  elif [ $VERBOSE = 3 ]
  then
    set -o pipefail;"$@" &>/dev/null
  fi
)


echo_red()(echo -e "\e[31m${1}\e[0m")
echo_green()(echo -e "\e[32m${1}\e[0m")
echo_yellow()(echo -e "\e[33m${1}\e[0m")
echo_blue()(echo -e "\e[34m${1}\e[0m")
echo_magenta()(echo -e "\e[35m${1}\e[0m")
echo_cyan()(echo -e "\e[36m${1}\e[0m")


require()
(
  variable=${1}
  type=${2}
  valeur=

  if [ ! ${!variable} ]
  then

    if [ $type ] && [ $type == 'uuid' ]
    then
      echo_green "Souhaitez vous générer l'identifiant unique $variable automatiquement ?"
      read -p "(o)ui / (n)on ? " -n 1 -e generate_uuid
      if [[ $generate_uuid =~ ^[YyOo]$ ]]
      then
        valeur=$(</dev/urandom tr -dc A-Z0-9 | head -c 16)
      fi
    fi

    if [ $type ] && [ $type == 'password' ]
    then
      echo_green "Souhaitez vous générer le mot de passe $variable automatiquement ?"
      read -p "(o)ui / (n)on ? " -n 1 -e generate_pwd
      if [[ $generate_pwd =~ ^[YyOo]$ ]]
      then
        valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 32)
      fi
    fi

    if [ $type ] && [ $type == 'aeskey' ]
    then
      echo_green "Souhaitez vous générer la clé AES $variable automatiquement ?"
      read -p "(o)ui / (n)on ? " -n 1 -e generate_aes
      if [[ $generate_aes =~ ^[YyOo]$ ]]
      then
        valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 16)
      fi
    fi

    if [ ! $valeur ]
    then
      echo_green "Merci de renseigner la variable $variable :"
      read valeur
    fi

    if [ $type == 'domain' ] then echo $valeur > /etc/hostname; fi

    sed -i "/$variable=/d" /root/allspark/config.sh
    echo "export $variable=$valeur"  >> /root/allspark/config.sh
  fi
)
