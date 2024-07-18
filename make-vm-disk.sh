#!/bin/bash

# Take one argument from the commandline: VM name
if ! [ $# -eq 6 ]; then
    echo "Usage: $0 <input_img> <outputname> <size> <ip> <gateway> <dns>"
    echo "ie: $0 d12-kube.raw sandbox 30G 192.168.199.10/24 192.168.199.1 1.1.1.1"
    exit 1
fi



INPUT_IMG=$1
OUTPUT_NAME=$2
SIZE=$3
IP=$4
GATEWAY=$5
DNS=$6

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

# netplan static ip
cat << EOF > ${ROOTFS}/etc/netplan/01-netcfg.yaml
network:
    version: 2
    ethernets:
        all-en:
            match:
                name: en*
            dhcp4: true
            addresses:
              - $IP
            routes:
              - to: default
                via: $GATEWAY
            nameservers:
              addresses: [$DNS]
            dhcp4-overrides:
                use-domains: true
            dhcp6: false
            dhcp6-overrides:
                use-domains: true
        all-eth:
            match:
                name: eth*
            dhcp4: true
            addresses:
              - $IP
            routes:
              - to: default
                via: $GATEWAY
            nameservers:
              addresses: [$DNS]
            dhcp4-overrides:
                use-domains: true
            dhcp6: false
            dhcp6-overrides:
                use-domains: true
EOF

echo "Unmounting filesystems"
umount ${ROOTFS}

losetup -D 


qemu-img convert -f raw -O qcow2 $OUTPUT_NAME.raw $OUTPUT_NAME.qcow2
qemu-img resize -f qcow2 $OUTPUT_NAME.qcow2 $SIZE
qemu-img convert -f qcow2 -O vpc $OUTPUT_NAME.qcow2 $OUTPUT_NAME.vhd


