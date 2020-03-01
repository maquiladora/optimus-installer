#!/bin/bash

/sbin/cryptsetup luksOpen /dev/sda2 cryptsda2
mount /dev/mapper/cryptsda2 /srv
