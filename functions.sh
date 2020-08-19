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
      echo_red "Cette opération écrasera tous vos paramètres antérieurs !"
      read -p "(o)ui / (n)on ? " -n 1 -e replace_config
      if [[ $replace_config =~ ^[YyOo]$ ]]
      then
        cp $1 /root/.allspark
        echo_magenta "Le fichier de configuration a bien été remplacé !"
        exit 0
      fi
    else
      echo_red "Le fichier $1 n'existe pas !"
      exit 1
    fi
  fi
fi

if [ ! -f /root/.allspark ]
then
  cp /etc/allspark/config.sh /root/.allspark
fi

source /root/.allspark


if [ -z $DISKPART_DISK_TO_PART ]
then
  if [ -e /dev/nvme0n1 ]
  then
    export DISKPART_DISK_TO_PART=nvme0n1
    export PART_TO_ENCRYPT=nvme0n1p2
  else
    if [ -e /dev/sda ]
    then
      export DISKPART_DISK_TO_PART=sda
      export PART_TO_ENCRYPT=sda2
    fi
  fi
  update_conf DISKPART_DISK_TO_PART $DISKPART_DISK_TO_PART
  update_conf PART_TO_ENCRYPT $PART_TO_ENCRYPT
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


update_conf()
(
  if grep -q "$1=" /root/.allspark
  then
    verbose sed -i "/export $1=/c export $1=$2" /root/.allspark
  else
    echo "export $1=$2"  >> /root/.allspark
  fi
)


require()
(
  variable=${1}
  type=${2}
  valeur=

  if [ -z ${!variable} ]
  then

    if [ $type ] && [ $type == 'uuid' ]
    then
      if [ ! $AUTOGENERATE_UUID ]; then echo_green "Souhaitez vous générer l'identifiant unique $variable automatiquement ?"; read -p "(o)ui / (n)on ? " -n 1 -e AUTOGENERATE_UUID; fi
      if [[ $AUTOGENERATE_UUID =~ ^[YyOo]$ ]]
      then
        valeur=$(</dev/urandom tr -dc A-Z0-9 | head -c 16)
      fi
    fi

    if [ $type ] && [ $type == 'password' ]
    then
      if [ ! $AUTOGENERATE_PASSWORDS ]; then echo_green "Souhaitez vous générer le mot de passe $variable automatiquement ?"; read -p "(o)ui / (n)on ? " -n 1 -e AUTOGENERATE_PASSWORDS; fi
      if [[ $AUTOGENERATE_PASSWORDS =~ ^[YyOo]$ ]]
      then
        valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 32)
      fi
    fi

    if [ $type ] && [ $type == 'aeskey' ]
    then
      if [ ! $AUTOGENERATE_AES_KEY ]; then echo_green "Souhaitez vous générer la clé AES $variable automatiquement ?"; read -p "(o)ui / (n)on ? " -n 1 -e AUTOGENERATE_AES_KEY; fi
      if [[ $AUTOGENERATE_AES_KEY =~ ^[YyOo]$ ]]
      then
        valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 16)
      fi
    fi

    if [ -z $valeur ]
    then
      echo_green "Merci de renseigner la variable $variable :"
      read valeur
    fi

    update_conf $variable $valeur
  fi
)
