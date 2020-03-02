#!/bin/bash

DEBIAN_FRONTEND=noninteractive apt-get -qq -y install keyboard-configuration
apt-get -qq -y install cryptsetup cryptsetup-bin
/sbin/cryptsetup --batch-mode luksFormat /dev/sda2
/sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
/sbin/mkfs.ext4 /dev/mapper/cryptsda2
/sbin/cryptsetup luksClose /dev/mapper/cryptsda2
