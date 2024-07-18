#!/bin/bash

# Take one argument from the commandline: VM name
if ! [ $# -eq 2 ]; then
    echo "Usage: $0 <image> <hostname>"
    echo "ie: install.sh d12.raw hp00"
    exit 1
fi

dd if=/run/archiso/bootmnt/images/$1 of=/dev/sda bs=1M status=progress

printf "fix\n" | parted ---pretend-input-tty /dev/sda print
parted -s /dev/sda -- mkpart "" fat32 -4M -1
mkdosfs -F 32 -n CIDATA /dev/sda2
mount /dev/sda2 /mnt

cat > /mnt/meta-data << _EOF_
instance-id: $2
local-hostname: $2
_EOF_

sleep 7

shutdown now