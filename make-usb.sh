#!/bin/bash

# Take one argument from the commandline: VM name TODO
if ! [ $# -eq 2 ]; then
    echo "Usage: $0 <input_img> <outputname>"
    echo "ie: $0 d12-min.raw usb"
    exit 1
fi

INPUT_IMG=$1
OUTPUT_NAME=$2

DEVICE=/dev/loop0
ROOTFS="/tmp/installing-rootfs"

cp $INPUT_IMG $OUTPUT_NAME.raw
losetup -D 
losetup -fP $OUTPUT_NAME.raw

# change partition uuid
e2fsck -f ${DEVICE}p1
tune2fs -U "4011286f-c983-4f7b-9a28-4156be37c584" ${DEVICE}p1 
sudo mlabel -N AAAA1111 -i ${DEVICE}p15  ::

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

# change boot root efi uuid
echo "Change boot root efi uuid"
sed -i 's/search.fs_uuid.*/search.fs_uuid 4011286f-c983-4f7b-9a28-4156be37c584 root/g' ${ROOTFS}/boot/efi/EFI/debian/grub.cfg
sed -i 's/search.fs_uuid.*/search.fs_uuid 4011286f-c983-4f7b-9a28-4156be37c584 root/g' ${ROOTFS}/boot/grub/i386-pc/load.cfg
sed -i 's/search.fs_uuid.*/search.fs_uuid 4011286f-c983-4f7b-9a28-4156be37c584 root/g' ${ROOTFS}/boot/grub/x86_64-efi/load.cfg


# change GRUB_DISABLE_LINUX_UUID
sed -i 's/GRUB_DISABLE_LINUX_UUID=.*/GRUB_DISABLE_LINUX_UUID=false/g' ${ROOTFS}/etc/default/grub.d/10_cloud.cfg
sed -i 's/GRUB_DISABLE_LINUX_PARTUUID=.*/GRUB_DISABLE_LINUX_PARTUUID=true/g' ${ROOTFS}/etc/default/grub.d/10_cloud.cfg

# change fstab
echo "UUID=4011286f-c983-4f7b-9a28-4156be37c584 / ext4 rw,discard,errors=remount-ro,x-systemd.growfs 0 1" > ${ROOTFS}/etc/fstab
echo "UUID=AAAA-1111 /boot/efi vfat defaults 0 0" >> ${ROOTFS}/etc/fstab

# update grub
cat << EOF | chroot ${ROOTFS}
    update-grub
EOF

# hostname
echo $OUTPUT_NAME > ${ROOTFS}/etc/hostname

mkdir -p ${ROOTFS}/usbdata

echo 'LABEL=USBDATA    /usbdata    vfat    defaults    0    0' >> ${ROOTFS}/etc/fstab



# flash script
cp ./flash-nocloud-online.sh ${ROOTFS}/usr/local/bin/flash-nocloud-online.sh
chmod 755 ${ROOTFS}/usr/local/bin/flash-nocloud-online.sh

echo "Unmounting filesystems"
umount ${ROOTFS}/{dev/pts,boot/efi,dev,run,proc,sys,tmp,}

losetup -D

