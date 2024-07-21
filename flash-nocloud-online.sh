#!/bin/bash

# Take one argument from the commandline: VM name
if ! [ $# -eq 2 ]; then
    echo "Usage: $0 <image> <hostname>"
    echo "ie: $0 http://192.168.8.100:8787/d12-kube.raw hp00"
    exit 1
fi

export TARGET_HOSTNAME=$2

wget -qO- $1 | dd of=/dev/sda bs=1M status=progress

mount /dev/sda1 /mnt

echo $TARGET_HOSTNAME > /mnt/etc/hostname

umount /mnt

sleep 7

shutdown now