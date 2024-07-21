#!/bin/bash

# Take one argument from the commandline: VM name
if ! [ $# -eq 4 ]; then
    echo "Usage: $0 <input_img> <outputname> <size> <ip>"
    echo "ie: $0 d12-kube.raw sandbox 30G 172.29.123.10/20"
    exit 1
fi

INPUT_IMG=$1
OUTPUT_NAME=$2
SIZE=$3
IP=$4

DEVICE=/dev/loop0
ROOTFS="/tmp/installing-rootfs"

cp $INPUT_IMG $OUTPUT_NAME.raw
losetup -D 
losetup -fP $OUTPUT_NAME.raw

echo "Mount OS partition"
ROOTFS="/tmp/installing-rootfs"
mkdir -p ${ROOTFS}
mount ${DEVICE}p1 ${ROOTFS}

echo $OUTPUT_NAME > ${ROOTFS}/etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1 ${OUTPUT_NAME}/g" ${ROOTFS}/etc/hosts

# ifupdown 
cat << EOF > ${ROOTFS}/etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
  address $IP
  gateway $GATEWAY
  dns-nameservers $DNS
EOF


# netplan static ip
rm ${ROOTFS}/etc/netplan/*
cat << EOF > ${ROOTFS}/etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      dhcp6: false
    eth1:
      dhcp4: false
      dhcp6: false
      addresses:
        - $IP
EOF

echo "Unmounting filesystems"
umount ${ROOTFS}

losetup -D 


qemu-img convert -f raw -O qcow2 $OUTPUT_NAME.raw $OUTPUT_NAME.qcow2
qemu-img resize -f qcow2 $OUTPUT_NAME.qcow2 $SIZE
qemu-img convert -f qcow2 -O vpc $OUTPUT_NAME.qcow2 $OUTPUT_NAME.vhd


