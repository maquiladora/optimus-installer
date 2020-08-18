#!/bin/bash
rm -R /etc/allspark
mkdir /etc/allspark
git clone -b vest https://github.com/MetallianFR68/optimus-installer /etc/allspark
chmod +x /etc/allspark/menu.sh
source /etc/allspark/menu.sh
