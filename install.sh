#!/bin/bash

if [ ! -f /root/uid ]
then
  </dev/urandom tr -dc A-Z0-9 | head -c${1:-16} > /root/uid
fi

sudo apt-get -qq update
sudo apt-get -qq upgrade
sudo apt-get -qq remove cryptsetup-initramfs
sudo apt-get -qq install git

rm -R /installer
mkdir /installer
git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer

if ! grep -q "source /installer/menu.sh" /root/.bashrc
then
  echo "source /installer/menu.sh" >> /root/.bashrc
fi

chmod +x /installer/menu.sh
source /installer/menu.sh
