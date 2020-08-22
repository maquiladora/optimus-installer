#!/bin/bash
source /etc/allspark/functions.sh

echo_magenta "Mise à jour du système (UPDATE + UPGRADE + DIST UPGRADE)"

DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y update
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

update_conf LAST_UPGRADE $(date +'%Y%m%d')
