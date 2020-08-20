#!/bin/bash
source /etc/allspark/functions.sh

DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes update
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

update_conf LAST_UPGRADE $(date +'%Y%m%d')
