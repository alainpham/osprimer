#!/bin/bash

DEVICE=/dev/loop0
ROOTFS="/tmp/installing-rootfs"

echo "Unmounting filesystems"
umount ${ROOTFS}/{dev/pts,boot/efi,dev,run,proc,sys,tmp,}

losetup -D

