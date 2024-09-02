
1. Expert install
2. Format btrfs
3. `CTRL + ALT + F2` to access shell

```bash
umount /target/boot/efi/
umount /target/
mount /dev/sda2 /mnt
cd /mnt
mv @root @
btrfs subvolume create './@home'
mount -o rw,noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@ /dev/sda2 /target

mkdir -p /target/boot/efi
mkdir -p /target/home

mount -o rw,noatime,space_cache=v2,compress=zstd,ssd,discard=async,subvol=@home /dev/sda2 /target/home
mount /dev/sda1 /target/boot/efi/

nano /target/etc/fstab


```
3. `CTRL + ALT + F1` to access shell


