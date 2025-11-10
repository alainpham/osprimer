```sh

cfdisk


mkfs.fat -F 32 /dev/vda1
fatlabel /dev/vda1 NIXBOOT
mkfs.ext4 /dev/vda2 -L NIXROOT

mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

nixos-enter --root /mnt -c 'passwd apham'


```

nix