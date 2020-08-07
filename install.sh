#!/bin/bash
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes update
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes remove cryptsetup-initramfs
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes install git

sudo rm -R /installer
sudo mkdir /installer
sudo git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer

source /installer/config.sh
if [ $DOMAIN ]; then echo $DOMAIN > /etc/hostname; fi

if ! grep -q "sudo /installer/menu.sh" ~/.bashrc
then
  echo "sudo /installer/menu.sh" >> ~/.bashrc
fi

sudo chmod +x /installer/menu.sh
