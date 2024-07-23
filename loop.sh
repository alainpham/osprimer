#!/bin/bash

if ! [ $# -eq 1 ]; then
    echo "Usage: $0  <outputname>"
    echo "ie: $0 usb.raw"
    exit 1
fi

DEVICE=/dev/loop0
ROOTFS="/tmp/installing-rootfs"

losetup -D 
losetup -fP $1

# mount image for chroot
echo "Mount OS partition"
mkdir -p ${ROOTFS}
mount ${DEVICE}p1 ${ROOTFS}
mount ${DEVICE}p15 ${ROOTFS}/boot/efi

echo "Get ready for chroot"
mount --bind /dev ${ROOTFS}/dev
mount --bind /run ${ROOTFS}/run

mount -t devpts /dev/pts ${ROOTFS}/dev/pts
mount -t proc proc ${ROOTFS}/proc
mount -t sysfs sysfs ${ROOTFS}/sys
mount -t tmpfs tmpfs ${ROOTFS}/tmp
