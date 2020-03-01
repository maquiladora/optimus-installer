#!/bin/bash

apt-get -qq -y install cryptsetup cryptsetup-bin
/sbin/cryptsetup luksFormat /dev/sda2
/sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
/sbin/mkfs.ext4 /dev/mapper/cryptsda2
mount /dev/mapper/cryptsda2 /srv
