
Make sure everything is unmounted

```bash
export ROOTFS="/tmp/installing-rootfs"
sudo umount ${ROOTFS}/{dev/pts,boot,dev,run,proc,sys,tmp,}
sudo losetup -D 
```

Mount for debug
```bash
export DEVICE=/dev/loop0
export ROOTFS="/tmp/installing-rootfs"
export INPUT_IMG=d12-full.raw
sudo losetup -fP $INPUT_IMG
sudo mkdir -p ${ROOTFS}
sudo mount ${DEVICE}p1 ${ROOTFS}
```

Build image

```bash
cp debian-12-nocloud-amd64.raw d12-full.raw
sudo ./build.sh d12-full.raw apham password authorized_keys 1 1

scp d12-full.raw awon:/home/apham/apps/static/data
```

create qcow and vhd images

```bash
sudo ./make-vm-disk.sh d12-full.raw sb 30G 172.29.123.10/20
```
