#!/bin/bash

apt-get update
apt-get -qq -y install git
cd /
rm -R /installer
mkdir /installer
git clone -b vest https://github.com/MetallianFR68/optimus-installer /installer
sleep(2)
cd /installer
chmod +x menu.sh
./menu.sh
