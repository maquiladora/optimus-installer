#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get -qq -y install keyboard-configuration
apt-get -qq -y install cryptsetup cryptsetup-bin
/sbin/cryptsetup --batch-mode luksFormat /dev/sda2
sleep 1
/sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
sleep 1
/sbin/mkfs.ext4 /dev/mapper/cryptsda2
sleep 1
mount /dev/mapper/cryptsda2 /srv
