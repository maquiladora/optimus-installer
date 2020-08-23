#!/bin/bash
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes update
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes remove cryptsetup-initramfs
DEBIAN_FRONTEND=noninteractive sudo apt-get -qq --yes install git unzip zip sudo

sudo rm -R /etc/allspark
sudo mkdir /etc/allspark
sudo git clone -b vest https://github.com/MetallianFR68/optimus-installer /etc/allspark

sudo timedatectl set-timezone Europe/Paris

if ! grep -q "sudo /etc/allspark/menu.sh" /root/.bashrc
then
  sudo echo "sudo /etc/allspark/menu.sh" >> /root/.bashrc
fi

if ! grep -q "sudo /etc/allspark/menu.sh" /home/debian/.bashrc
then
  sudo echo "sudo /etc/allspark/menu.sh" >> /home/debian/.bashrc
fi

sudo chmod +x /etc/allspark/menu.sh
