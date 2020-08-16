#!/bin/bash


echo_red()(echo -e "\e[31m${1}\e[0m")
echo_green()(echo -e "\e[32m${1}\e[0m")
echo_yellow()(echo -e "\e[33m${1}\e[0m")
echo_blue()(echo -e "\e[34m${1}\e[0m")
echo_magenta()(echo -e "\e[35m${1}\e[0m")
echo_cyan()(echo -e "\e[36m${1}\e[0m")


if [ $1 ]
then
  if [ ! -f /root/.allspark ] && [ -f $1 ]
  then
    cp $1 /root/.allspark
  else
    if [ -f $1 ]
    then
      echo_green "Souhaitez vous remplacer votre fichier de configuration par le fichier $1 ?"
      read -p "(o)ui / (n)on ? " -n 1 -e replace_config
      if [[ $replace_config =~ ^[YyOo]$ ]]
      then
        cp $1 /root/.allspark
      fi
    else
      echo_red "Le fichier $1 n'existe pas !"
      exit 1
    fi
  fi
fi

if [ ! -f /root/.allspark ]
then
  cp /installer/config.sh /root/.allspark
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

    if [ $variable == 'DOMAIN' ]; then echo $valeur > /etc/hostname; fi

    if grep -q "$variable=" /root/.allspark
    then
      verbose sed -i "s/$variable=/$variable=$valeur/g" /root/.allspark
    else
      echo "export $variable=$valeur"  >> /root/.allspark
    fi
  fi
)
