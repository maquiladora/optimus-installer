#!/bin/bash
source /etc/allspark/functions.sh
if [ -z $MODULE_UPGRADE ]; then require MODULE_UPGRADE yesno "Voulez vous mettre à jour le système -> update/upgrade/dist-upgrade ?"; source /root/.allspark; fi
source /root/.allspark

if [ $MODULE_UPGRADE = "Y" ]
then
  echo_green "==== MISE A JOUR DU SYSTEME ===="

  echo_magenta "Update"
  DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y update

  echo_magenta "Upgrade"
  DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade

  echo_magenta "Dist-Upgrade"
  DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

  update_conf LAST_UPGRADE $(date +'%Y%m%d')
fi
