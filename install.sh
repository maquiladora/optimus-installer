#!/bin/bash
if [ ! -f /root/uid ]
then
  </dev/urandom tr -dc A-Z0-9 | head -c${1:-16} > /root/uid
fi

DEBIAN_FRONTEND=noninteractive sudo apt-get --yes update
DEBIAN_FRONTEND=noninteractive sudo apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
DEBIAN_FRONTEND=noninteractive sudo apt-get --yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
DEBIAN_FRONTEND=noninteractive sudo apt-get --yes remove cryptsetup-initramfs
DEBIAN_FRONTEND=noninteractive sudo apt-get --yes install git

sudo rm -R /installer
sudo mkdir /installer
sudo git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer

sudo source /installer/config.sh
if [ $DOMAIN ]; then echo $DOMAIN > /etc/hostname; fi

if ! grep -q "source /installer/menu.sh" /root/.bashrc
then
  echo "source /installer/menu.sh" >> /root/.bashrc
fi

sudo chmod +x /installer/menu.sh
sudo source /installer/menu.sh
