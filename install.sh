#!/bin/bash
if [ ! -f ~/uid ]
then
  </dev/urandom tr -dc A-Z0-9 | head -c${1:-16} > ~/uid
fi

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
