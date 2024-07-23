#!/bin/bash
set -e

if ! [ $# -eq 5 ]; then
    echo "Usage: $0 <INPUT_IMG> <OUTPUT_IMAGE> <TARGET_USERNAME> <TARGET_PASSWD> <AUTHSSHFILE>"
    echo "ie: $0 noble-server-cloudimg-amd64.raw ub-min.raw apham password authorized_keys"
    exit 1
fi

export KEYBOARD_LAYOUT=fr

# Map input parameters
export INPUT_IMG=$1
export OUTPUT_IMAGE=$2
export TARGET_USERNAME=$3
export TARGET_PASSWD=$4
export AUTHSSHFILE=$5

# name devices
export DEVICE=/dev/loop0
export ROOTFS="/tmp/installing-rootfs"

# resize image
cp $INPUT_IMG $OUTPUT_IMAGE



# setup loopback
losetup -D 
losetup -fP $OUTPUT_IMAGE

# mount image for chroot
echo "Mount OS partition"
mkdir -p ${ROOTFS}
mount ${DEVICE}p1 ${ROOTFS}

echo "Get ready for chroot"
mount --bind /dev ${ROOTFS}/dev
mount --bind /run ${ROOTFS}/run

mount -t devpts /dev/pts ${ROOTFS}/dev/pts
mount -t proc proc ${ROOTFS}/proc
mount -t sysfs sysfs ${ROOTFS}/sys
mount -t tmpfs tmpfs ${ROOTFS}/tmp

export TARGET_ENCRYPTED_PASSWD=$(openssl passwd -6 -salt xyz $TARGET_PASSWD)
# create user and setup ssh
echo "chroot setup users"
cat << EOF | chroot ${ROOTFS}
    useradd -m -s /bin/bash $TARGET_USERNAME
    echo '${TARGET_USERNAME}:${TARGET_ENCRYPTED_PASSWD}' | sudo chpasswd -e
    echo 'root:${TARGET_ENCRYPTED_PASSWD}' | sudo chpasswd -e
    echo '${TARGET_USERNAME} ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/nopwd
EOF

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.ssh/
cp $AUTHSSHFILE ${ROOTFS}/home/$TARGET_USERNAME/.ssh/

cat << EOF | chroot ${ROOTFS}
    chown $TARGET_USERNAME:$TARGET_USERNAME -R /home/$TARGET_USERNAME/.ssh
EOF


echo "lower log volume"
cat << EOF | chroot ${ROOTFS}
    sed -i 's/.SystemMaxUse=/SystemMaxUse=50M/g' /etc/systemd/journald.conf
EOF

echo "install essentials"
cat << EOF | chroot ${ROOTFS}
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git tmux vim curl wget rsync ncdu dnsutils bmon ntp ntpstat htop bash-completion gpg whois containerd haveged
    DEBIAN_FRONTEND=noninteractive apt install -y cloud-guest-utils openssh-server console-setup
EOF

cat << EOF | chroot ${ROOTFS}
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
EOF

# setup keyboard
cat <<EOF | sudo tee ${ROOTFS}/etc/default/keyboard
# KEYBOARD CONFIGURATION FILE

# Consult the keyboard(5) manual page.

XKBMODEL="pc105"
XKBLAYOUT="${KEYBOARD_LAYOUT}"
# XKBVARIANT=""
# XKBOPTIONS=""

# BACKSPACE="guess"
EOF



echo "cleaning up"
cat << EOF | chroot ${ROOTFS}
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOF


echo "Unmounting filesystems"
umount ${ROOTFS}/{dev/pts,dev,run,proc,sys,tmp,}

losetup -D
