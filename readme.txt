
dd if=/run.. of=/dev/sda bs=1M status=progress

fix partition :

sgdisk -e /dev/sda

parted -s /dev/sda -- mkpart "" fat32 4MiB -1s
mkdosfs -F 32 -n CIDATA /dev/sda2