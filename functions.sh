#!/bin/bash

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
  value=''

  if [ ! ${!variable} ]
  then
    if [ $type == 'password' ]
    then
      echo_green "Souhaitez vous générer un mot de passe automatiquement ?"
      read -p "(o)ui / (n)on ? " -n 1 -e generate
      if [[ $generate =~ ^[YyOo]$ ]]
      then
        value=$(</dev/urandom tr -dc A-Za-z0-9 | head -c${1:-32})
      fi
    fi

    if [ ! $value ]
    then
      echo_green 'Merci de renseigner la variable "$variable" :'
      read $value
    fi

    echo "$variable=$value"
  fi
)
