#!/bin/bash

# Take one argument from the commandline: VM name TODO
if ! [ $# -eq 2 ]; then
    echo "Usage: $0 <input_img> <outputname>"
    echo "ie: $0 d12-kube.raw usb"
    exit 1
fi

INPUT_IMG=$1
OUTPUT_NAME=$2

DEVICE=/dev/loop0
ROOTFS="/tmp/installing-rootfs"

cp $INPUT_IMG $OUTPUT_NAME.raw
losetup -D 
losetup -fP $OUTPUT_NAME.raw

echo "Mount OS partition"
ROOTFS="/tmp/installing-rootfs"
mkdir -p ${ROOTFS}
mount ${DEVICE}p1 ${ROOTFS}

# hostname
echo $OUTPUT_NAME > ${ROOTFS}/etc/hostname

mkdir /usbdata

# fstab
if ! grep -q 'usbdata' ${ROOTFS}/etc/fstab ; then   
  echo '#usbdata' >> ${ROOTFS}/etc/fstab 
  echo 'LABEL=USBDATA    /usbdata    vfat    defaults    0    0' >> ${ROOTFS}/etc/fstab
fi

# flash script
cp ./flash-nocloud-online.sh ${ROOTFS}/usr/local/bin/flash-nocloud-online.sh
chmod 755 ${ROOTFS}/usr/local/bin/flash-nocloud-online.sh

echo "Unmounting filesystems"
umount ${ROOTFS}

losetup -D 


