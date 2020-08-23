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
  question=${3}
  valeur=${4}

  if [ $type ] && [ $type = "uuid" ] && [ "${!variable}" = "auto" ]
  then
    valeur=$(</dev/urandom tr -dc A-Z0-9 | head -c 16)
  elif [ $type ] && [ $type = "password" ] && [ "${!variable}" = "auto" ]
  then
    valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 32)
  elif [ $type ] && [ $type = "aeskey" ] && [ "${!variable}" = "auto" ]
  then
    valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 16)
  elif [ $type ] && [ $type = "deskey" ] && [ "${!variable}" = "auto" ]
  then
    valeur=$(</dev/urandom tr -dc A-Za-z0-9 | head -c 24)
  elif [ -z ${!variable} ]
  then
    echo_green "$question"
    if [ $type = "yesno" ]
    then
      while [ -z "$valeur" ]
      do
        read -p "(o)ui / (n)on ? " -n 1 -e valeur
        if [[ $valeur =~ ^[YyOo]$ ]]
        then
          valeur="Y"
        elif [[ $valeur =~ ^[nN]$ ]]
        then
          valeur="N"
        else
          echo_red "Réponse invalide"
        fi
      done
    else
      read valeur
    fi
  fi

  if [ ! -z $valeur ]
  then
    update_conf $variable $valeur
    source /root/.allspark
  fi
)
