
Make sure everything is unmounted

```bash
export ROOTFS="/tmp/installing-rootfs"
sudo umount ${ROOTFS}/{dev/pts,boot/efi,boot,dev,run,proc,sys,tmp,}
sudo losetup -D 
```

Mount for debug
```bash
export DEVICE=/dev/loop0
export ROOTFS="/tmp/installing-rootfs"
export INPUT_IMG=usb.raw
sudo losetup -fP $INPUT_IMG
sudo mkdir -p ${ROOTFS}
sudo mount ${DEVICE}p1 ${ROOTFS}
sudo mount ${DEVICE}p15 ${ROOTFS}/boot/efi

```

Build image


```bash
rm debian-12-nocloud-amd64.raw
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.raw

baremetal fullgui:    sudo ./build.sh 1 0 apham ps authorized_keys 1 1 1 1 1 debian-12-nocloud-amd64.raw d12-fgui.raw 5G
cloud fullgui:        sudo ./build.sh 0 1 apham ps authorized_keys 1 1 1 1 0 debian-12-nocloud-amd64.raw d12-fgui.raw 5G
cloud full:           sudo ./build.sh 0 1 apham ps authorized_keys 1 1 0 1 0 debian-12-nocloud-amd64.raw d12-full.raw 5G
cloud image min:      sudo ./build.sh 0 1 apham ps authorized_keys 0 0 0 1 0 debian-12-nocloud-amd64.raw d12-mini.raw 3G
cloud image kube:     sudo ./build.sh 0 1 apham ps authorized_keys 0 1 0 1 0 debian-12-nocloud-amd64.raw d12-kube.raw 4G


scp d12-full.raw awon:/home/apham/apps/static/data
scp d12-mini.raw awon:/home/apham/apps/static/data
scp d12-kube.raw awon:/home/apham/apps/static/data
```

create qcow and vhd images

```bash
sudo ./make-vm-disk.sh  d12-mini.raw    dns     6G  192.168.199.2/24
sudo ./make-vm-disk.sh  d12-full.raw    sb      30G dhcp

```

create usb livedisk

```bash
sudo ./make-usb.sh d12-min.raw usb
qemu-img convert -f raw -O vpc usb.raw usb.vhd

```


# installing on machine

```sh
wget https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/setup
chmod 755 setup

# debian on gcp
sudo ./setup gcpvm apham

# workstation with virtualisation deactivate nouveau
sudo ./setup wkstatvrt apham

# 
sudo ./setup wkstatvrt apham

```