#!/bin/bash

apt-get -qq -y install cryptsetup
cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 cryptsda2
mkfs.ext4 /dev/mapper/cryptsda2
mount /dev/mapper/cryptsda2 /srv
