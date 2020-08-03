#!/bin/bash

if [ ! -f /root/uid ]
then
  </dev/urandom tr -dc A-Z0-9 | head -c${1:-16} > /root/uid
fi

sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
sudo apt-get --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt-get --yes --force-yes remove cryptsetup-initramfs
sudo apt-get --yes --force-yes install git

rm -R /installer
mkdir /installer
git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer

if ! grep -q "source /installer/menu.sh" /root/.bashrc
then
  echo "source /installer/menu.sh" >> /root/.bashrc
fi

chmod +x /installer/menu.sh
source /installer/menu.sh
