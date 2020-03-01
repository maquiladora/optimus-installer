#!/bin/bash
apt-get update
apt-get -qq -y install git
rm -R /installer
mkdir /installer
git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer
chmod +x /installer/menu.sh
source /installer/menu.sh
