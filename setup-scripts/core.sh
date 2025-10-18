#!/bin/bash
# this is a script to install raw vm images, baremetal machines/laptops or cloud vms

inputversions() {
    trap 'return 1' ERR

    export CORE_VERSION=20251009
    echo "export CORE_VERSION=${CORE_VERSION}"

    # https://kubernetes.io/releases/  https://cloud.google.com/kubernetes-engine/docs/release-notes
    export MAJOR_KUBE_VERSION=v1.33
    echo "export MAJOR_KUBE_VERSION=${MAJOR_KUBE_VERSION}"
    
    # https://github.com/k3s-io/k3s/releases
    export K3S_VERSION="v1.33.5+k3s1"
    echo "export K3S_VERSION=${MAJOR_KUBE_VERSION}"

    # https://github.com/derailed/k9s/releases
    export K9S_VERSION=v0.50.15
    echo "export K9S_VERSION=${K9S_VERSION}"
    
    # https://maven.apache.org/download.cgi
    export MVN_VERSION=3.9.11
    echo "export MVN_VERSION=${MVN_VERSION}"

    export NERDFONTS="Noto "
    echo "export NERDFONTS=${NERDFONTS}"
    
    ### Corporate software
    # https://zoom.us/download?os=linux 
    export ZOOM_VERSION=6.5.11.4015
    echo "export ZOOM_VERSION=${ZOOM_VERSION}"

    # https://hub.docker.com/r/infinityofspace/certbot_dns_duckdns/tags
    export CERTBOT_DUCKDNS_VERSION=v1.6
    echo "export CERTBOT_DUCKDNS_VERSION=${CERTBOT_DUCKDNS_VERSION}"

    ### appimages
    # https://mlv.app/
    export MLVAPP_VERSION=1.15
    echo "export MLVAPP_VERSION=${MLVAPP_VERSION}"

    # https://beeref.org/
    export BEEREF_VERSION=0.3.3
    echo "export BEEREF_VERSION=${BEEREF_VERSION}"

    # https://www.freac.org/downloads-mainmenu-33
    export FREAC_VERSION=1.1.7
    echo "export FREAC_VERSION=${FREAC_VERSION}"

    # https://github.com/jgraph/drawio-desktop/releases
    export DRAWIO_VERSION=28.2.5
    echo "export DRAWIO_VERSION=${DRAWIO_VERSION}"

    # https://www.onlyoffice.com/download-desktop.aspx
    export ONLYOFFICE_VERSION=v9.0.4
    echo "export ONLYOFFICE_VERSION=${ONLYOFFICE_VERSION}"

    # https://kdenlive.org/download/ 
    export KDENLIVE_MAIN_VERSION=25.08
    echo "export KDENLIVE_MAIN_VERSION=${KDENLIVE_MAIN_VERSION}"
    export KDENLIVE_FULL_VERSION=25.08.2
    echo "export KDENLIVE_FULL_VERSION=${KDENLIVE_FULL_VERSION}"
    # https://heldercorreia.bitbucket.io/speedcrunch/download.html
    export SPEEDCRUNCH_VERSION=0.12
    echo "export SPEEDCRUNCH_VERSION=${SPEEDCRUNCH_VERSION}"

    # https://www.videohelp.com/software/AviDemux
    export AVIDEMUX_VERSION=2.8.1
    echo "export AVIDEMUX_VERSION=${AVIDEMUX_VERSION}"

    # https://github.com/localsend/localsend/releases
    export LOCALSEND_VERSION=1.17.0
    echo "export LOCALSEND_VERSION=${LOCALSEND_VERSION}"

    ## end appimages

    # https://github.com/yshui/picom/releases
    export PICOM_VERSION=12.5
    echo "export PICOM_VERSION=${PICOM_VERSION}"

    # https://github.com/Hummer12007/brightnessctl/releases
    export BRIGHTNESSCTL_VERSION=0.5.1
    echo "export BRIGHTNESSCTL_VERSION=${BRIGHTNESSCTL_VERSION}"

    # https://github.com/naelstrof/slop/releases
    export SLOP_VERSION=7.7
    echo "export SLOP_VERSION=${SLOP_VERSION}"

    # https://github.com/naelstrof/maim/releases
    export MAIM_VERSION=5.8.1
    echo "export MAIM_VERSION=${MAIM_VERSION}"
    # https://gitlab.com/es-de/emulationstation-de/-/releases https://gitlab.com/es-de/emulationstation-de/-/package_files/210210324/download
    export ESDE_VERSION=3.3.0
    echo "export ESDE_VERSION=${ESDE_VERSION}"
    export ESDE_VERSION_ID=210210324
    echo "export ESDE_VERSION_ID=${ESDE_VERSION_ID}"

    # https://buildbot.libretro.com/stable/
    export RETROARCH_VERSION=1.21.0
    echo "export RETROARCH_VERSION=${RETROARCH_VERSION}"

    # https://github.com/moonlight-stream/moonlight-qt/releases/
    export MOONLIGHT_VERSION=6.1.0
    echo "export MOONLIGHT_VERSION=${MOONLIGHT_VERSION}" 

    # https://github.com/LizardByte/Sunshine/releases
    export SUNSHINE_VERSION=2025.924.154138
    echo "export SUNSHINE_VERSION=${SUNSHINE_VERSION}" 

    #  https://github.com/PCSX2/pcsx2/releases/latest
    export PCSX2_VERSION=2.4.0
    echo "export PCSX2_VERSION=${PCSX2_VERSION}" 

    # https://github.com/cemu-project/Cemu/releases/latest
    export CEMU_VERSION=2.6
    echo "export CEMU_VERSION=${CEMU_VERSION}" 


    export OSNAME=$(awk -F= '/^ID=/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
    echo "export OSNAME=${OSNAME}"

    export OSVERSION=$(awk -F= '/^VERSION_ID=/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
    echo "export OSVERSION=${OSVERSION}"

    export PRODUCT_NAME=$(dmidecode -t 1 | grep 'Product Name:' | sed 's/.*Product Name: //')
    echo "export PRODUCT_NAME=${PRODUCT_NAME}"

    export TIMEZONE="Europe/Paris"
    echo "export TIMEZONE=${TIMEZONE}"

    export APT_PROXY="http://192.168.8.100:3142"
    echo "export APT_PROXY=${APT_PROXY}"
}


inputtasks() {
    trap 'return 1' ERR

    #default root
    
    export ROOTFS=/
    echo "export ROOTFS=${ROOTFS}"

    # Map input parameters
    export TARGET_USERNAME=${1:-apham}
    echo "export TARGET_USERNAME=${TARGET_USERNAME}"
    
    export TARGET_PASSWD=$2
    echo "export TARGET_PASSWD=${TARGET_PASSWD}"
    
    export AUTHSSHFILE=$3
    echo "export AUTHSSHFILE=${AUTHSSHFILE}"
    
    export INPUT_IMG=$4
    echo "export INPUT_IMG=${INPUT_IMG}"
    
    export OUTPUT_IMAGE=$5
    echo "export OUTPUT_IMAGE=${OUTPUT_IMAGE}"
    
    export DISK_SIZE=$6
    echo "export DISK_SIZE=${DISK_SIZE}"

    export KEYBOARD_LAYOUT=${7:-fr}
    echo "export KEYBOARD_LAYOUT=${KEYBOARD_LAYOUT}"

    # for macbook use value "macbook79"
    export KEYBOARD_MODEL=${8:-pc105} 
    echo "export KEYBOARD_MODEL=${KEYBOARD_MODEL}"
}


bashaliases() {
trap 'return 1' ERR

scripts="lineinfile"
for script in $scripts ; do
wget -O ${ROOTFS}/usr/local/bin/$script https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/utils/$script
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/$script
EOF
done

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ] || [ "$OSNAME" = "opensuse-tumbleweed" ] ; then
    export BASHRC="/etc/bash.bashrc"
fi

if [ "$OSNAME" = "alpine" ]; then
    export BASHRC="/etc/bash/bashrc"
fi

if [ "$OSNAME" = "openmandriva" ]; then
    export BASHRC="/etc/bashrc"
cat << EOF | chroot ${ROOTFS}
    ln -sf /usr/bin/vim /usr/bin/vi
EOF
fi

lineinfile ${ROOTFS}${BASHRC} ".*alias.*ll.*=.*" 'alias ll="ls -larth"'
lineinfile ${ROOTFS}${BASHRC} ".*alias.*ap=.*" 'alias ap=ansible-playbook'


lineinfile ${ROOTFS}${BASHRC} ".*export.*ROOTFS*=.*" 'export ROOTFS=\/'
lineinfile ${ROOTFS}${BASHRC} ".*export.*TARGET_USERNAME*=.*" "export TARGET_USERNAME=${TARGET_USERNAME}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MAJOR_KUBE_VERSION*=.*" "export MAJOR_KUBE_VERSION=${MAJOR_KUBE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*K3S_VERSION*=.*" "export K3S_VERSION=${K3S_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*K9S_VERSION*=.*" "export K9S_VERSION=${K9S_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MVN_VERSION*=.*" "export MVN_VERSION=${MVN_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*NERDFONTS*=.*" "export NERDFONTS=\"${NERDFONTS}\""
lineinfile ${ROOTFS}${BASHRC} ".*export.*ZOOM_VERSION*=.*" "export ZOOM_VERSION=${ZOOM_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MLVAPP_VERSION*=.*" "export MLVAPP_VERSION=${MLVAPP_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*BEEREF_VERSION*=.*" "export BEEREF_VERSION=${BEEREF_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*FREAC_VERSION*=.*" "export FREAC_VERSION=${FREAC_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*DRAWIO_VERSION*=.*" "export DRAWIO_VERSION=${DRAWIO_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*CERTBOT_DUCKDNS_VERSION*=.*" "export CERTBOT_DUCKDNS_VERSION=${CERTBOT_DUCKDNS_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*ONLYOFFICE_VERSION*=.*" "export ONLYOFFICE_VERSION=${ONLYOFFICE_VERSION}"

lineinfile ${ROOTFS}${BASHRC} ".*export.*PICOM_VERSION*=.*" "export PICOM_VERSION=${PICOM_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*BRIGHTNESSCTL_VERSION*=.*" "export BRIGHTNESSCTL_VERSION=${BRIGHTNESSCTL_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SLOP_VERSION*=.*" "export SLOP_VERSION=${SLOP_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MAIM_VERSION*=.*" "export MAIM_VERSION=${MAIM_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KDENLIVE_MAIN_VERSION*=.*" "export KDENLIVE_MAIN_VERSION=${KDENLIVE_MAIN_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KDENLIVE_FULL_VERSION*=.*" "export KDENLIVE_FULL_VERSION=${KDENLIVE_FULL_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SPEEDCRUNCH_VERSION*=.*" "export SPEEDCRUNCH_VERSION=${SPEEDCRUNCH_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*AVIDEMUX_VERSION*=.*" "export AVIDEMUX_VERSION=${AVIDEMUX_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*LOCALSEND_VERSION*=.*" "export LOCALSEND_VERSION=${LOCALSEND_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*ESDE_VERSION*=.*" "export ESDE_VERSION=${ESDE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*ESDE_VERSION_ID*=.*" "export ESDE_VERSION_ID=${ESDE_VERSION_ID}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*RETROARCH_VERSION*=.*" "export RETROARCH_VERSION=${RETROARCH_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MOONLIGHT_VERSION*=.*" "export MOONLIGHT_VERSION=${MOONLIGHT_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SUNSHINE_VERSION*=.*" "export SUNSHINE_VERSION=${SUNSHINE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*PCSX2_VERSION*=.*" "export PCSX2_VERSION=${PCSX2_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*CEMU_VERSION*=.*" "export CEMU_VERSION=${CEMU_VERSION}"


lineinfile ${ROOTFS}${BASHRC} ".*export.*OSNAME*=.*" "export OSNAME=${OSNAME}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*OSVERSION*=.*" "export OSVERSION=${OSVERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*WILDCARD_DOMAIN*=.*" "export WILDCARD_DOMAIN=zez.duckdns.org"
lineinfile ${ROOTFS}${BASHRC} ".*export.*EMAIL*=.*" "export EMAIL=admin@zez.duckdns.org"
lineinfile ${ROOTFS}${BASHRC} ".*export.*DUCKDNS_TOKEN*=.*" "export DUCKDNS_TOKEN=xxxx-xxxx-xxxx-xxxx-xxxx"
lineinfile ${ROOTFS}${BASHRC} ".*export.*PRODUCT_NAME*=.*" "export PRODUCT_NAME='${PRODUCT_NAME}'"
lineinfile ${ROOTFS}${BASHRC} ".*export.*TIMEZONE*=.*" "export TIMEZONE=${TIMEZONE}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KEYBOARD_LAYOUT*=.*" "export KEYBOARD_LAYOUT=${KEYBOARD_LAYOUT}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KEYBOARD_MODEL*=.*" "export KEYBOARD_MODEL=${KEYBOARD_MODEL}"

lineinfile ${ROOTFS}${BASHRC} ".*export.*SYNCTHING_HUB_ADDR*=.*" "export SYNCTHING_HUB_ADDR=tcp://192.168.8.100:22000"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SYNCTHING_HUB_APIURL*=.*" "export SYNCTHING_HUB_APIURL=http://192.168.8.100:8384"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SYNCTHING_HUB_ID*=.*" "export SYNCTHING_HUB_ID=XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SYNCTHING_HUB_APIKEY*=.*" "export SYNCTHING_HUB_APIKEY=X"

lineinfile ${ROOTFS}${BASHRC} ".*export.*APT_PROXY*=.*" "export APT_PROXY='${APT_PROXY}'"

lineinfile ${ROOTFS}${BASHRC} ".*export.*CORE_VERSION*=.*" "export CORE_VERSION='${CORE_VERSION}'"


echo "bash aliases setup finished"
}

mountraw() {
    trap 'return 1' ERR

    # name devices
    export DEVICE=/dev/loop999
    export ROOTFS="/tmp/installing-rootfs"
    # resize image
    cp $INPUT_IMG $OUTPUT_IMAGE
    qemu-img  resize -f raw $OUTPUT_IMAGE $DISK_SIZE

    # setup loopback
    losetup -D 
    losetup -P $DEVICE $OUTPUT_IMAGE

    # fix partition
    printf "fix\n" | parted ---pretend-input-tty $DEVICE print
    growpart ${DEVICE} 1
    e2fsck -f /dev/loop999p1
    resize2fs ${DEVICE}p1

    # mount image for chroot
    echo "Mount OS partition"
    mkdir -p ${ROOTFS}
    mount ${DEVICE}p1 ${ROOTFS}
    mount ${DEVICE}p16 ${ROOTFS}/boot
    mount ${DEVICE}p15 ${ROOTFS}/boot/efi

    echo "Get ready for chroot"
    mount --bind /dev ${ROOTFS}/dev
    mount --bind /run ${ROOTFS}/run

    mv ${ROOTFS}/etc/resolv.conf ${ROOTFS}/etc/resolv.conf.back
    cp /etc/resolv.conf ${ROOTFS}/etc/resolv.conf

    mount -t devpts /dev/pts ${ROOTFS}/dev/pts
    mount -t proc proc ${ROOTFS}/proc
    mount -t sysfs sysfs ${ROOTFS}/sys
    mount -t tmpfs tmpfs ${ROOTFS}/tmp
}

createuser() {
trap 'return 1' ERR

echo "setup users"

if [ "$OSNAME" = "alpine" ]; then
cat << EOF | chroot ${ROOTFS}
    /usr/sbin/adduser -D -s /bin/bash $TARGET_USERNAME
    mkdir -p /home/${TARGET_USERNAME}/.ssh
    chown -R ${TARGET_USERNAME}:${TARGET_USERNAME} /home/${TARGET_USERNAME}/.ssh
EOF
else
cat << EOF | chroot ${ROOTFS}
    /usr/sbin/useradd -m -s /bin/bash $TARGET_USERNAME
    mkdir -p /home/${TARGET_USERNAME}/.ssh
    chown -R ${TARGET_USERNAME}:${TARGET_USERNAME} /home/${TARGET_USERNAME}/.ssh
EOF
fi
}

isshkey(){
trap 'return 1' ERR

cat << EOF | chroot ${ROOTFS}
    if [ ! -f /home/${TARGET_USERNAME}/.ssh/id_rsa ]; then
        ssh-keygen -N "" -f /home/${TARGET_USERNAME}/.ssh/id_rsa
    fi
EOF
}

setpasswd() {
trap 'return 1' ERR

export TARGET_ENCRYPTED_PASSWD=$(openssl passwd -6 -salt xyz $TARGET_PASSWD)
echo "setup users"
cat << EOF | chroot ${ROOTFS}
    echo '${TARGET_USERNAME}:${TARGET_ENCRYPTED_PASSWD}' | /usr/sbin/chpasswd -e
    echo 'root:${TARGET_ENCRYPTED_PASSWD}' | /usr/sbin/chpasswd -e
EOF

}

authkeys() {
trap 'return 1' ERR

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.ssh/
echo "Copy authorized_keys $AUTHSSHFILE"
cp $AUTHSSHFILE ${ROOTFS}/home/$TARGET_USERNAME/.ssh/authorized_keys
cat << EOF | chroot ${ROOTFS}
    chown $TARGET_USERNAME:$TARGET_USERNAME -R /home/$TARGET_USERNAME/.ssh
EOF

echo "Copied authorized_keys"

}

rmnouveau() {
trap 'return 1' ERR

# deactivate nouveau drivers 
sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ {/modprobe.blacklist=nouveau/! s/"$/ modprobe.blacklist=nouveau"/}' ${ROOTFS}/etc/default/grub

update-grub2

echo "Deactivated nouveau drivers"

}

rmbroadcom() {
trap 'return 1' ERR

sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ {/modprobe.blacklist=b43,brcmsmac,wl/! s/"$/ modprobe.blacklist=b43,brcmsmac,wl"/}' ${ROOTFS}/etc/default/grub
update-grub2
echo "Deactivated broadcom drivers"
}

fastboot() {
trap 'return 1' ERR

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ] || [ "$OSNAME" = "opensuse-tumbleweed" ] ; then
# accelerate grub startup
mkdir -p ${ROOTFS}/etc/default/grub.d/
echo 'GRUB_TIMEOUT=1' | tee ${ROOTFS}/etc/default/grub.d/15_timeout.cfg
lineinfile ${ROOTFS}/etc/default/grub ".*GRUB_TIMEOUT=.*" 'GRUB_TIMEOUT=1'

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
grub2-mkconfig -o /boot/efi/EFI/opensuse/grub.cfg
else
update-grub2
fi

fi

if [ "$OSNAME" = "openmandriva" ]; then
echo openmandriva
lineinfile ${ROOTFS}/etc/default/grub ".*GRUB_TIMEOUT=.*" 'GRUB_TIMEOUT=1'

update-grub2
fi



echo "fastboot activated"

}

disableturbo() {
trap 'return 1' ERR

if [ ! -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
    echo "no_turbo file not found, exiting"
    return 0
fi

cat <<'EOF' | tee ${ROOTFS}/usr/local/bin/turboboost.sh
#!/bin/bash
input=$1
if [ "$input" = "no" ]; then
    state=1	
elif [ "$input" = "yes" ]; then
    state=0
elif [ "$input" = "status" ]; then
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        cat /sys/devices/system/cpu/intel_pstate/no_turbo
    else
        echo "no_turbo file not found"
    fi
    exit 0
else
    echo "Usage: turboboost.sh {no|yes|status}"
    exit 1
fi
echo "no_turbo=$state"
if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
    echo $state > /sys/devices/system/cpu/intel_pstate/no_turbo
else
    echo "did nothing, no_turbo file not found"
fi
EOF

chmod 755 ${ROOTFS}/usr/local/bin/turboboost.sh


if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then

cat <<EOF | tee ${ROOTFS}/etc/systemd/system/disable-intel-turboboost.service
[Unit]
Description=Disable Intel Turbo Boost using pstate driver 
[Service]
ExecStart=/bin/sh -c "/usr/local/bin/turboboost.sh no"
ExecStop=/bin/sh -c "/usr/local/bin/turboboost.sh yes"
RemainAfterExit=yes
[Install]
WantedBy=sysinit.target
EOF

cat << EOF | chroot ${ROOTFS}
    systemctl enable disable-intel-turboboost.service
EOF
fi


if [ "$OSNAME" = "devuan" ]; then

cat <<'EOF' | tee ${ROOTFS}/etc/init.d/disable-intel-turboboost
#!/bin/sh
### BEGIN INIT INFO
# Provides:          disable-intel-turboboost
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Intel Turbo Boost using pstate driver
### END INIT INFO

case "$1" in
  start)
    echo "Disabling Intel Turbo Boost..."
    /usr/local/bin/turboboost.sh no
    ;;
  stop)
    echo "Enabling Intel Turbo Boost..."
    /usr/local/bin/turboboost.sh yes
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  status)
    echo "Turbo Boost control script : no_turbo state"
    /usr/local/bin/turboboost.sh status
    ;;
  *)
    echo "Usage: /etc/init.d/disable-intel-turboboost {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
EOF

chmod 755 ${ROOTFS}/etc/init.d/disable-intel-turboboost

cat << EOF | chroot ${ROOTFS}
    update-rc.d disable-intel-turboboost defaults
EOF

fi

}

firstbootexpandfs() {
trap 'return 1' ERR

# first boot script
cat << 'EOF' | tee ${ROOTFS}/usr/local/bin/firstboot.sh
#!/bin/bash
if [ ! -f /var/log/firstboot.log ]; then
    if lsblk | grep -q vda; then
        DEVICE="/dev/vda"
    elif lsblk | grep -q sda; then
        DEVICE="/dev/sda"
    else
        DEVICE="/dev/sda"
    fi
    # Code to execute if log file does not exist
    echo "First boot script has run">/var/log/firstboot.log
    growpart $DEVICE 1
    resize2fs ${DEVICE}1
fi
EOF

chmod 755 ${ROOTFS}/usr/local/bin/firstboot.sh

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
cat <<EOF | tee ${ROOTFS}/etc/systemd/system/firstboot.service
[Unit]
Description=firstboot
Requires=network.target
After=network.target

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/firstboot.sh
RemainAfterExit=yes


[Install]
WantedBy=multi-user.target
EOF

cat << EOF | chroot ${ROOTFS}
    systemctl enable firstboot.service
EOF
fi

if [ "$OSNAME" = "devuan" ]; then
cat <<'EOF' | tee ${ROOTFS}/etc/init.d/firstboot
#!/bin/sh
### BEGIN INIT INFO
# Provides:          firstboot
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Expand filesystem on first boot
### END INIT INFO

case "$1" in
  start)
    /usr/local/bin/firstboot.sh
    ;;
  stop)
    echo "Firstboot script has run"
    ;;
  *)
    echo "Usage: /etc/init.d/firstboot {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

chmod 755 ${ROOTFS}/etc/init.d/firstboot

cat << EOF | chroot ${ROOTFS}
    update-rc.d firstboot defaults
EOF
fi

echo "firstboot script activated"
}

smalllogs() {
trap 'return 1' ERR

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
lineinfile ${ROOTFS}/etc/systemd/journald.conf ".*SystemMaxUse=.*" "SystemMaxUse=50M"
echo "lower log volume activated"
fi
}

reposrc() {
trap 'return 1' ERR

if [ "$OSNAME" = "debian" ]; then
echo "setup apt"
cat <<EOF > ${ROOTFS}/etc/apt/sources.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF

echo "apt sources setup finished"
fi

if [ "$OSNAME" = "ubuntu" ]; then
echo "TODO : apt sources setup finished"
fi

if [ "$OSNAME" = "alpine" ]; then
cat <<EOF | tee ${ROOTFS}/etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
EOF
fi


if [ "$OSNAME" = "devuan" ]; then
echo "setup apt"

if [ "$OSVERSION" = "4" ]; then
cat <<EOF > ${ROOTFS}/etc/apt/sources.list
deb http://deb.devuan.org/merged chimaera main non-free contrib
deb http://deb.devuan.org/merged chimaera-security main non-free contrib
deb http://deb.devuan.org/merged chimaera-updates main non-free contrib
EOF
else
cat <<EOF > ${ROOTFS}/etc/apt/sources.list
deb http://deb.devuan.org/merged daedalus main non-free-firmware non-free contrib
deb http://deb.devuan.org/merged daedalus-security main non-free-firmware non-free contrib
deb http://deb.devuan.org/merged daedalus-updates main non-free-firmware non-free contrib
EOF
fi

fi


if [ "$OSNAME" = "openmandriva" ]; then

rm -f ${ROOTFS}/etc/yum.repos.d/*

    if [ "$OSVERSION" = "5.0" ]; then
        curl -Lo ${ROOTFS}/etc/yum.repos.d/openmandriva-rock-x86_64.repo https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/om/openmandriva-rock-x86_64.repo
    else
        curl -Lo ${ROOTFS}/etc/yum.repos.d/openmandriva-rolling-x86_64.repo https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/om/openmandriva-rolling-x86_64.repo
    fi
fi

}

iaptproxy() {
trap 'return 1' ERR

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | tee ${ROOTFS}/etc/apt/apt.conf.d/99proxy
Acquire::HTTP::Proxy "${APT_PROXY}";
Acquire::HTTPS::Proxy "false";
EOF
fi
}

iessentials() {
trap 'return 1' ERR

# Essentials packages
echo "install essentials"

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt -y update 
    apt install -y ncurses-term
    apt -y upgrade
    apt install -y sudo git tmux vim curl wget rsync ncdu dnsutils bmon htop btop bash-completion gpg whois haveged zip unzip virt-what wireguard iptables jq jc sshfs iotop wakeonlan
    apt install -y systemd-timesyncd
    DEBIAN_FRONTEND=noninteractive apt install -y cloud-guest-utils openssh-server console-setup iperf3
EOF
fi

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << EOF | chroot ${ROOTFS}
zypper refresh
zypper update
zypper install -y ncurses
zypper install -y sudo git tmux vim curl wget rsync ncdu bind-utils bmon htop btop bash-completion gpg whois haveged zip unzip virt-what wireguard-tools iptables jq jc sshfs iotop

EOF
fi

if [ "$OSNAME" = "alpine" ]; then
cat << EOF | chroot ${ROOTFS}
apk add ncurses
apk update
apk upgrade
apk add sudo git tmux vim curl wget rsync ncdu btop bash-completion gpg whois zip unzip virt-what wireguard-tools iptables jq jc sshfs iotop envsubst
apk add chrony
apk add cloud-utils-growpart openssh-server iperf3
EOF
fi


if [ "$OSNAME" = "devuan" ]; then
cat << EOF | chroot ${ROOTFS}
    apt -y update 
    apt install -y ncurses-term
    apt -y upgrade
    apt install -y sudo git tmux vim curl wget rsync ncdu dnsutils bmon htop btop bash-completion gpg whois haveged zip unzip virt-what wireguard iptables jq jc sshfs iotop wakeonlan
    DEBIAN_FRONTEND=noninteractive apt install -y cloud-guest-utils openssh-server console-setup iperf3
EOF
fi

# deactivate unattended upgrades
if [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | tee ${ROOTFS}/etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then


    if [ "$OSVERSION" = "5.0" ]; then
cat << EOF | chroot ${ROOTFS}
dnf clean -y all ; dnf -y repolist
dnf -y upgrade
EOF
    else
cat << EOF | chroot ${ROOTFS}
dnf clean -y all ; dnf -y repolist
dnf -y --allowerasing distro-sync
EOF
    fi



# cat << EOF | chroot ${ROOTFS}
#     dnf clean all ; dnf repolist
#     dnf upgrade
# EOF

cat << EOF | chroot ${ROOTFS}
    dnf install -y ncurses-extraterms gettext
    dnf install -y sudo git tmux vim curl wget rsync ncdu bind-utils htop bash-completion gnupg2 whois zip unzip virt-what wireguard-tools iptables jq sshfs iotop
    dnf install -y cloud-utils openssh-server console-setup
EOF
fi


# configure git to use vim as editor
cat << EOF | tee ${ROOTFS}/home/${TARGET_USERNAME}/.gitconfig
[core]
    editor = vim
EOF

echo "essentials installed"
}

isudo() {
trap 'return 1' ERR

cat << EOF | chroot ${ROOTFS}
    echo '${TARGET_USERNAME} ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee' visudo -f /etc/sudoers.d/nopwd
EOF

echo "sudo setup finished"
}

allowsshpwd() {
trap 'return 1' ERR

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' ${ROOTFS}/etc/ssh/sshd_config
}

ikeyboard() {
trap 'return 1' ERR

# setup keyboard
cat <<EOF | tee ${ROOTFS}/etc/default/keyboard
XKBMODEL="${KEYBOARD_MODEL}"
XKBLAYOUT="${KEYBOARD_LAYOUT}"
EOF
echo "keyboard setup finished"

}


itouchpad(){
trap 'return 1' ERR

mkdir -p ${ROOTFS}/etc/X11/xorg.conf.d/

cat <<EOF | tee ${ROOTFS}/etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "touchpad catchall"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "false"
EndSection
EOF

cd /tmp/
rm -rf libinput-gestures
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
./libinput-gestures-setup install

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt -y install libinput-tools wmctrl
    adduser $TARGET_USERNAME input
EOF
fi

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << EOF | chroot ${ROOTFS}
    zypper install -y libinput-tools wmctrl
    usermod -aG input $TARGET_USERNAME
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    usermod -aG input $TARGET_USERNAME
EOF
fi

mkdir -p ${ROOTFS}/home/${TARGET_USERNAME}/.config/

cat <<EOF | tee ${ROOTFS}/home/${TARGET_USERNAME}/.config/libinput-gestures.conf
gesture swipe up        xdotool key super+m
gesture swipe down      xdotool key super+t
gesture swipe left      3 xdotool key alt+Left
gesture swipe left      4 xdotool key super+Left
gesture swipe right     3 xdotool key alt+Right
gesture swipe right     4 xdotool key super+Right
gesture pinch in        xdotool key ctrl+minus
gesture pinch out       xdotool key ctrl+plus
EOF

cat << EOF | chroot ${ROOTFS}
    chown $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config
    chown $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/libinput-gestures.conf
EOF


}

idev(){
trap 'return 1' ERR

force_reinstall=${1:-0}

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y ansible openjdk-17-jdk-headless npm golang-go
EOF

export JAVA_HOME_TARGET=/usr/lib/jvm/java-17-openjdk-amd64
lineinfile ${ROOTFS}/etc/bash.bashrc ".*export.*JAVA_HOME*=.*" "export JAVA_HOME=${JAVA_HOME_TARGET}"

echo "java home setup finished"
fi

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << EOF | chroot ${ROOTFS}
    zypper install -y ansible java-17-openjdk-devel npm go
EOF

export JAVA_HOME_TARGET=/usr/lib64/jvm/java-17-openjdk
lineinfile ${ROOTFS}/etc/bash.bashrc ".*export.*JAVA_HOME*=.*" "export JAVA_HOME=${JAVA_HOME_TARGET}"

echo "java home setup finished"
fi

if [ "$OSNAME" = "alpine" ]; then
cat << EOF | chroot ${ROOTFS}
    apk add ansible openjdk17 nodejs go
EOF

export JAVA_HOME_TARGET=/usr/lib/jvm/default-jvm
lineinfile ${ROOTFS}/etc/bash/bashrc ".*export.*JAVA_HOME*=.*" "export JAVA_HOME=${JAVA_HOME_TARGET}"

echo "java home setup finished"
fi



if [ "$OSNAME" = "openmandriva" ]; then

cat << EOF | chroot ${ROOTFS}
    dnf install -y ansible java-17-openjdk-devel npm golang
EOF

export JAVA_HOME_TARGET=/usr/lib/jvm/java-17-openjdk
lineinfile ${ROOTFS}/etc/bashrc ".*export.*JAVA_HOME*=.*" "export JAVA_HOME=${JAVA_HOME_TARGET}"
lineinfile ${ROOTFS}/etc/bashrc ".*export.*PATH*=.*" "export PATH=\$PATH:${JAVA_HOME_TARGET}/bin"

fi

imaven $force_reinstall

}

imaven() {
trap "return 1" ERR

force_reinstall=${1:-0}

if [ -f "${ROOTFS}/opt/appimages/apache-maven-${MVN_VERSION}/bin/mvn" ] && [ "$force_reinstall" = "0" ]; then
    echo "maven already installed, skipping"
    return 0
fi

mkdir -p ${ROOTFS}/opt/appimages/
rm -rf ${ROOTFS}/opt/appimages/apache-maven-*
curl -L -o /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
tar xzvf /tmp/maven.tar.gz  -C ${ROOTFS}/opt/appimages/
cat << EOF | chroot ${ROOTFS}
    ln -sf /opt/appimages/apache-maven-${MVN_VERSION}/bin/mvn /usr/local/bin/mvn
EOF
rm -f /tmp/maven.tar.gz
echo "maven installed"

}


idocker() {
trap 'return 1' ERR

force_reinstall=${1:-0}

echo "install docker"

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y docker.io python3-docker docker-compose skopeo docker-buildx
EOF

mkdir -p ${ROOTFS}/etc/docker

cat <<EOF | tee ${ROOTFS}/etc/docker/daemon.json
{
  "log-opts": {
    "max-size": "10m",
    "max-file": "2" 
  }
}
EOF
echo "docker logs configured"

cat << EOF | chroot ${ROOTFS}
    adduser $TARGET_USERNAME docker
EOF
fi

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << EOF | chroot ${ROOTFS}
    zypper install -y docker python3-docker docker-compose skopeo docker-buildx
    systemctl enable docker
    systemctl start docker
    usermod -aG docker $TARGET_USERNAME
EOF
fi

if [ "$OSNAME" = "alpine" ]; then
apk add docker docker-cli-compose docker-cli-buildx
adduser $TARGET_USERNAME docker
rc-update add docker default
mkdir -p /etc/docker
cat <<EOF | tee ${ROOTFS}/etc/docker/daemon.json
{
  "log-opts": {
    "max-size": "10m",
    "max-file": "2" 
  }
}
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then

cat << EOF | chroot ${ROOTFS}
    dnf install -y docker python-docker docker-compose skopeo docker-buildx
    systemctl enable docker
EOF

cat <<EOF | tee ${ROOTFS}/etc/docker/daemon.json
{
  "iptables": true
}
EOF
echo "docker logs configured"

cat << EOF | chroot ${ROOTFS}
    usermod -aG docker $TARGET_USERNAME
EOF
fi


cat <<'EOF' | tee ${ROOTFS}/usr/local/bin/firstboot-dockernet.sh
#!/bin/bash
echo "firstboot-dockernet.sh : Setting up dedicated network bridge.."

retry=0
max_retries=5
while [ $retry -lt $max_retries ]; do
    if curl -s --unix-socket /var/run/docker.sock http/_ping 2>&1; then
        echo "Docker is running."
        break
    else
        echo "Docker is not running. Retrying in 1 seconds..."
        sleep 1
        retry=$((retry + 1))
    fi
done

if [ $retry -eq $max_retries ]; then
    echo "Docker failed to start after $max_retries attempts."
    exit 1
fi

if [[ -z "$(docker network ls | grep primenet)" ]] then
     docker network create --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 primenet
     echo "firstboot-dockernet.sh : docker primenet created"
     echo "✅ primenet docker network created !">/var/log/firstboot-dockernet.log
else
     echo "firstboot-dockernet.sh : docker primenet exists already"
     echo "✅ primenet already exisits ! ">/var/log/firstboot-dockernet.log
fi

exit 0

EOF

cat <<'EOF' | tee ${ROOTFS}/usr/local/bin/firstboot-dockerbuildx.sh
#!/bin/bash
echo "firstboot-dockerbuildx.sh: Setting up multi target builder"


retry=0
max_retries=5
while [ $retry -lt $max_retries ]; do
    if curl -s --unix-socket /var/run/docker.sock http/_ping 2>&1; then
        echo "Docker is running."
        break
    else
        echo "Docker is not running. Retrying in 1 seconds..."
        sleep 1
        retry=$((retry + 1))
    fi
done

if [ $retry -eq $max_retries ]; then
    echo "Docker failed to start after $max_retries attempts."
    exit 1
fi

if [[ -z "$(docker buildx ls | grep multibuilder.*linux)" ]] then
     docker buildx create --name multibuilder --platform linux/amd64,linux/arm/v7,linux/arm64 --use
     echo "firstboot-dockerbuildx.sh : docker multibuilder created"
     echo "✅ multibuilder docker buildx created !">/var/log/firstboot-dockerbuildx.log
else
     echo "firstboot-dockerbuildx.sh : docker multibuilder exists alread"
     echo "✅ multibuilder already exisits ! ">~/firstboot-dockerbuildx.log
fi

exit 0
EOF

chmod 755 ${ROOTFS}/usr/local/bin/firstboot-dockernet.sh
chmod 755 ${ROOTFS}/usr/local/bin/firstboot-dockerbuildx.sh

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ] || [ "$OSNAME" = "opensuse-tumbleweed" ] ; then
cat <<EOF | tee ${ROOTFS}/etc/systemd/system/firstboot-dockernet.service
[Unit]
Description=firstboot-dockernet
Requires=network.target docker.service
After=network.target docker.service

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/firstboot-dockernet.sh
RemainAfterExit=yes


[Install]
WantedBy=multi-user.target
EOF

cat <<EOF | tee ${ROOTFS}/etc/systemd/system/firstboot-dockerbuildx.service
[Unit]
Description=firstboot-dockerbuildx
Requires=network.target docker.service
After=network.target docker.service

[Service]
Type=oneshot
User=${TARGET_USERNAME}
ExecStart=/usr/local/bin/firstboot-dockerbuildx.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

cat << EOF | chroot ${ROOTFS}
    systemctl enable firstboot-dockernet.service
    systemctl enable firstboot-dockerbuildx.service
EOF
echo "docker network and buildx on first boot service configured"
fi 

if [ "$OSNAME" = "devuan" ]; then
cat <<'EOF' | tee ${ROOTFS}/etc/init.d/firstboot-dockernet
#!/bin/sh
### BEGIN INIT INFO
# Provides:          firstboot-dockernet
# Required-Start:    docker
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Create docker network on first boot
### END INIT INFO

case "$1" in
  start)
    /usr/local/bin/firstboot-dockernet.sh
    ;;
  stop)
    echo "Firstboot script has run"
    ;;
  *)
    echo "Usage: /etc/init.d/firstboot-dockernet {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

cat <<'EOF' | tee ${ROOTFS}/etc/init.d/firstboot-dockerbuildx
#!/bin/sh
### BEGIN INIT INFO
# Provides:          firstboot-dockerbuildx
# Required-Start:    docker
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Create docker buildx on first boot
### END INIT INFO
EOF
cat <<EOF | tee -a ${ROOTFS}/etc/init.d/firstboot-dockerbuildx
case "\$1" in
  start)
    su - ${TARGET_USERNAME} -c /usr/local/bin/firstboot-dockerbuildx.sh
    ;;
  stop)
    echo "Firstboot script has run"
    ;;
  *)
    echo "Usage: /etc/init.d/firstboot-dockerbuildx {start|stop}"
    exit 1
    ;;
esac
EOF

chmod 755 ${ROOTFS}/etc/init.d/firstboot-dockernet
chmod 755 ${ROOTFS}/etc/init.d/firstboot-dockerbuildx

cat << EOF | chroot ${ROOTFS}
    update-rc.d firstboot-dockernet defaults
    update-rc.d firstboot-dockerbuildx defaults
EOF

fi

}

ikube(){
trap 'return 1' ERR

force_reinstall=${1:-0}

if [ -f "${ROOTFS}/usr/local/bin/kubecr" ] && [ "$force_reinstall" = "0" ]; then
    echo "kubecr already installed, skipping"
    return 0
fi

echo "install kube"

curl -Lo ${ROOTFS}/usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/k3s
    ln -sf /usr/local/bin/k3s /usr/local/bin/kubectl
    ln -sf /usr/local/bin/k3s /usr/local/bin/crictl
    ln -sf /usr/local/bin/k3s /usr/local/bin/ctr
EOF

# cat << EOF | chroot ${ROOTFS}
#     curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE="true" INSTALL_K3S_SKIP_START="true" INSTALL_K3S_VERSION="${K3S_VERSION}" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="server --disable=servicelb,traefik" sh -
# EOF

cat << EOF | chroot ${ROOTFS}
    curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 755 /tmp/get_helm.sh
    /tmp/get_helm.sh
EOF

cat << EOF | chroot ${ROOTFS}
    kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
    helm completion bash | tee /etc/bash_completion.d/helm > /dev/null
EOF

curl -fsSL -o /tmp/k9s.tar.gz https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
tar -xzvf /tmp/k9s.tar.gz  -C ${ROOTFS}/usr/local/bin/ k9s
rm /tmp/k9s.tar.gz
cat << EOF | chroot ${ROOTFS}
    chown root:root /usr/local/bin/k9s
EOF

kubescript="kubecr kubecrlocal kubemon kubeotel kubeexpose"
for script in $kubescript ; do
curl -Lo ${ROOTFS}/usr/local/bin/$script https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/k8s/$script
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/$script
EOF
done

}

invidia() {
trap 'return 1' ERR

echo "install nvidia drivers"

cat << EOF | chroot ${ROOTFS}
    apt install -y nvidia-detect
EOF

export NV_VERSION=$(echo "nvidia-detect  | grep nvidia.*driver | xargs" | chroot ${ROOTFS})

cat << EOF | chroot ${ROOTFS}
    apt install -y $NV_VERSION
EOF

# avoid screen tearing

cat << 'EOF' >> ${ROOTFS}/etc/X11/xorg.conf.d/20-intel.conf
Section "Device"
  Identifier "Intel Graphics"
  Driver "modesetting"
EndSection
EOF

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/picom/
cat << 'EOF' >> ${ROOTFS}/home/$TARGET_USERNAME/.config/picom/picom.conf
backend = "glx";
vsync = true;
use-damage = false
EOF

chown -R $TARGET_USERNAME:$TARGET_USERNAME ${ROOTFS}/home/$TARGET_USERNAME/.config

echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' > ${ROOTFS}/etc/default/grub.d/nvidia-modeset.cfg

cat << EOF | chroot ${ROOTFS}
    update-grub
EOF

cat << EOF | chroot ${ROOTFS}
    systemctl enable nvidia-suspend.service
    systemctl enable nvidia-hibernate.service
    systemctl enable nvidia-resume.service
EOF
echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1' > ${ROOTFS}/etc/modprobe.d/nvidia-power-management.conf
}


inumlocktty(){
trap 'return 1' ERR

#enable numlock tty
cat <<'EOF' | tee ${ROOTFS}/usr/local/bin/nlock
#!/bin/bash
echo "nlock : activate numlock on tty"
for tty in /dev/tty{1..6}
do
    /usr/bin/setleds -D +num < "$tty";
done
EOF

cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/nlock
EOF

if [ "$OSNAME" = "debian" ] || [ "$OSNAME"  = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
cat <<EOF | tee ${ROOTFS}/etc/systemd/system/nlock.service
[Unit]
Description=nlock

[Service]
ExecStart=/usr/local/bin/nlock
StandardInput=tty
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

cat << EOF | chroot ${ROOTFS}
    systemctl enable nlock
EOF

fi

if [ "$OSNAME" = "devuan" ]; then
cat <<'EOF' | tee ${ROOTFS}/etc/init.d/nlock
#!/bin/sh
### BEGIN INIT INFO
# Provides:          nlock
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

case "$1" in
  start)
    /usr/local/bin/nlock
    ;;
  stop)
    echo "Stopping nlock"
    ;;
  *)
    echo "Usage: /etc/init.d/firstboot {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

cat << EOF | chroot ${ROOTFS}
    chmod 755 /etc/init.d/nlock
    update-rc.d nlock defaults
EOF

fi
# end numlock tty

}

##############################################
########### GUI setup ########################
##############################################

igui() {
trap 'return 1' ERR

force_reinstall=${1:-0}

echo "install gui"
# if pulse replace by this apt install -y pulseaudio
    # apt install -y  pipewire-audio wireplumber pipewire-pulse pipewire-alsa libspa-0.2-bluetooth pulseaudio-utils qpwgraph pavucontrol

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y make gcc libx11-dev libxft-dev libxrandr-dev libimlib2-dev libfreetype-dev libxinerama-dev xorg numlockx usbutils libsdl2-dev
    apt install -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils pavucontrol alsa-utils
    apt remove -y xserver-xorg-video-intel
EOF
fi

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << EOF | chroot ${ROOTFS}
    zypper install -y make gcc libX11-devel libXft-devel libXrandr-devel imlib2-devel freetype2-devel libXinerama-devel xorg-x11 xorg-x11-server numlockx usbutils SDL2-devel ncurses-devel
    zypper install -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils pavucontrol alsa-utils
EOF
fi
 

if [ "$OSNAME" = "openmandriva" ]; then
#  backup   dnf install -y make clang gcc gcc-c++ libx11-devel libxft-devel libxrandr-devel lib64imlib2-devel freetype-devel libxinerama-devel x11-server-xorg numlock x11-util-macros

cat << EOF | chroot ${ROOTFS}
    dnf install -y make clang libx11-devel libxft-devel libxrandr-devel lib64imlib2-devel freetype-devel libxinerama-devel x11-server-xorg numlock usbutils x11-util-macros
    dnf install -y meson cmake autoconf automake libtool lib64ev-devel glibc-devel libpixman-devel libx11-devel lib64xcb-util-image-devel lib64xcb-util-renderutil-devel libxcb-util-devel uthash-devel libpcre2-devel libepoxy-devel libdbus-1-devel
    dnf remove -y pipewire-pulse
    dnf install -y pulseaudio-server pulseaudio-module-bluetooth pulseaudio-utils pavucontrol alsa-utils
    
    systemctl --machine=${TARGET_USERNAME}@.host --user enable pulseaudio.service
EOF
fi


if [ -d "${ROOTFS}/usr/share/fonts/nerd-fonts/" ] && [ "$force_reinstall" = "0" ]; then
    echo "Nerd Fonts already installed, skipping."
else
echo "install nerdfonts"
for font in ${NERDFONTS} ; do
 echo "installing $font"
 wget -O ${ROOTFS}/tmp/${font}.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
 mkdir -p ${ROOTFS}/usr/share/fonts/nerd-fonts/
 unzip -o /tmp/${font}.zip -d ${ROOTFS}/usr/share/fonts/nerd-fonts/
 rm -f /tmp/${font}.zip
 echo "installed $font"
done
fi

echo "additional gui packages"
if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y ntfs-3g ifuse mousepad mpv haruna vlc cmatrix nmon mesa-utils neofetch feh qimgv acpitool lm-sensors fonts-noto libnotify-bin dunst mkvtoolnix-gui python3-mutagen imagemagick mediainfo-gui mediainfo arandr picom brightnessctl cups xsane sane-utils filezilla speedcrunch fonts-font-awesome lxappearance breeze-gtk-theme breeze-icon-theme joystick gparted vulkan-tools flatpak
    apt install -y ffmpeg libfdk-aac2 libnppig12 libnppicc12 libnppidei12 libnppif12
EOF

fi

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y libsane firefox-esr
EOF
fi

if [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << EOF | chroot ${ROOTFS}
zypper install -y \
  ntfs-3g ifuse mousepad mpv haruna vlc cmatrix nmon neofetch feh qimgv \
  noto-sans-fonts noto-serif-fonts libnotify-tools dunst mkvtoolnix-gui \
  python3-mutagen ImageMagick mediainfo-gui mediainfo arandr picom brightnessctl cups \
  xsane sane-backends filezilla speedcrunch fontawesome-fonts lxappearance \
  breeze-gtk gparted vulkan-tools flatpak

zypper install -y ffmpeg libfdk-aac2 libnppig12 libnppicc12 libnppidei12 libnppif12
EOF
fi
 

if [ "$OSNAME" = "openmandriva" ]; then

if [ "$OSVERSION" = "5.0" ]; then
cat << EOF | chroot ${ROOTFS}
dnf install -y breeze
EOF
else
cat << EOF | chroot ${ROOTFS}
dnf install -y plasma6-breeze
EOF
fi

cat << EOF | chroot ${ROOTFS}
    dnf install -y libgtk+3.0-devel python-gobject3-devel
    dnf install -y ntfs-3g ifuse mousepad mpv haruna vlc nmon neofetch feh qimgv acpitool lm_sensors noto-sans-fonts noto-serif-fonts fonts-ttf-awesome fonts-otf-awesome libnotify dunst ffmpeg mutagen imagemagick mediainfo arandr  cups xsane sane-backends filezilla lxappearance
    cd /tmp/
    wget -O picom.zip "https://github.com/yshui/picom/archive/refs/tags/v${PICOM_VERSION}.zip"
    unzip picom.zip
    cd picom-${PICOM_VERSION}
    meson setup --buildtype=release build
    ninja -C build install

    cd /tmp/
    wget -O brightnessctl.zip https://github.com/Hummer12007/brightnessctl/archive/refs/tags/${BRIGHTNESSCTL_VERSION}.zip
    unzip brightnessctl.zip
    cd brightnessctl-${BRIGHTNESSCTL_VERSION}
    make install

    cd /tmp/
    wget https://bitbucket.org/heldercorreia/speedcrunch/downloads/SpeedCrunch-${SPEEDCRUNCH_VERSION}-linux64.tar.bz2
    tar xvf SpeedCrunch-${SPEEDCRUNCH_VERSION}-linux64.tar.bz2
    cp speedcrunch /usr/local/bin/
EOF
#     picom brightnessctl


fi

# dunst notification
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/dunst

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ] || [ "$OSNAME" = "opensuse-tumbleweed" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.config/dunst/dunstrc
[global]
monitor = 0
# follow = keyboard
font = Noto Sans 11
frame_width = 2
frame_color = "#4e9a06"
offset = 20x65
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.config/dunst/dunstrc
[global]
monitor = 0
# follow = keyboard
font = Noto Sans 11
frame_width = 2
frame_color = "#4e9a06"
geometry = 300x5-20+65
icon_path = "/usr/share/icons/breeze-dark/status/16:/usr/share/icons/breeze-dark/devices/16"
EOF
fi

cat << 'EOF' | tee -a ${ROOTFS}/home/$TARGET_USERNAME/.config/dunst/dunstrc
[urgency_low]
    background = "#4e9a06"
    foreground = "#eeeeec"
[urgency_normal]
    background = "#2e3436"
    foreground = "#eeeeec"
[urgency_critical]
    background = "#a40000"
    foreground = "#eeeeec"
EOF

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/dunst
EOF



#YT-DLP latest
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ${ROOTFS}/usr/local/bin/yt-dlp
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/yt-dlp
EOF

# ffmpeg scripts
ffmpegscripts="
imdb.sh
ripbm.sh
ripscreen.sh
riptv.sh
vconv-archive-lossless-h264-vaapi.sh
vconv-audiosync.sh
vconv-extract-audio.sh
vconv-h264-vaapi-qp.sh
vconv-h264-vaapi-vbr.sh
vconv-hevc-vaapi-qp.sh
vconv-make-mkv.sh
vconv-make-mp4.sh
vconv-make-mp4-singletrack.sh
vconv-mkvmerge.sh
vconv-mp3-hq.sh
vconv-travel.sh
vconv-vp9-vaapi-qp.sh
vconv-x264-crf.sh
vconv-x264-lowres-lowvbr-2pass.sh
vconv-x264-lowres-vbr-2pass.sh
vconv-x264-vbr-2pass.sh
"

for script in $ffmpegscripts ; do
curl -Lo ${ROOTFS}/usr/local/bin/$script https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/ffmpeg/$script
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/$script
EOF
done

# pulseaudio podcast setup

# asoundrc
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.asoundrc
pcm.pulse {
    type pulse
}

ctl.pulse {
    type pulse
}
EOF

cat << EOF | chroot ${ROOTFS}
    chown $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.asoundrc
EOF

# create alsa loopback

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
lineinfile ${ROOTFS}/etc/modules ".*snd-aloop.*" "snd-aloop"
lineinfile ${ROOTFS}/etc/modules ".*snd-dummy.*" "snd-dummy"
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << 'EOF' | tee ${ROOTFS}/etc/modules-load.d/alsa.conf
snd-aloop
snd-dummy
EOF
fi

cat << 'EOF' | tee ${ROOTFS}/etc/modprobe.d/alsa-loopback.conf
options snd-aloop index=10 id=loop
options snd-dummy index=11 id=dummy
EOF

# avoid crackling with pulse
lineinfile ${ROOTFS}/etc/pulse/default.pa ".*load-module module-suspend-on-idle.*" "load-module module-suspend-on-idle"
lineinfile ${ROOTFS}/etc/pulse/system.pa ".*load-module module-suspend-on-idle.*" "load-module module-suspend-on-idle"

mkdir -p ${ROOTFS}/etc/pulse/default.pa.d/
wget -O ${ROOTFS}/etc/pulse/default.pa.d/pulsepod.pa https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/pulseaudio/pulsepod.pa

lineinfile ${ROOTFS}/etc/pulse/daemon.conf ".*default-sample-rate.*" "default-sample-rate = 48000"
lineinfile ${ROOTFS}/etc/pulse/daemon.conf ".*default-sample-format.*" "default-sample-format = s16le"
# lineinfile ${ROOTFS}/etc/pulse/daemon.conf ".*default-fragment-size-msec.*" "default-fragment-size-msec = 40"
# lineinfile ${ROOTFS}/etc/pulse/daemon.conf ".*default-fragments.*" "default-fragments = 4"
lineinfile ${ROOTFS}/etc/pulse/daemon.conf ".*resample-method.*" "resample-method = soxr-hq"

# install scripts for sound and monitor
gitroot=https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/pulseaudio/
files="snd asnd asndenv asnddef csndfoczv csndjbr csndzv csndh6 csndacer csndint clrmix clrmixoff"
for file in $files ; do
curl -Lo ${ROOTFS}/usr/local/bin/$file $gitroot/$file
chmod 755 ${ROOTFS}/usr/local/bin/$file
done

gitroot=https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/x11/
files="mon bestmode snotifs"
for file in $files ; do
curl -Lo ${ROOTFS}/usr/local/bin/$file $gitroot/$file
chmod 755 ${ROOTFS}/usr/local/bin/$file
done

# wireplumber and pipewire
curl -Lo ${ROOTFS}/etc/udev/rules.d/89-pulseaudio-udev.rules https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/pulseaudio/89-pulseaudio-udev.rules

# cat << EOF | chroot ${ROOTFS}
# cp -R /usr/share/pipewire /home/${TARGET_USERNAME}/.config/
# cp -R /usr/share/wireplumber /home/${TARGET_USERNAME}/.config/

# mkdir -p /home/${TARGET_USERNAME}/.config/pipewire/pipewire.conf.d/
# curl -Lo /home/$TARGET_USERNAME/.config/pipewire/pipewire.conf.d/podcast.conf https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/pulseaudio/podcast.conf
# curl -Lo /home/$TARGET_USERNAME/.config/pipewire/pipewire-pulse.conf https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/pulseaudio/pipewire-pulse.conf

# chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/pipewire
# chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/wireplumber
# EOF

# install scripts for webcam
gitroot=https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/camera/
files="cint c920"
for file in $files ; do
curl -Lo ${ROOTFS}/usr/local/bin/$file $gitroot/$file
chmod 755 ${ROOTFS}/usr/local/bin/$file
done

# install chrome browser
if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then

if [ -f "${ROOTFS}/opt/debs/google-chrome-stable_current_amd64.deb" ] && [ "$force_reinstall" = "0" ]; then
    echo "Google Chrome already downloaded, skipping."
else
    mkdir -p ${ROOTFS}/opt/debs/
    wget -O ${ROOTFS}/opt/debs/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
cat << EOF | chroot ${ROOTFS}
    apt install -y /opt/debs/google-chrome-stable_current_amd64.deb
EOF
fi

fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y google-chrome-stable
    rm -f /etc/yum.repos.d/google-chrome.repo
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    systemctl disable sddm
EOF
fi

#begin dwm
if [ -f ${ROOTFS}/usr/local/bin/dwm ]  && [ "$force_reinstall" = "0" ] ; then

echo "dwm already installed, skipping"

else

echo "The does not exist, installing dwm"
cat << EOF | chroot ${ROOTFS}
    rm -rf /home/$TARGET_USERNAME/wm
    mkdir -p /home/$TARGET_USERNAME/wm
    cd /home/$TARGET_USERNAME/wm
    git clone https://github.com/alainpham/dwm-flexipatch.git
    git clone https://github.com/alainpham/st-flexipatch.git
    git clone https://github.com/alainpham/dmenu-flexipatch.git
    git clone https://github.com/alainpham/dwmblocks.git
    git clone https://github.com/alainpham/slock-flexipatch.git

    cd /home/$TARGET_USERNAME/wm/dwm-flexipatch && make clean install
    cd /home/$TARGET_USERNAME/wm/st-flexipatch && make clean install
    cd /home/$TARGET_USERNAME/wm/dmenu-flexipatch && make clean install
    cd /home/$TARGET_USERNAME/wm/dwmblocks && make clean install
    cd /home/$TARGET_USERNAME/wm/slock-flexipatch && make clean install

    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/wm
EOF

fi 

# wallpaper
mkdir -p ${ROOTFS}/usr/share/backgrounds/

# Define a list of backend files to be downloaded
backend_files=(
    "https://free-images.com/or/8606/canyon_antelope_canyon_usa_1.jpg"
    "https://free-images.com/lg/ac18/city_night_light_bokeh.jpg"
    "https://free-images.com/lg/5cc4/lights_night_city_night.jpg"
    "https://raw.githubusercontent.com/simple-sunrise/Light-and-Dark-Wallpapers-for-Gnome/main/Wallpapers/LakesideDeer/LakesideDeer-1.png"
    "https://raw.githubusercontent.com/simple-sunrise/Light-and-Dark-Wallpapers-for-Gnome/main/Wallpapers/LakesideDeer/LakesideDeer-2.png"
)


# Loop through the list and download each file
for i in "${!backend_files[@]}"; do
    if [ ! -f "${ROOTFS}/usr/share/backgrounds/$(printf "%02d" $((i+1))).jpg" ]; then
        wget -O "${ROOTFS}/usr/share/backgrounds/$(printf "%02d" $((i+1))).jpg" "${backend_files[$i]}"
        echo "Downloaded background image $(printf "%02d" $((i+1))).jpg"
    else
        echo "Background image $(printf "%02d" $((i+1))).jpg already exists, skipping."
    fi
done

# switching backgounds
cat << 'EOF' | tee ${ROOTFS}/usr/local/bin/sbg
#!/bin/bash
bgfile=$(ls /usr/share/backgrounds/ | shuf -n 1)
feh --bg-fill /usr/share/backgrounds/${bgfile}
EOF

chmod 755 ${ROOTFS}/usr/local/bin/sbg

# deactivate service for dunst to work

if [ -f ${ROOTFS}/usr/share/dbus-1/services/org.knopwob.dunst.service ] ; then
mv ${ROOTFS}/usr/share/dbus-1/services/org.knopwob.dunst.service ${ROOTFS}/usr/share/dbus-1/services/org.knopwob.dunst.service.disabled
fi

if [ "$OSNAME" = "devuan" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.xinitrc
#!/bin/sh
eval $(dbus-launch --sh-syntax --exit-with-session)
EOF
fi

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.xinitrc
#!/bin/sh
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ] && [ -n "$XDG_RUNTIME_DIR" ] && \
    [ "$XDG_RUNTIME_DIR" = "/run/user/`id -u`" ] && \
    [ -S "$XDG_RUNTIME_DIR/bus" ]; then
  DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
  export DBUS_SESSION_BUS_ADDRESS
fi

if [ -x "/usr/bin/dbus-update-activation-environment" ]; then
  dbus-update-activation-environment --verbose --systemd \
    DBUS_SESSION_BUS_ADDRESS \
    DISPLAY \
    XAUTHORITY \
    XDG_CURRENT_DESKTOP \
    ${NULL+}
fi

EOF
fi

# check if inside virtual machine
export hypervisor=$(echo "virt-what" | chroot ${ROOTFS})

if [ "$hypervisor" = "hyperv" ] || [ "$hypervisor" = "kvm" ]; then

cat << 'EOF' | chroot ${ROOTFS}
    apt install -y  spice-vdagent
EOF

cat << 'EOF' | tee -a ${ROOTFS}/home/$TARGET_USERNAME/.xinitrc
spice-vdagent
EOF
fi

# Xinit numlock
if [[ "$(dmidecode -t 1 | grep 'Product Name')" == *"MacBook"* ]]; then
    echo "Running on a MacBook, no numlock"
else
    
    if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | tee -a ${ROOTFS}/home/$TARGET_USERNAME/.xinitrc
numlockx

EOF
    fi

    if [ "$OSNAME" = "openmandriva" ]; then
cat << 'EOF' | tee -a ${ROOTFS}/home/$TARGET_USERNAME/.xinitrc
enable_X11_numlock
EOF
    fi
fi

cat << 'EOF' | tee -a ${ROOTFS}/home/$TARGET_USERNAME/.xinitrc
dunst > ~/.dunst.log &
echo 1 | tee ~/.rebootdwm
export rebootdwm=$(cat ~/.rebootdwm)
export XCURSOR_SIZE=24
while true; do
    piddwmblocks=$(pgrep dwmblocks)
    if [ -z "$piddwmblocks" ]; then
        dwmblocks &
    else
        kill -9 $piddwmblocks
        dwmblocks &
    fi
    if command -v libinput-gestures >/dev/null 2>&1; then
        pidgestures=$(pgrep -f libinput-gestures)
        if [ -z "$pidgestures" ]; then
            libinput-gestures &
        else
            kill -9 $pidgestures
            libinput-gestures &
        fi
    fi
    bgfile=$(ls /usr/share/backgrounds/ | shuf -n 1)
    feh --bg-fill /usr/share/backgrounds/${bgfile}
    picom -b --config ~/.config/picom/picom.conf
    # Log stderror to a file
    dwm 2> ~/.dwm.log
    # No error logging
    #dwm >/dev/null 2>&1
    rebootdwm=$(cat ~/.rebootdwm)
    if [ "$rebootdwm" = '0' ]; then
            break
    fi
done
EOF

cat << EOF | chroot ${ROOTFS}
    chown $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.xinitrc
EOF

# picom initial config
if [ ! -f ${ROOTFS}/home/$TARGET_USERNAME/.config/picom/picom.conf ] ; then
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/picom/
cat << 'EOF' | tee ${ROOTFS}/home/${TARGET_USERNAME}/.config/picom/picom.conf
# picom config
backend = "glx";
vsync = true;
use-damage = false

shadow-exclude = [
  "name = 'cpt_frame_xcb_window'",
  "class_g ?= 'zoom'"
];

blur-background-exclude = [
  "class_g ?= 'zoom'"
];
EOF
fi

# convert pdf to png with whitebackground
cat << 'EOF' | tee ${ROOTFS}/usr/local/bin/pdf2png
#!/bin/bash
convert -density 150 "$1" -background white -alpha remove -alpha off "$1.png"
EOF

cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/pdf2png
EOF

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y v4l2loopback-utils flameshot maim xclip xdotool thunar thunar-archive-plugin
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y   v4l-utils flameshot xclip xdotool thunar thunar-archive-plugin 
EOF

# compile maim
cat << EOF | chroot ${ROOTFS}
    dnf install -y libglew-devel glm-devel lib64glu-devel libwebp-devel
EOF

cat << EOF | chroot ${ROOTFS}
    cd /tmp/
    wget https://github.com/naelstrof/slop/archive/refs/tags/v${SLOP_VERSION}.zip
    unzip slop-${SLOP_VERSION}.zip
    cd slop-${SLOP_VERSION}
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="/usr" ./
    make && sudo make install

    cd /tmp/
    wget https://github.com/naelstrof/maim/archive/refs/tags/v${MAIM_VERSION}.zip
    unzip maim-${MAIM_VERSION}.zip
    cd maim-${MAIM_VERSION}
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="/usr" ./
    make && sudo make install
EOF
fi

cat << 'EOF' | tee ${ROOTFS}/usr/local/bin/winshot.sh
maim -i $(xdotool getactivewindow) | xclip -selection clipboard -t image/png
EOF
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/winshot.sh
EOF

# configure Thunar
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/Thunar/

cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.config/Thunar/uca.xml
<?xml version="1.0" encoding="UTF-8"?>
<actions>
<action>
        <icon>utilities-terminal</icon>
        <name>Open Terminal Here</name>
        <submenu></submenu>
        <unique-id>1727457442655389-1</unique-id>
        <command>st -d %f</command>
        <description>Open Terminal here</description>
        <range></range>
        <patterns>*</patterns>
        <startup-notify/>
        <directories/>
</action>
<action>
        <icon>vscode</icon>
        <name>VSCode</name>
        <submenu></submenu>
        <unique-id>1727457442655389-2</unique-id>
        <command>code %f</command>
        <description>Open VSCode here</description>
        <range></range>
        <patterns>*</patterns>
        <startup-notify/>
        <directories/>
</action>
</actions>
EOF

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml/

cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

<?xml version="1.0" encoding="UTF-8"?>

<channel name="thunar" version="1.0">
  <property name="last-view" type="string" value="ThunarDetailsView"/>
  <property name="last-icon-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_100_PERCENT"/>
  <property name="last-window-width" type="int" value="750"/>
  <property name="last-window-height" type="int" value="242"/>
  <property name="last-window-maximized" type="bool" value="false"/>
  <property name="last-separator-position" type="int" value="166"/>
  <property name="misc-single-click" type="bool" value="false"/>
  <property name="last-details-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_38_PERCENT"/>
  <property name="last-details-view-column-widths" type="string" value="50,50,137,113,50,457,50,50,392,50,50,69,50,140"/>
  <property name="last-sort-column" type="string" value="THUNAR_COLUMN_NAME"/>
  <property name="last-sort-order" type="string" value="GTK_SORT_ASCENDING"/>
  <property name="last-show-hidden" type="bool" value="false"/>
  <property name="last-details-view-visible-columns" type="string" value="THUNAR_COLUMN_DATE_MODIFIED,THUNAR_COLUMN_NAME,THUNAR_COLUMN_SIZE,THUNAR_COLUMN_TYPE"/>
  <property name="last-side-pane" type="string" value="ThunarShortcutsPane"/>
  <property name="last-toolbar-item-order" type="string" value="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18"/>
  <property name="last-toolbar-visible-buttons" type="string" value="0,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1"/>
  <property name="last-splitview-separator-position" type="int" value="291"/>
  <property name="misc-date-style" type="string" value="THUNAR_DATE_STYLE_YYYYMMDD"/>
  <property name="last-compact-view-zoom-level" type="string" value="THUNAR_ZOOM_LEVEL_25_PERCENT"/>
</channel>
EOF

# deactivate thumbler cause it causes issues with usb
if [ -f "${ROOTFS}/etc/xdg/tumbler/tumbler.rc" ]; then
    sed -i 's/Disabled=false/Disabled=true/g' ${ROOTFS}/etc/xdg/tumbler/tumbler.rc
fi

# Set default apps
cat << EOF | chroot ${ROOTFS}
    sudo -u $TARGET_USERNAME xdg-mime default thunar.desktop inode/directory
EOF

videomimetype=$(grep -E '^video/' /usr/share/mime/types | cut -d: -f1)
for mime in $videomimetype; do
cat << EOF | chroot ${ROOTFS}
    sudo -u $TARGET_USERNAME xdg-mime default org.kde.haruna.desktop "$mime"
EOF
done

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config
EOF

#autostart apps
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.local/share/dwm
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.local/share/dwm/autostart.sh
asnddef &
mon &
sleep 5 && sbg &
EOF

cat << EOF | chroot ${ROOTFS}
    chmod 755 /home/$TARGET_USERNAME/.local/share/dwm/autostart.sh
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.local
EOF

# video and audio group
if [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    adduser $TARGET_USERNAME audio
    adduser $TARGET_USERNAME video
EOF
fi

ivmgui

}

iprinter(){
    lpadmin -p hp-smart-tank-cp -E -v ipp://192.168.8.200/ipp/print -m everywhere
}

iffmpeg(){

    wget -O /usr/local/bin/ffmpeg http://192.168.8.100:28000/ffmpeg/ubuntu/ffmpeg
    wget -O /usr/local/bin/ffprobe http://192.168.8.100:28000/ffmpeg/ubuntu/ffprobe
    wget -O /usr/local/bin/ffplay http://192.168.8.100:28000/ffmpeg/ubuntu/ffplay

    chmod 755 /usr/local/bin/ffmpeg
    chmod 755 /usr/local/bin/ffprobe
    chmod 755 /usr/local/bin/ffplay
}

inetworking(){
trap 'return 1' ERR

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y network-manager dnsmasq
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y NetworkManager dnsmasq
EOF
fi

# networking config to network manager
if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    systemctl disable dnsmasq
EOF
fi

if [ "$OSNAME" = "devuan" ]; then
cat << EOF | chroot ${ROOTFS}
    rm /etc/insserv.conf.d/dnsmasq
    update-rc.d -f dnsmasq remove
EOF
fi


if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ]; then
cat << 'EOF' | tee ${ROOTFS}/etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat <<EOF | chroot ${ROOTFS}
    systemctl disable systemd-resolved
    rm -f ${ROOTFS}/etc/resolv.conf
EOF
fi

if [ "$OSNAME" = "ubuntu" ]; then
cat <<EOF | chroot ${ROOTFS}
    systemctl enable NetworkManager
    rm -f ${ROOTFS}/etc/resolv.conf
    systemctl disable systemd-networkd
    systemctl disable systemd-resolved
    ln -sf /run/NetworkManager/resolv.conf /etc/resolv.conf
EOF
cat << 'EOF' | tee ${ROOTFS}/etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: NetworkManager
EOF
fi

cat << 'EOF' | tee ${ROOTFS}/etc/NetworkManager/conf.d/00-use-dnsmasq.conf
[main]
dns=dnsmasq
EOF

cat << 'EOF' | tee ${ROOTFS}/etc/NetworkManager/dnsmasq.d/dev.conf
#/etc/NetworkManager/dnsmasq.d/dev.conf
local=/zez.duckdns.org/
address=/zez.duckdns.org/172.18.0.1
EOF

# allow nmcli reload
cat << EOF | tee ${ROOTFS}/etc/polkit-1/rules.d/49-nmcli-reload.rules
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.NetworkManager.reload" &&
        subject.isInGroup("${TARGET_USERNAME}")) {
        return polkit.Result.YES;
    }
});
EOF

cat <<EOF | chroot ${ROOTFS}
mkdir -p /home/$TARGET_USERNAME/virt/runtime
touch /home/$TARGET_USERNAME/virt/runtime/vms
ln -s /home/$TARGET_USERNAME/virt/runtime/vms /etc/NetworkManager/dnsmasq.d/vms
chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/virt/runtime
EOF

}

itheming() {
trap 'return 1' ERR
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.gtkrc-2.0
# DO NOT EDIT! This file will be overwritten by LXAppearance.
# Any customization should be done in ~/.gtkrc-2.0.mine instead.

include "/home/apham/.gtkrc-2.0.mine"
gtk-theme-name="Breeze-Dark"
gtk-icon-theme-name="breeze-dark"
gtk-font-name="NotoSans Nerd Font 10"
gtk-cursor-theme-name="breeze_cursors"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"

EOF
cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.gtkrc-2.0
EOF

rm -rf ${ROOTFS}/home/$TARGET_USERNAME/.config/gtk*

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/gtk-3.0/


cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Breeze-Dark
gtk-icon-theme-name=breeze-dark
gtk-font-name=NotoSans Nerd Font 10
gtk-cursor-theme-name=breeze_cursors
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull

EOF

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/gtk-3.0
EOF

}

ivmgui() {
trap 'return 1' ERR
# if inside virtual machine
# video=Virtual-1:1600x900

if [ "$hypervisor" = "hyperv" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/${TARGET_USERNAME}/.config/picom/picom.conf
# picom config
backend = "xrender";
use-damage = false
EOF

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME ${ROOTFS}/home/${TARGET_USERNAME}/.config/picom
EOF

sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ {/video=Virtual-1:1600x900/! s/"$/ video=Virtual-1:1600x900"/}' ${ROOTFS}/etc/default/grub

update-grub2

cat <<EOF | tee ${ROOTFS}/etc/X11/xorg.conf.d/30-hyperv.conf
Section "Device"
  Identifier "HYPER_V Framebuffer"
  Driver "fbdev"
EndSection
EOF
#end hyperv
fi
}

iworkstation() {
trap 'return 1' ERR

echo "additional workstation tools"
force_reinstall=${1:-0}

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y handbrake gimp rawtherapee krita mypaint inkscape blender obs-studio mgba-qt easytag audacity mixxx
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y handbrake gimp rawtherapee krita python-numpy mypaint inkscape blender obs-studio audacity mixxx
EOF
# install easytag flathub
fi

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    DEBIAN_FRONTEND=noninteractive apt install -y libdvd-pkg
EOF

echo "dpkg libdvd-pkg"
cat << EOF | chroot ${ROOTFS}
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure libdvd-pkg
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y lib64dvdcss
EOF
fi

# cat << EOF | chroot ${ROOTFS}
#     apt install -y snapd
#     snap install pinta
#     snap install rpi-imager
# EOF

#vscode
if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then

if [ ! -f "${ROOTFS}/opt/debs/vscode.deb" ] || [ "$force_reinstall" = "1" ]; then
mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
cat << EOF | chroot ${ROOTFS}
    DEBIAN_FRONTEND=noninteractive apt install -y /opt/debs/vscode.deb
EOF
fi


# install dbeaver
if [ ! -f "${ROOTFS}/opt/debs/dbeaver.deb" ] || [ "$force_reinstall" = "1" ]; then
mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/dbeaver.deb https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
cat << EOF | chroot ${ROOTFS}
    apt install -y /opt/debs/dbeaver.deb
EOF
fi

fi

if [ "$OSNAME" = "openmandriva" ]; then

mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/vscode.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"
cat << EOF | chroot ${ROOTFS}
    dnf install -y /opt/debs/vscode.rpm
EOF

mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/dbeaver.rpm https://dbeaver.io/files/dbeaver-ce-latest-stable.x86_64.rpm
cat << EOF | chroot ${ROOTFS}
    dnf install -y ${ROOTFS}/opt/debs/dbeaver.rpm
EOF

fi

# configure OBS
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/obs-studio
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/recordings
cat << EOF | chroot ${ROOTFS}
    curl -Lo /tmp/obs-studio.tar https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/obs/obs-studio.tar
    tar xvf /tmp/obs-studio.tar -C /home/$TARGET_USERNAME/.config/
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/obs-studio
    chown -R root:root /home/$TARGET_USERNAME/.config/obs-studio/basic/profiles
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/recordings
EOF

iappimages $force_reinstall

}

iappimages(){
trap 'return 1' ERR

force_reinstall=${1:-0}

# APPimages
ikdenlive $force_reinstall
ionlyoffice $force_reinstall
imlvapp $force_reinstall
idrawio $force_reinstall
iviber $force_reinstall
ibeeref $force_reinstall
ifreac $force_reinstall
ilocalsend $force_reinstall
iavidemux $force_reinstall
ipostman $force_reinstall
imoonlight $force_reinstall
isunshine $force_reinstall
}

iwebapps(){
webapps=(
    "gpt|https://chatgpt.com"
    "gm|https://mail.google.com/mail/u/1/#inbox"
    "cal|https://calendar.google.com/calendar/u/1/r"
    "teams|https://teams.microsoft.com/v2/"
    "whatsapp|https://web.whatsapp.com"
    "messenger|https://www.messenger.com"
    "telegram|https://web.telegram.org"
    "notes|https://docs.google.com/document/d/1wTwA1NhzgYUGG1eyDyUZj8ExhbhdscQrdYWBOBkLnCs"
    "gco|https://docs.google.com/presentation/d/1yo6Q0p0OBK9vIh3abwigtBDlFGMy9NqU7EzRKYjraro"
    "gdemo|https://assertsdemo.grafana.net/a/grafana-asserts-app/assertions?start=now-24h&end=now&we[0][n]=productcatalogservice&we[0][tp]=Service&we[0][sc][site]=us-east-2&we[0][sc][ns]=ditl-demo-prod&we[0][sc][env]=assertsdemo-cluster&we[1][n]=flagd&we[1][tp]=Service&we[1][sc][site]=us-east-2&we[1][sc][ns]=ditl-demo-prod&we[1][sc][env]=assertsdemo-cluster&we[2][n]=productcatalog-postgres&we[2][tp]=Service&we[2][sc][site]=us-east-2&we[2][sc][ns]=ditl-demo-prod&we[2][sc][env]=assertsdemo-cluster&we[3][n]=frontend&we[3][tp]=Service&we[3][sc][site]=us-east-2&we[3][sc][ns]=ditl-demo-prod&we[3][sc][env]=assertsdemo-cluster&we[4][n]=recommendationservice&we[4][tp]=Service&we[4][sc][site]=us-east-2&we[4][sc][ns]=ditl-demo-prod&we[4][sc][env]=assertsdemo-cluster&view=BY_ENTITY"
    "spotify|https://open.spotify.com/"
    "youtube|https://www.youtube.com/"
    "grok|https://grok.com/"
    "sd|https://stablediffusionweb.com/app/image-generator"
    "brm|https://stablediffusionweb.com/background-remover"
    "word|https://word.cloud.microsoft"
    "excel|https://excel.cloud.microsoft"
    "powerpoint|https://powerpoint.cloud.microsoft"
)

for entry in "${webapps[@]}"; do
    name="${entry%%|*}"
    url="${entry#*|}"
cat << EOF | tee ${ROOTFS}/usr/local/bin/${name}
#!/bin/bash
google-chrome --app="${url}"
EOF
cat << EOF | chroot ${ROOTFS}
chmod 755 /usr/local/bin/${name}
EOF
done


}

isunshine(){
trap 'return 1' ERR
force_reinstall=${1:-0}

if [ ! -f ${ROOTFS}/opt/appimages/sunshine.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/sunshine.AppImage https://github.com/LizardByte/Sunshine/releases/download/v$SUNSHINE_VERSION/sunshine.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/sunshine.AppImage
    ln -sf /opt/appimages/sunshine.AppImage /usr/local/bin/sunshine
EOF
else
echo "sunshine already installed, skipping"
fi
}

imoonlight(){
trap 'return 1' ERR
force_reinstall=${1:-0}

if [ ! -f ${ROOTFS}/opt/appimages/moonlight.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/moonlight.AppImage https://github.com/moonlight-stream/moonlight-qt/releases/download/v$MOONLIGHT_VERSION/Moonlight-$MOONLIGHT_VERSION-x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/moonlight.AppImage
    ln -sf /opt/appimages/moonlight.AppImage /usr/local/bin/moonlight
EOF
else
echo "moonlight already installed, skipping"
fi
}

ikdenlive(){
trap 'return 1' ERR
force_reinstall=${1:-0}

#kdenlive
if [ ! -f ${ROOTFS}/opt/appimages/kdenlive.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/kdenlive.AppImage \
https://download.kde.org/stable/kdenlive/${KDENLIVE_MAIN_VERSION}/linux/kdenlive-${KDENLIVE_FULL_VERSION}-x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/kdenlive.AppImage
    ln -sf /opt/appimages/kdenlive.AppImage /usr/local/bin/kdenlive
EOF
else
echo "kdenlive already installed, skipping"
fi
}

ionlyoffice() {
trap 'return 1' ERR
force_reinstall=${1:-0}
# Only Office
if [ ! -f ${ROOTFS}/opt/appimages/onlyoffice.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/onlyoffice.AppImage https://github.com/ONLYOFFICE/appimage-desktopeditors/releases/download/${ONLYOFFICE_VERSION}/DesktopEditors-x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/onlyoffice.AppImage
    ln -sf /opt/appimages/onlyoffice.AppImage /usr/local/bin/onlyoffice
EOF
else
echo "onlyoffice already installed, skipping"
fi
}

imlvapp(){
trap 'return 1' ERR
force_reinstall=${1:-0}
# MLVP APP
if [ ! -f ${ROOTFS}/opt/appimages/mlvapp.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/mlvapp.AppImage https://github.com/ilia3101/MLV-App/releases/download/QTv${MLVAPP_VERSION}/MLV.App.v${MLVAPP_VERSION}.Linux.x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/mlvapp.AppImage
    ln -sf /opt/appimages/mlvapp.AppImage /usr/local/bin/mlvapp
EOF
else
echo "mlvapp already installed, skipping"
fi
}

idrawio(){
trap 'return 1' ERR
force_reinstall=${1:-0}
# Drawio
if [ ! -f ${ROOTFS}/opt/appimages/drawio.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/drawio.AppImage https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-x86_64-${DRAWIO_VERSION}.AppImage
cat << EOF | tee ${ROOTFS}/usr/local/bin/drawio
/opt/appimages/drawio.AppImage --no-sandbox
EOF
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/drawio.AppImage
    chmod 755 /usr/local/bin/drawio
EOF
else
echo "drawio already installed, skipping"
fi
}

iviber() {
trap 'return 1' ERR
force_reinstall=${1:-0}
#viber
if [ ! -f ${ROOTFS}/opt/appimages/viber.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/viber.AppImage https://download.cdn.viber.com/desktop/Linux/viber.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/viber.AppImage
    ln -sf /opt/appimages/viber.AppImage /usr/local/bin/viber
EOF
else
echo "viber already installed, skipping"
fi
}

ibeeref() {
trap 'return 1' ERR
force_reinstall=${1:-0}
# beeref
if [ ! -f ${ROOTFS}/opt/appimages/beeref.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/beeref.AppImage https://github.com/rbreu/beeref/releases/download/v${BEEREF_VERSION}/BeeRef-${BEEREF_VERSION}.appimage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/beeref.AppImage
    ln -sf /opt/appimages/beeref.AppImage /usr/local/bin/beeref
EOF
else
echo "beeref already installed, skipping"
fi
}

ifreac() {
trap 'return 1' ERR
force_reinstall=${1:-0}
#freac
if [ ! -f ${ROOTFS}/opt/appimages/freac.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/freac.AppImage https://github.com/enzo1982/freac/releases/download/v${FREAC_VERSION}/freac-${FREAC_VERSION}-linux-x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/freac.AppImage
    ln -sf /opt/appimages/freac.AppImage /usr/local/bin/freac
EOF
else
echo "freac already installed, skipping"
fi
}

ilocalsend() {
trap 'return 1' ERR
force_reinstall=${1:-0}

# localsend
if [ ! -f ${ROOTFS}/opt/appimages/localsend.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/localsend.AppImage https://github.com/localsend/localsend/releases/download/v${LOCALSEND_VERSION}/LocalSend-${LOCALSEND_VERSION}-linux-x86-64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/localsend.AppImage
    ln -sf /opt/appimages/localsend.AppImage /usr/local/bin/localsend
EOF
else
echo "localsend already installed, skipping"
fi
}

iavidemux(){
trap 'return 1' ERR
force_reinstall=${1:-0}
# avidemux
if [ ! -f ${ROOTFS}/opt/appimages/avidemux.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/avidemux.AppImage https://altushost-swe.dl.sourceforge.net/project/avidemux/avidemux/${AVIDEMUX_VERSION}/avidemux_${AVIDEMUX_VERSION}.appImage?viasf=1
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/avidemux.AppImage
    ln -sf /opt/appimages/avidemux.AppImage /usr/local/bin/avidemux
EOF
else
echo "avidemux already installed, skipping"
fi
}


ipostman(){
trap "return 1" ERR

force_reinstall=${1:-0}

if [ -f "${ROOTFS}/opt/appimages/postman/Postman" ] && [ "$force_reinstall" = "0" ]; then
    echo "postman already installed, skipping"
    return 0
fi

mkdir -p ${ROOTFS}/opt/appimages/postman
rm -rf ${ROOTFS}/opt/appimages/postman/*

curl -L -o /tmp/postman.tar.gz https://dl.pstmn.io/download/latest/linux_64
tar --strip-components=1 -xzvf /tmp/postman.tar.gz -C ${ROOTFS}/opt/appimages/postman
cat << EOF | chroot ${ROOTFS}
    ln -sf /opt/appimages/postman/Postman /usr/local/bin/postman
EOF
rm -f /tmp/postman.tar.gz
echo "postman installed"
}

iemulation(){
trap 'return 1' ERR
force_reinstall=${1:-0}

lineinfile ${ROOTFS}/etc/bluetooth/input.conf ".*ClassicBondedOnly.*" "ClassicBondedOnly=false"

#esde
iesde $force_reinstall

#retroarch
iretroarch $force_reinstall

#PCSX2
ipcsx2 $force_reinstall

#dolphin GC wii
idolphin $force_reinstall

#cemu wiiu
icemu $force_reinstall

#Bottles for PC games
ibottles $force_reinstall

#configure emulators
iemucfg

#shortcuts with gamepads
igshorts

#script to connect ps4 controller
ips4controller
}

ips4controller(){

dlfiles="
ps4connect.sh
"
for fname in $dlfiles ; do
curl -Lo ${ROOTFS}/usr/local/bin/$fname https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/ds4/$fname
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/$fname
EOF
done
}


igshorts(){

dlfiles="
gshorts
"

killall gshorts
for fname in $dlfiles ; do
curl -Lo ${ROOTFS}/usr/local/bin/$fname https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/gshorts/$fname
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/$fname
EOF
done

lineinfile ${ROOTFS}/home/$TARGET_USERNAME/.local/share/dwm/autostart.sh .*gshorts.* "killall gshorts ; gshorts \&"

}

iesde(){
# Install RetroArch AppImage if not present or force_reinstall is 1
if [ ! -f ${ROOTFS}/opt/appimages/emustation.AppImage ] || [ "$force_reinstall" = "1" ]; then
echo "emulation tools"
wget -O ${ROOTFS}/opt/appimages/emustation.AppImage https://gitlab.com/es-de/emulationstation-de/-/package_files/${ESDE_VERSION_ID}/download
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/emustation.AppImage
    ln -sf /opt/appimages/emustation.AppImage /usr/local/bin/estation
EOF
else
echo "emulationstation already installed, skipping"
fi

}

iretroarch(){
# https://buildbot.libretro.com/stable/
if [ ! -f ${ROOTFS}/opt/appimages/RetroArch-Linux-x86_64.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/tmp/RetroArch.7z https://buildbot.libretro.com/stable/${RETROARCH_VERSION}/linux/x86_64/RetroArch.7z
wget -O ${ROOTFS}/tmp/RetroArch_cores.7z https://buildbot.libretro.com/stable/${RETROARCH_VERSION}/linux/x86_64/RetroArch_cores.7z
cd ${ROOTFS}/tmp/
7z x RetroArch.7z
7z x RetroArch_cores.7z
cd -
wget -O ${ROOTFS}/tmp/bios.zip https://github.com/Abdess/retroarch_system/releases/download/v20220308/RetroArch_v1.10.1.zip
unzip ${ROOTFS}/tmp/bios.zip 'system/*' -d /tmp/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage.home/.config/retroarch/


cat << EOF | chroot ${ROOTFS}
    mv /tmp/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage /opt/appimages/RetroArch-Linux-x86_64.AppImage
    chmod 755 /opt/appimages/RetroArch-Linux-x86_64.AppImage
    ln -sf /opt/appimages/RetroArch-Linux-x86_64.AppImage /usr/local/bin/retroarch
    
    if [ -d "/home/$TARGET_USERNAME/.config/retroarch/saves" ]; then
        mv /home/$TARGET_USERNAME/.config/retroarch/saves /home/$TARGET_USERNAME/.config/ra-saves
    fi
    if [ -d "/home/$TARGET_USERNAME/.config/retroarch/states" ]; then
        mv /home/$TARGET_USERNAME/.config/retroarch/states /home/$TARGET_USERNAME/.config/ra-states
    fi

    rm -rf /home/$TARGET_USERNAME/.config/retroarch

    mv /tmp/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage.home/.config/retroarch /home/$TARGET_USERNAME/.config/
    cp -R /home/$TARGET_USERNAME/.config/retroarch/autoconfig /home/$TARGET_USERNAME/.config/ra-autoconfig

    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/retroarch
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/ra-autoconfig
EOF
else
echo "RetroArch already installed, skipping"
fi

}

ipcsx2(){
trap 'return 1' ERR
force_reinstall=${1:-0}
#TODO put in env vars

if [ ! -f ${ROOTFS}/opt/appimages/pcsx2.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/pcsx2.AppImage https://github.com/PCSX2/pcsx2/releases/download/v${PCSX2_VERSION}/pcsx2-v${PCSX2_VERSION}-linux-appimage-x64-Qt.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/pcsx2.AppImage
    ln -sf /opt/appimages/pcsx2.AppImage /usr/local/bin/pcsx2
EOF
else
echo "pcsx2 already installed, skipping"
fi

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/bios
wget -O ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/bios/ps2-0230a-20080220.bin https://github.com/archtaurus/RetroPieBIOS/raw/master/BIOS/pcsx2/bios/ps2-0230a-20080220.bin 
cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/PCSX2
EOF
}

icemu(){
trap 'return 1' ERR
force_reinstall=${1:-0}
#TODO put in env vars https://github.com/cemu-project/Cemu/releases 

if [ ! -f ${ROOTFS}/opt/appimages/emu.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/cemu.AppImage https://github.com/cemu-project/Cemu/releases/download/v$CEMU_VERSION/Cemu-$CEMU_VERSION-x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/cemu.AppImage
    ln -sf /opt/appimages/cemu.AppImage /usr/local/bin/cemu
EOF
else
echo "cemu already installed, skipping"
fi


}

ibottles(){
# flatpaks
cat << EOF | chroot ${ROOTFS}
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.usebottles.bottles
EOF

cat << EOF | chroot ${ROOTFS}
flatpak install -y flathub com.github.tchx84.Flatseal
EOF

cat <<EOF | tee ${ROOTFS}/usr/local/bin/bottles
flatpak run com.usebottles.bottles
EOF

cat << EOF | chroot ${ROOTFS}
   chmod 755 /usr/local/bin/bottles
EOF

cat <<EOF | tee ${ROOTFS}/usr/local/bin/flatseal
flatpak run com.github.tchx84.Flatseal
EOF
cat << EOF | chroot ${ROOTFS}
   chmod 755 /usr/local/bin/flatseal
EOF

# post install : launch bottles to download
# create a bottle called games
# create a bottle called apps
# give access to GPU and user folder through flatseal.
}

idolphin(){
cat << EOF | chroot ${ROOTFS}
    flatpak install -y flathub org.DolphinEmu.dolphin-emu
EOF

cat <<EOF | tee ${ROOTFS}/usr/local/bin/dolphin
flatpak run org.DolphinEmu.dolphin-emu
EOF
cat << EOF | chroot ${ROOTFS}
   chmod 755 /usr/local/bin/dolphin
EOF
}

ijfin(){

flatpak install -y flathub com.github.iwalton3.jellyfin-media-player

cat <<EOF | tee ${ROOTFS}/usr/local/bin/jellyfin-media-player
flatpak run com.github.iwalton3.jellyfin-media-player
EOF

cat << EOF | chroot ${ROOTFS}
   chmod 755 /usr/local/bin/jellyfin-media-player
EOF
}

iemucfg(){

cat << EOF | chroot ${ROOTFS}
    mkdir -p /home/${TARGET_USERNAME}/ROMs
    mkdir -p /home/${TARGET_USERNAME}/ES-DE/downloaded_media
    mkdir -p /home/${TARGET_USERNAME}/.config/retroarch/states
    mkdir -p /home/${TARGET_USERNAME}/.config/retroarch/saves
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/ROMs
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/ES-DE
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/.config/retroarch
EOF


export RARCHFLD=${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch
export RARCHCFG=${RARCHFLD}/retroarch.cfg

rm -r $RARCHFLD/{playlists,cheats,config,logs,autoconfig}
rm $RARCHCFG

cp -R $ROOTFS/home/$TARGET_USERNAME/.config/ra-autoconfig $RARCHFLD/autoconfig

# export RARCHCFG=/home/$TARGET_USERNAME/.config/retroarch/retroarch.cfg
touch $RARCHCFG
lineinfile $RARCHCFG "video_windowed_fullscreen.*=.*" 'video_windowed_fullscreen = "false"'
lineinfile $RARCHCFG "video_fullscreen.*=.*" 'video_fullscreen = "true"'
lineinfile $RARCHCFG "quit_press_twice.*=.*" 'quit_press_twice = "false"'
lineinfile $RARCHCFG "menu_swap_ok_cancel_buttons.*=.*" 'menu_swap_ok_cancel_buttons = "true"'
lineinfile $RARCHCFG "savestate_auto_index.*=.*" 'savestate_auto_index = "true"'
lineinfile $RARCHCFG "savestate_thumbnail_enable.*=.*" 'savestate_thumbnail_enable = "true"'
lineinfile $RARCHCFG "video_driver.*=.*" 'video_driver = "glcore"'
lineinfile $RARCHCFG "audio_latency.*=.*" 'audio_latency = "128"'
lineinfile $RARCHCFG "microphone_latency.*=.*" 'microphone_latency = "128"'
lineinfile $RARCHCFG "video_swap_interval.*=.*" 'video_swap_interval = "0"'

lineinfile $RARCHCFG "video_vsync.*=.*" 'video_vsync = "false"'

# deactivate menu button
lineinfile $RARCHCFG "input_menu_toggle_btn.*=.*" 'input_menu_toggle_btn = "nul"'

#dpad mode analogue
for i in $(seq 1 16); do
lineinfile $RARCHCFG "input_player${i}_analog_dpad_mode.*=.*" "input_player${i}_analog_dpad_mode = \"1\""
done

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME $RARCHFLD
EOF

# Configure ES DE to point alternative emus
mkdir -p ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/gc/
cat <<EOF | tee ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/gc/gamelist.xml
<?xml version="1.0"?>
<alternativeEmulator>
	<label>Dolphin (Standalone)</label>
</alternativeEmulator>
<gameList>
</gameList>
EOF

mkdir -p ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/wii/
cat <<EOF | tee ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/wii/gamelist.xml
<?xml version="1.0"?>
<alternativeEmulator>
	<label>Dolphin (Standalone)</label>
</alternativeEmulator>
<gameList>
</gameList>
EOF

mkdir -p ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/psx/
cat <<EOF | tee ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/psx/gamelist.xml
<?xml version="1.0"?>
<alternativeEmulator>
	<label>PCSX ReARMed</label>
</alternativeEmulator>
<gameList>
</gameList>
EOF


mkdir -p ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/ps2/
cat <<EOF | tee ${ROOTFS}/home/${TARGET_USERNAME}/ES-DE/gamelists/ps2/gamelist.xml
<?xml version="1.0"?>
<alternativeEmulator>
	<label>PCSX2 (Standalone)</label>
</alternativeEmulator>
<gameList />
EOF

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/ES-DE
EOF

# ### Per controller settings

# PS3 controller 1356:616
export CTRLCFG=${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Sony-PlayStation3-DualShock3-Controller-USB.cfg
# export CTRLCFG=/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Sony-PlayStation3-DualShock3-Controller-USB.cfg
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "10"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "9"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "2"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "3"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'
lineinfile "$CTRLCFG" "input_menu_toggle_btn.*=.*" 'input_menu_toggle_btn = "5"'

# PS4 controller bluetooth
export CTRLCFG="${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Sony-PlayStation4-DualShock4v2-Controller.cfg"
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_device.*=.*" 'input_device = "Wireless Controller"'
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "10"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "9"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "2"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "3"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'
lineinfile "$CTRLCFG" "input_menu_toggle_btn.*=.*" 'input_menu_toggle_btn = "5"'

# Xbox 360 Controller
export CTRLCFG="${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Microsoft X-Box 360 pad.cfg"
# export CTRLCFG="/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Microsoft X-Box 360 pad.cfg"
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "8"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "7"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "3"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "2"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'
lineinfile "$CTRLCFG" "input_menu_toggle_btn.*=.*" 'input_menu_toggle_btn = "5"'


# "ShanWan PS3/PC Wired GamePad 8380:21760
export CTRLCFG="${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Spartan Gear Oplon.cfg"
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "12"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "11"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "4"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "3"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'
lineinfile "$CTRLCFG" "input_menu_toggle_btn.*=.*" 'input_menu_toggle_btn = "7"'

# BETOP AX1 BFM 8380:21760
export CTRLCFG="${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/BETOP_AX1_BFM.cfg"
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "12"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "11"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "4"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "3"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'

# configure cores options
mkdir -p "${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/config/Beetle PSX HW/"
wget -O "${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/config/Beetle PSX HW/Beetle PSX HW.opt" "https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/Beetle PSX HW/Beetle PSX HW.opt"

mkdir -p "${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/config/PCSX-ReARMed/"
wget -O "${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/config/PCSX-ReARMed/PCSX-ReARMed.opt" "https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/PCSX-ReARMed/PCSX-ReARMed.opt"



cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME ${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch
EOF

# configure PCSX2

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/inis
wget -O ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/inis/PCSX2.ini https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation//pcsx2/PCSX2.ini

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/memcards
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/sstates
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/PCSX2/covers

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/PCSX2
EOF

# configure dolphin emulator
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu/
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/GC
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.var/app/org.DolphinEmu.dolphin-emu/data/dolphin-emu/Wii

dolconfigs="
Dolphin.ini
GCPadNew.ini
GFX.ini
GCPadNew.ini
WiimoteNew.ini
Hotkeys.ini
"

for fname in $dolconfigs ; do
curl -Lo ${ROOTFS}/home/$TARGET_USERNAME/.var/app/org.DolphinEmu.dolphin-emu/config/dolphin-emu/$fname https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/dolphin-emu/$fname
done

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.var
EOF

#configure cemu wiiu emulator
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/Cemu
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/Cemu/controllerProfiles
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.local/share/Cemu/mlc01

cemuconfigs="
settings.xml
controllerProfiles/controller0.xml
"

for fname in $cemuconfigs ; do
curl -Lo ${ROOTFS}/home/$TARGET_USERNAME/.config/Cemu/$fname https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/cemu/$fname
done

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME ${ROOTFS}/home/$TARGET_USERNAME/.config/Cemu
    chown -R $TARGET_USERNAME:$TARGET_USERNAME ${ROOTFS}/home/$TARGET_USERNAME/.local/share/Cemu
EOF
}

isyncthing(){
    
cd ~
git clone https://github.com/alainpham/lab.git
cd lab
touch secret
source initlab
lab run syncthing
curl http://192.168.8.100:28000/secret.sh | sh

    
API_KEY=$(docker exec syncthing cat /var/syncthing/config/config.xml | grep -oP '(?<=<apikey>).*?(?=</apikey>)')

# ##### SET DEVICE NAME

# Get local device ID (try config file first, fall back to system status)
MY_ID=$(curl -s -H "X-API-Key: $API_KEY" http://localhost:8384/rest/system/status | grep -oP '"myID"\s*:\s*"\K[^"]+')

curl -X PATCH \
  -H "X-API-Key: $API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"name\": \"$HOSTNAME\"}" \
  http://localhost:8384/rest/config/devices/$MY_ID

echo "Requested rename of device $MY_ID -> $DEVICE_NAME"
# ##### END SET DEVICE NAME

# ##### ADD DEVICE ON CENTRAL SERVER
DEVICE_JSON=$(cat <<EOF
{
    "deviceID": "$MY_ID",
    "name": "$HOSTNAME",
    "autoAcceptFolders": true
}
EOF
)

curl -s -X POST \
    -H "X-API-Key: $CENTRAL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$DEVICE_JSON" \
    http://192.168.8.100:8384/rest/config/devices
# ##### ADD DEVICE ON CENTRAL SERVER


# Define key+folder list (format: id|path). Add as many lines as needed.
entries=(
    "retroarch-saves|/var/syncthing/saves"
    "retroarch-states|/var/syncthing/states"
    "downloaded-media|/var/syncthing/downloaded_media"
    "pcsx2-memcards|/var/syncthing/PCSX2/memcards"
    "pcsx2-sstates|/var/syncthing/PCSX2/sstates"
    "pcsx2-covers|/var/syncthing/PCSX2/covers"
    "gc-saves|/var/syncthing/GC"
    "wii-saves|/var/syncthing/Wii"
    "cemu-saves|/var/syncthing/cemu"
)

# Loop through list, build JSON and POST each folder to the Syncthing API
for entry in "${entries[@]}"; do
    FOLDER_ID="${entry%%|*}"
    PATH_ON_HOST="${entry#*|}"

docker exec syncthing syncthing cli config folders add --id $FOLDER_ID --path $PATH_ON_HOST
docker exec syncthing syncthing cli config folders $FOLDER_ID devices add --device-id $REMOTE_ID
done



}

iautologin(){
trap 'return 1' ERR
if [ "$OSNAME" = "devuan" ]; then
lineinfile ${ROOTFS}/etc/inittab "1.2345.respawn./sbin/getty.*tty1" "1:2345:respawn:/sbin/getty --autologin ${TARGET_USERNAME} --noclear 38400 tty1"
fi

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then

lineinfile $ROOTFS/etc/systemd/logind.conf ".*NAutoVTs.*" "NAutoVTs=1"
lineinfile $ROOTFS/etc/systemd/logind.conf ".*ReserveVT.*" "ReserveVT=2"

mkdir -p $ROOTFS/etc/systemd/system/getty@tty1.service.d/
cat << EOF | tee ${ROOTFS}/etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/sbin/getty --autologin ${TARGET_USERNAME} --noclear %I \$TERM
EOF
fi
}

istartx(){
trap 'return 1' ERR
lineinfile ${ROOTFS}/home/$TARGET_USERNAME/.bashrc .*startx.* '[ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && startx'
}

icorporate(){
trap 'return 1' ERR
## corporate apps
if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then

# install zoom
mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/zoom_amd64.deb https://zoom.us/client/${ZOOM_VERSION}/zoom_amd64.deb
cat << EOF | chroot ${ROOTFS}
    apt install -y /opt/debs/zoom_amd64.deb
EOF


fi

if [ "$OSNAME" = "openmandriva" ]; then


mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/zoom.rpm "https://zoom.us/client/${ZOOM_VERSION}/zoom_x86_64.rpm"
cat << EOF | chroot ${ROOTFS}
    dnf install -y /opt/debs/zoom.rpm
EOF

fi

}

ivirt() {
trap 'return 1' ERR
echo "virtualization tools"

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y qemu-system qemu-utils virtinst libvirt-clients libvirt-daemon-system libguestfs-tools bridge-utils libosinfo-bin virt-manager genisoimage
    adduser $TARGET_USERNAME libvirt
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y qemu-kvm qemu-system-x86 qemu-img virt-install libvirt-utils libvirt-utils libguestfs bridge-utils libosinfo-common virt-manager genisoimage
    usermod -a -G libvirt $TARGET_USERNAME
EOF
fi


gitroot=https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/vms
files="vmcr vmcrs vmcrm vmcrl vmdl vmls vmsh vmip"
for file in $files ; do
    curl -Lo ${ROOTFS}/usr/local/bin/$file $gitroot/$file
    chmod 755 ${ROOTFS}/usr/local/bin/$file
done

cat << EOF | chroot ${ROOTFS}
    mkdir -p /home/${TARGET_USERNAME}/ssh
    if [ ! -f /home/${TARGET_USERNAME}/ssh/vm ]; then
        ssh-keygen -f /home/${TARGET_USERNAME}/ssh/vm -N ""
    fi

    chown -R ${TARGET_USERNAME}:${TARGET_USERNAME} /home/${TARGET_USERNAME}/.ssh/vm*
    
    mkdir -p /home/${TARGET_USERNAME}/virt/images
    mkdir -p /home/${TARGET_USERNAME}/virt/runtime
    chown -R ${TARGET_USERNAME}:${TARGET_USERNAME} /home/${TARGET_USERNAME}/virt
    chown -R ${TARGET_USERNAME}:${TARGET_USERNAME} /home/${TARGET_USERNAME}/ssh
EOF

# first boot script
cat <<EOF | tee ${ROOTFS}/usr/local/bin/firstboot-virt.sh
#!/bin/bash
echo "Setting up network for virtualization.."
if [[ -z "\$(virsh net-list | grep default)" ]] then
     virsh net-autostart default
     virsh net-start default
     echo "net autostart activated"
     echo "default net autostart activated !">/var/log/firstboot-virt.log
else
     echo "net exists"
     echo "default already autostarted ! ">/var/log/firstboot-virt.log
fi
EOF

chmod 755 ${ROOTFS}/usr/local/bin/firstboot-virt.sh

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then

cat <<EOF | tee ${ROOTFS}/etc/systemd/system/firstboot-virt.service
[Unit]
Description=firstboot-virt
Requires=network.target libvirtd.service
After=network.target libvirtd.service

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/bin/firstboot-virt.sh
RemainAfterExit=yes


[Install]
WantedBy=multi-user.target
EOF

cat << EOF | chroot ${ROOTFS}
    systemctl enable firstboot-virt.service
EOF

fi


if [ "$OSNAME" = "devuan" ]; then

cat <<'EOF' | tee ${ROOTFS}/etc/init.d/firstboot-virt
#!/bin/sh
### BEGIN INIT INFO
# Provides:          firstboot-virt
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Expand filesystem on first boot
### END INIT INFO

case "$1" in
  start)
    /usr/local/bin/firstboot-virt.sh
    ;;
  stop)
    echo "Firstboot script has run"
    ;;
  *)
    echo "Usage: /etc/init.d/firstboot-virt {start|stop}"
    exit 1
    ;;
esac

exit 0
EOF

cat << 'EOF' | chroot ${ROOTFS}
    chmod 755 /etc/init.d/firstboot-virt
    update-rc.d firstboot-virt defaults
EOF
fi

}

isecret(){
    trap 'return 1' ERR
    if [ -f ".secret/run.sh" ]; then
        echo "Running .secret/run.sh"
        bash .secret/run.sh
    else
        echo ".secret/run.sh does not exist"
    fi
}

itimezone(){
trap 'return 1' ERR
cat << EOF | chroot ${ROOTFS}
    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE > /etc/timezone
EOF
}

cleanupapt() {
trap 'return 1' ERR
echo "cleaning up"
cat << EOF | chroot ${ROOTFS}
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOF
}

unmountraw() {
echo "Unmounting filesystems"
mv ${ROOTFS}/etc/resolv.conf.back ${ROOTFS}/etc/resolv.conf
umount -R ${ROOTFS}/
losetup -D
}

init() {
    trap 'return 1' ERR
    # Set the default values
    inputversions
    inputtasks $@
}

initdefault(){
    trap 'return 1' ERR
    init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
}

iupbashaliases(){
    trap 'return 1' ERR
    init $TARGET_USERNAME "NA" "authorized_keys" "NA" "NA" "NA" "$KEYBOARD_LAYOUT" "$KEYBOARD_MODEL"
    bashaliases 1
}

# update all non apt stuff and
iupdate(){
    trap 'return 1' ERR
    init $TARGET_USERNAME "NA" "authorized_keys" "NA" "NA" "NA" "$KEYBOARD_LAYOUT" "$KEYBOARD_MODEL"
    bashaliases 1
    imaven 1
    ikube 1
    iappimages 1
    iemulation 1
}

###############################
##### MAIN FUNCTIONS ##########
###############################

# Model to run all the script
all(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
mountraw
bashaliases
createuser
setpasswd
authkeys
rmnouveau
rmbroadcom
fastboot
disableturbo
firstbootexpandfs
smalllogs
reposrc
iaptproxy
iessentials
isshkey
isudo
allowsshpwd
ikeyboard
itouchpad
idev
idocker
ikube
isecret
invidia
igui
iffmpeg
inumlocktty
itheming
iworkstation
ivirt
iemulation
iautologin
istartx
itimezone
inetworking
cleanupapt
unmountraw
reboot
}

cloudvm_common(){
trap 'return 1' ERR
bashaliases
smalllogs
iessentials
idocker
ikube
}

gcpvm(){
trap 'return 1' ERR
init alain_pham_grafana_com "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
cloudvm_common
reboot
}

ovm(){
trap 'return 1' ERR
init apham "NA" "/home/ubuntu/.ssh/authorized_keys" "NA" "NA" "NA" "fr" "pc105"
createuser
authkeys
isshkey
isudo
cloudvm_common
reboot
}

alpinevm(){
trap 'return 1' ERR
cat <<EOF | tee /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
EOF
apk update
apk add curl git dmidecode bash bash-completion sudo
sed -i 's|/bin/sh|/bin/bash|' /etc/passwd
init apham "p" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
createuser
setpasswd
isshkey
isudo
cloudvm_common
reboot
}

dlraw(){

# imageurl=https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.raw

imageurl=https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
curl -Lo /home/apham/virt/images/lnsvr-orig.img $imageurl
qemu-img convert -f qcow2 -O raw /home/apham/virt/images/lnsvr-orig.img /home/apham/virt/images/lnsvr-orig.raw
}

rawkube(){
trap 'return 1' ERR

init apham p /home/apham/.ssh/authorized_keys /home/apham/virt/images/lnsvr-orig.raw /home/apham/virt/images/lnsvr.raw 8G  "fr" "pc105"
export OSNAME=ubuntu
mountraw
bashaliases
createuser
setpasswd
authkeys
fastboot
firstbootexpandfs
smalllogs
reposrc
iessentials
isshkey
isudo
allowsshpwd
ikeyboard
idev
idocker
ikube
isecret
cleanupapt
unmountraw
if [ -f /home/apham/virt/images/d12-kube.qcow2 ]; then
    rm /home/apham/virt/images/d12-kube.qcow2
fi
qemu-img convert -f raw -O qcow2 /home/apham/virt/images/lnsvr.raw /home/apham/virt/images/lnsvr.qcow2
}

desktop_common(){
trap 'return 1' ERR
bashaliases
fastboot
smalllogs
reposrc
iessentials
isudo
ikeyboard
itouchpad
idev
idocker
ikube
igui
iffmpeg
inumlocktty
itheming
iworkstation
ivirt
iemulation
iautologin
istartx
itimezone
inetworking
}

laptop_common(){
trap 'return 1' ERR
desktop_common
disableturbo
}

macs_common(){
trap 'return 1' ERR
laptop_common
rmbroadcom
}

ubvm(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
desktop_common
reboot
}

macus(){
trap 'return 1' ERR
modprobe -r b43 brcmsmac
init apham "NA" "authorized_keys" "NA" "NA" "NA" "us" "macbook79"
macs_common
reboot
}

macfr(){
trap 'return 1' ERR
modprobe -r b43 brcmsmac
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "macbook79"
macs_common
reboot
}

aaon(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
laptop_common
reboot
}

aaon_postinstall(){
# install apt cacher ng.
# create ssh keys -> github
# mount disks to good mediafolder.
# auth to ghcr.io & docker
# setup wireguard client

# /etc/fstab 
# /dev/disk/by-label/m01  /media/m01      ext4    defaults,nofail   0 0
# /dev/disk/by-label/m02  /media/m02      ext4    defaults,nofail   0 0
# /dev/disk/by-label/m03  /media/m03      ext4    defaults,nofail   0 0

ln -s /media/m01/apps/media-content /home/$TARGET_USERNAME/apps/media-content/m01
ln -s /media/m02/apps/media-content /home/$TARGET_USERNAME/apps/media-content/m02
ln -s /media/m02/apps/media-content /home/$TARGET_USERNAME/apps/media-content/m03

rm -rf /home/$TARGET_USERNAME/.config/retroarch/saves
cp -r /media/m03/apps/retroarch/saves  /home/$TARGET_USERNAME/.config/retroarch/saves
rm -rf /home/$TARGET_USERNAME/.config/retroarch/states
cp -r /media/m03/apps/retroarch/states  /home/$TARGET_USERNAME/.config/retroarch/states

}

fujb(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
desktop_common
reboot
}

fujb_postinstall(){
trap 'return 1' ERR
echo "Post Fujitsu setup"
# install decklink drivers
wget http://192.168.8.100:28000/blackmagic/drivers/desktopvideo_12.9a3_amd64.deb
wget http://192.168.8.100:28000/blackmagic/drivers/desktopvideo-gui_12.9a3_amd64.deb
sudo mv desktopvideo_12.9a3_amd64.deb /opt/debs/desktopvideo_12.9a3_amd64.deb
sudo mv desktopvideo-gui_12.9a3_amd64.deb /opt/debs/desktopvideo-gui_12.9a3_amd64.deb

sudo apt install -y /opt/debs/desktopvideo_12.9a3_amd64.deb /opt/debs/desktopvideo-gui_12.9a3_amd64.deb
wget -O /tmp/blackmagic-io-12.9a3-001-fix_for_kernel_6.8.patch https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/decklink/blackmagic-io-12.9a3-001-fix_for_kernel_6.8.patch
cd /usr/src/
patch -p1 /tmp/blackmagic-io-12.9a3-001-fix_for_kernel_6.8.patch
sudo dkms autoinstall -k $(uname -r)

}

hped(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
desktop_common
reboot
}

# old macbook pro
ombp(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "us" "pc105"
desktop_common
reboot
}


# dell G15
lg15(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
laptop_common
reboot
}

lg15_postinstall(){
trap 'return 1' ERR
sudo ubuntu-drivers install
reboot
}

# lenovo w541
leol(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
laptop_common
rmnouveau
reboot
}

# lenovo T14 amd ubuntu workstation for work
lpro(){
trap 'return 1' ERR
init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr" "pc105"
bashaliases
fastboot
smalllogs
reposrc
iessentials
itouchpad
idev
idocker
ikube
igui
inumlocktty
itheming
iworkstation
istartx
ivirt
itimezone
inetworking
reboot
}

lpro_postinstall(){
    trap 'return 1' ERR
    snap install firefox
    snap install slack

    sudo -u $TARGET_USERNAME lineinfile ${ROOTFS}/home/$TARGET_USERNAME/.local/share/dwm/autostart.sh ".*slack.*" 'sleep 5 \&\& slack \&'

    echo "make sure to install kolide"
    mkdir -p ~/ssh/
    cp ~/.ssh/id_ed25519* ~/ssh/
    ssh-keygen -p ~/.ssh/id_ed25519

    git config core.sshCommand 'ssh -i /home/apham/ssh/id_ed25519'

    echo '/usr/bin/ssh -i ~/ssh/id_ed25519 $@' | sudo tee /usr/local/bin/ssh
    sudo chmod 755 /usr/local/bin/ssh
    echo '/usr/bin/scp -i ~/ssh/id_ed25519 $@' | sudo tee /usr/local/bin/scp
    sudo chmod 755 /usr/local/bin/scp
    echo '/usr/bin/sshfs -o ssh_command=/usr/local/bin/ssh $@' | sudo tee /usr/local/bin/sshfs
    sudo chmod 755 /usr/local/bin/sshfs



    #install gcp
    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates gnupg curl
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

    sudo apt-get update && sudo apt-get install google-cloud-cli

    #ffmpeg
    sudo wget -O /usr/local/bin/ffmpeg http://192.168.8.100:28000/blackmagic/ffmpeg_ubuntu
    sudo wget -O /usr/local/bin/ffprobe http://192.168.8.100:28000/blackmagic/ffprobe_ubuntu

    sudo chmod 755 /usr/local/bin/ffmpeg
    sudo chmod 755 /usr/local/bin/ffprobe
}


emulation_postinstall(){
    isyncthing
}