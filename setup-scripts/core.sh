#!/bin/bash
# this is a script to install raw vm images, baremetal machines/laptops or cloud vms

inputversions() {
    trap 'return 1' ERR

    # https://github.com/docker/buildx/releases
    export DOCKER_BUILDX_VERSION=v0.24.0
    echo "export DOCKER_BUILDX_VERSION=${DOCKER_BUILDX_VERSION}"
    
    # https://kubernetes.io/releases/  https://cloud.google.com/kubernetes-engine/docs/release-notes
    export MAJOR_KUBE_VERSION=v1.32
    echo "export MAJOR_KUBE_VERSION=${MAJOR_KUBE_VERSION}"
    
    export K3S_VERSION="v1.32.5+k3s1"
    echo "export K3S_VERSION=${MAJOR_KUBE_VERSION}"

    # https://github.com/derailed/k9s/releases
    export K9S_VERSION=v0.50.6
    echo "export K9S_VERSION=${K9S_VERSION}"
    
    # https://maven.apache.org/download.cgi
    export MVN_VERSION=3.9.10
    echo "export MVN_VERSION=${MVN_VERSION}"

    export NERDFONTS="Noto "
    echo "export NERDFONTS=${NERDFONTS}"

    ### Corporate software
    # https://zoom.us/download?os=linux 
    export ZOOM_VERSION=6.4.10.2027
    echo "export ZOOM_VERSION=${ZOOM_VERSION}"
    
    # https://slack.com/release-notes/linux
    export SLACK_VERSION=4.44.60
    echo "export SLACK_VERSION=${SLACK_VERSION}"

    # https://github.com/IsmaelMartinez/teams-for-linux/releases/latest
    export TEAMS_VERSION=2.0.13
    echo "export TEAMS_VERSION=${TEAMS_VERSION}"

    # https://github.com/sindresorhus/caprine/releases/tag/v2.60.3
    export CAPRINE_VERSION=2.60.3
    echo "export CAPRINE_VERSION=${CAPRINE_VERSION}"

    # https://hub.docker.com/r/infinityofspace/certbot_dns_duckdns/tags
    export CERTBOT_DUCKDNS_VERSION=v1.6
    echo "export CERTBOT_DUCKDNS_VERSION=${CERTBOT_DUCKDNS_VERSION}"
    ### Corporate software

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
    export DRAWIO_VERSION=27.0.5
    echo "export DRAWIO_VERSION=${DRAWIO_VERSION}"

    # https://www.onlyoffice.com/download-desktop.aspx
    export ONLYOFFICE_VERSION=v8.3.3
    echo "export ONLYOFFICE_VERSION=${ONLYOFFICE_VERSION}"

    # https://kdenlive.org/download/
    export KDENLIVE_MAIN_VERSION=25.04
    echo "export KDENLIVE_MAIN_VERSION=${KDENLIVE_MAIN_VERSION}"
    export KDENLIVE_FULL_VERSION=25.04.1
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

    # https://gitlab.com/librewolf-community/browser/appimage/-/releases
    export LIBREWOLF_VERSION=138.0.4-1
    echo "export LIBREWOLF_VERSION=${LIBREWOLF_VERSION}"
    
    ## end appimages

    # https://github.com/yshui/picom/releases
    export PICOM_VERSION=12.5
    echo "export PICOM_VERSION=${PICOM_VERSION}"

    # https://github.com/Hummer12007/brightnessctl/releases
    export BRIGHTNESSCTL_VERSION=0.5.1
    echo "export BRIGHTNESSCTL_VERSION=${BRIGHTNESSCTL_VERSION}"

    # https://github.com/naelstrof/slop/releases
    export SLOP_VERSION=7.6
    echo "export SLOP_VERSION=${SLOP_VERSION}"

    # https://github.com/naelstrof/maim/releases
    export MAIM_VERSION=5.8.0
    echo "export MAIM_VERSION=${MAIM_VERSION}"
    # https://gitlab.com/es-de/emulationstation-de/-/releases
    export ESDE_VERSION=3.2.0
    echo "export ESDE_VERSION=${ESDE_VERSION}"
    export ESDE_VERSION_ID=184126704
    echo "export ESDE_VERSION_ID=${ESDE_VERSION_ID}"

    # https://buildbot.libretro.com/stable/
    export RETROARCH_VERSION=1.21.0
    echo "export RETROARCH_VERSION=${RETROARCH_VERSION}"

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

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ] ; then
    export BASHRC="/etc/bash.bashrc"
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
lineinfile ${ROOTFS}${BASHRC} ".*export.*DOCKER_BUILDX_VERSION*=.*" "export DOCKER_BUILDX_VERSION=${DOCKER_BUILDX_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MAJOR_KUBE_VERSION*=.*" "export MAJOR_KUBE_VERSION=${MAJOR_KUBE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*K3S_VERSION*=.*" "export K3S_VERSION=${K3S_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*K9S_VERSION*=.*" "export K9S_VERSION=${K9S_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MVN_VERSION*=.*" "export MVN_VERSION=${MVN_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*NERDFONTS*=.*" "export NERDFONTS=\"${NERDFONTS}\""
lineinfile ${ROOTFS}${BASHRC} ".*export.*ZOOM_VERSION*=.*" "export ZOOM_VERSION=${ZOOM_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MLVAPP_VERSION*=.*" "export MLVAPP_VERSION=${MLVAPP_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*BEEREF_VERSION*=.*" "export BEEREF_VERSION=${BEEREF_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*FREAC_VERSION*=.*" "export FREAC_VERSION=${FREAC_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*TEAMS_VERSION*=.*" "export TEAMS_VERSION=${TEAMS_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*CAPRINE_VERSION*=.*" "export CAPRINE_VERSION=${CAPRINE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*DRAWIO_VERSION*=.*" "export DRAWIO_VERSION=${DRAWIO_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*CERTBOT_DUCKDNS_VERSION*=.*" "export CERTBOT_DUCKDNS_VERSION=${CERTBOT_DUCKDNS_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*ONLYOFFICE_VERSION*=.*" "export ONLYOFFICE_VERSION=${ONLYOFFICE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SLACK_VERSION*=.*" "export SLACK_VERSION=${SLACK_VERSION}"

lineinfile ${ROOTFS}${BASHRC} ".*export.*PICOM_VERSION*=.*" "export PICOM_VERSION=${PICOM_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*BRIGHTNESSCTL_VERSION*=.*" "export BRIGHTNESSCTL_VERSION=${BRIGHTNESSCTL_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SLOP_VERSION*=.*" "export SLOP_VERSION=${SLOP_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*MAIM_VERSION*=.*" "export MAIM_VERSION=${MAIM_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KDENLIVE_MAIN_VERSION*=.*" "export KDENLIVE_MAIN_VERSION=${KDENLIVE_MAIN_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KDENLIVE_FULL_VERSION*=.*" "export KDENLIVE_FULL_VERSION=${KDENLIVE_FULL_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*SPEEDCRUNCH_VERSION*=.*" "export SPEEDCRUNCH_VERSION=${SPEEDCRUNCH_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*AVIDEMUX_VERSION*=.*" "export AVIDEMUX_VERSION=${AVIDEMUX_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*LOCALSEND_VERSION*=.*" "export LOCALSEND_VERSION=${LOCALSEND_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*LIBREWOLF_VERSION*=.*" "export LIBREWOLF_VERSION=${LIBREWOLF_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*ESDE_VERSION*=.*" "export ESDE_VERSION=${ESDE_VERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*ESDE_VERSION_ID*=.*" "export ESDE_VERSION_ID=${ESDE_VERSION_ID}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*RETROARCH_VERSION*=.*" "export RETROARCH_VERSION=${RETROARCH_VERSION}"

lineinfile ${ROOTFS}${BASHRC} ".*export.*OSNAME*=.*" "export OSNAME=${OSNAME}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*OSVERSION*=.*" "export OSVERSION=${OSVERSION}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*WILDCARD_DOMAIN*=.*" "export WILDCARD_DOMAIN=zez.duckdns.org"
lineinfile ${ROOTFS}${BASHRC} ".*export.*EMAIL*=.*" "export EMAIL=admin@zez.duckdns.org"
lineinfile ${ROOTFS}${BASHRC} ".*export.*DUCKDNS_TOKEN*=.*" "export DUCKDNS_TOKEN=xxxx-xxxx-xxxx-xxxx-xxxx"
lineinfile ${ROOTFS}${BASHRC} ".*export.*PRODUCT_NAME*=.*" "export PRODUCT_NAME='${PRODUCT_NAME}'"
lineinfile ${ROOTFS}${BASHRC} ".*export.*TIMEZONE*=.*" "export TIMEZONE=${TIMEZONE}"
lineinfile ${ROOTFS}${BASHRC} ".*export.*KEYBOARD_LAYOUT*=.*" "export KEYBOARD_LAYOUT=${KEYBOARD_LAYOUT}"

lineinfile ${ROOTFS}${BASHRC} ".*export.*APT_PROXY*=.*" "export APT_PROXY='${APT_PROXY}'"

echo "bash aliases setup finished"
}

mountraw() {
    trap 'return 1' ERR

    # name devices
    export DEVICE=/dev/loop0
    export ROOTFS="/tmp/installing-rootfs"

    # resize image
    cp $INPUT_IMG $OUTPUT_IMAGE
    qemu-img  resize -f raw $OUTPUT_IMAGE $DISK_SIZE

    # setup loopback
    losetup -D 
    losetup -fP $OUTPUT_IMAGE

    # fix partition
    printf "fix\n" | parted ---pretend-input-tty $DEVICE print
    growpart ${DEVICE} 1
    resize2fs ${DEVICE}p1

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
}

createuser() {
trap 'return 1' ERR

echo "setup users"
cat << EOF | chroot ${ROOTFS}
    /usr/sbin/useradd -m -s /bin/bash $TARGET_USERNAME
    mkdir -p /home/${TARGET_USERNAME}/.ssh
    chown -R ${TARGET_USERNAME}:${TARGET_USERNAME} /home/${TARGET_USERNAME}/.ssh
EOF
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

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ] ; then
echo debian
# accelerate grub startup
mkdir -p ${ROOTFS}/etc/default/grub.d/
echo 'GRUB_TIMEOUT=1' | tee ${ROOTFS}/etc/default/grub.d/15_timeout.cfg
lineinfile ${ROOTFS}/etc/default/grub ".*GRUB_TIMEOUT=.*" 'GRUB_TIMEOUT=1'
fi

if [ "$OSNAME" = "openmandriva" ]; then
echo openmandriva
lineinfile ${ROOTFS}/etc/default/grub ".*GRUB_TIMEOUT=.*" 'GRUB_TIMEOUT=1'
fi

update-grub2


echo "fastboot activated"

}

disableturbo() {
# disable turbo boost
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
    apt install -y sudo git tmux vim curl wget rsync ncdu dnsutils bmon htop bash-completion gpg whois haveged zip unzip virt-what wireguard iptables jq sshfs iotop
    apt install -y systemd-timesyncd
    DEBIAN_FRONTEND=noninteractive apt install -y cloud-guest-utils openssh-server console-setup iperf3
EOF
fi

if [ "$OSNAME" = "devuan" ]; then
cat << EOF | chroot ${ROOTFS}
    apt -y update 
    apt install -y ncurses-term
    apt -y upgrade
    apt install -y sudo git tmux vim curl wget rsync ncdu dnsutils bmon htop bash-completion gpg whois haveged zip unzip virt-what wireguard iptables jq sshfs iotop
    DEBIAN_FRONTEND=noninteractive apt install -y cloud-guest-utils openssh-server console-setup iperf3
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
    dnf install -y sudo git tmux vim curl wget rsync ncdu bind-utils htop bash-completion gnupg2 whois zip unzip virt-what wireguard-tools iptables jq sshfs
    dnf install -y cloud-utils openssh-server console-setup
EOF
fi

echo "essentials installed"

cat << EOF | chroot ${ROOTFS}
    git config --global core.editor "vim"
EOF

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
XKBMODEL="pc105"
XKBLAYOUT="${KEYBOARD_LAYOUT}"
EOF
echo "keyboard setup finished"

if [[ "$(dmidecode -t 1 | grep 'Product Name')" == *"MacBook"* ]]; then
cat <<EOF | tee ${ROOTFS}/etc/default/keyboard
XKBMODEL="macbook79"
XKBLAYOUT="${KEYBOARD_LAYOUT}"
EOF
fi

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
git clone https://github.com/bulletmark/libinput-gestures.git
cd libinput-gestures
./libinput-gestures-setup install

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt -y install libinput-tools wmctrl
    adduser $TARGET_USERNAME input
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

idockerbuildx(){
trap 'return 1' ERR

force_reinstall=${1:-0}

if [ -f "${ROOTFS}/usr/lib/docker/cli-plugins/docker-buildx" ] && [ "$force_reinstall" = "0" ]; then
    echo "docker buildx already installed, skipping"
    return 0
fi

mkdir -p ${ROOTFS}/usr/lib/docker/cli-plugins
curl -SL https://github.com/docker/buildx/releases/download/${DOCKER_BUILDX_VERSION}/buildx-${DOCKER_BUILDX_VERSION}.linux-amd64 -o ${ROOTFS}/usr/lib/docker/cli-plugins/docker-buildx
chmod 755 ${ROOTFS}/usr/lib/docker/cli-plugins/docker-buildx

}

idocker() {
trap 'return 1' ERR

force_reinstall=${1:-0}

echo "install docker"

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y docker.io python3-docker docker-compose skopeo
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

if [ "$OSNAME" = "openmandriva" ]; then

cat << EOF | chroot ${ROOTFS}
    dnf install -y docker python-docker docker-compose skopeo
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

idockerbuildx $force_reinstall

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

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
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
    echo "docker buildx already installed, skipping"
    return 0
fi

echo "install kube"

cat << EOF | chroot ${ROOTFS}
    curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE="true" INSTALL_K3S_SKIP_START="true" INSTALL_K3S_VERSION="${K3S_VERSION}" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="server --disable=servicelb,traefik" sh -
EOF

cat << EOF | chroot ${ROOTFS}
    curl -fsSL -o /tmp/get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 755 /tmp/get_helm.sh
    /tmp/get_helm.sh
EOF

cat << EOF | chroot ${ROOTFS}
    kubectl completion bash | tee /etc/bash_completion.d/kubectl > /dev/null
    helm completion bash | tee /etc/bash_completion.d/helm > /dev/null
EOF

cat << EOF | chroot ${ROOTFS}
    curl -LO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
    tar -xzvf k9s_Linux_amd64.tar.gz  -C /usr/local/bin/ k9s
    chown root:root /usr/local/bin/k9s
    rm -f k9s_Linux_amd64.tar.gz
EOF

kubescript="kubecr kubemon kubeotel"
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

## add other exceptions here to disable numlock at start
if [[ "$(dmidecode -t 1 | grep 'Product Name')" == *"MacBook"* ]]; then
    echo "Running on a MacBook, no numlock"
    return 0
fi


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
    apt install -y make gcc libx11-dev libxft-dev libxrandr-dev libimlib2-dev libfreetype-dev libxinerama-dev xorg numlockx usbutils
    apt install -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils pavucontrol alsa-utils
    apt remove -y xserver-xorg-video-intel
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
    apt install -y ntfs-3g ifuse mousepad mpv haruna vlc cmatrix nmon mesa-utils neofetch feh qimgv network-manager dnsmasq acpitool lm-sensors fonts-noto libnotify-bin dunst ffmpeg mkvtoolnix-gui libfdk-aac2 python3-mutagen imagemagick mediainfo-gui mediainfo arandr picom brightnessctl cups xsane sane-utils filezilla speedcrunch fonts-font-awesome lxappearance breeze-gtk-theme breeze-icon-theme joystick
EOF
fi

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ]; then
cat << EOF | chroot ${ROOTFS}
    apt install -y libsane firefox-esr
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
    dnf install -y ntfs-3g ifuse mousepad mpv haruna vlc nmon neofetch feh qimgv NetworkManager dnsmasq acpitool lm_sensors noto-sans-fonts noto-serif-fonts fonts-ttf-awesome fonts-otf-awesome libnotify dunst ffmpeg mutagen imagemagick mediainfo arandr  cups xsane sane-backends filezilla lxappearance
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


if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << 'EOF' | tee ${ROOTFS}/etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback
EOF
fi

if [ "$OSNAME" = "openmandriva" ] || [ "$OSNAME" = "ubuntu" ]; then
cat <<EOF | chroot ${ROOTFS}
    systemctl disable systemd-resolved
    rm -f ${ROOTFS}/etc/resolv.conf
EOF
fi

if [ "$OSNAME" = "ubuntu" ]; then
#TODO
cat <<EOF | chroot ${ROOTFS}
    rm /etc/netplan/*
    apt -y install ifupdown
    apt -y remove resolvconf
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

# dunst notification
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.config/dunst

if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.config/dunst/dunstrc
[global]
monitor = 2
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
monitor = 2
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
ffmpegscripts="ripscreen.sh riptv.sh ripbm.sh vconv-archive-lossless-h264-vaapi.sh vconv-extract-audio.sh vconv-h264-vaapi-qp.sh vconv-h264-vaapi-vbr.sh vconv-hevc-vaapi-qp.sh vconv-make-mkv.sh vconv-make-mp4.sh vconv-mp3-hq.sh vconv-vp9-vaapi-qp.sh vconv-x264-crf.sh vconv-travel.sh vconv-x264-lowres-lowvbr-2pass.sh vconv-x264-lowres-vbr-2pass.sh vconv-x264-vbr-2pass.sh vconv-mkvmerge.sh vconv-audiosync.sh imdb.sh"
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

# install scripts
gitroot=https://raw.githubusercontent.com/alainpham/debian-os-image/refs/heads/master/scripts/pulseaudio/
files="snd asnd asndenv asnddef csndfoczv csndjbr csndzv csndh6 csndacer csndint clrmix clrmixoff"
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
echo 0 | tee ~/.rebootdwm
export rebootdwm=$(cat ~/.rebootdwm)
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



# Set Thunar as the default file manager
cat << EOF | chroot ${ROOTFS}
    sudo -u $TARGET_USERNAME xdg-mime default Thunar.desktop inode/directory
    sudo -u $TARGET_USERNAME xdg-mime default vlc.desktop video/*
EOF


cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config
EOF

#autostart apps
mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.local/share/dwm
cat << 'EOF' | tee ${ROOTFS}/home/$TARGET_USERNAME/.local/share/dwm/autostart.sh
asnddef &
EOF

cat << EOF | chroot ${ROOTFS}
    chmod 755 /home/$TARGET_USERNAME/.local/share/dwm/autostart.sh
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.local
EOF

inumlocktty
ivmgui
itheming
}

itheming() {

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

# if inside virtual machine
# video=Virtual-1:1600x900

if [ "$hypervisor" = "hyperv" ] || [ "$hypervisor" = "kvm" ]; then
cat << 'EOF' | tee ${ROOTFS}/home/${TARGET_USERNAME}/.config/picom/picom.conf
# picom config
backend = "xrender";
use-damage = false
EOF
fi

cat << EOF | chroot ${ROOTFS}
    chown -R $TARGET_USERNAME:$TARGET_USERNAME ${ROOTFS}/home/${TARGET_USERNAME}/.config/picom
EOF

# Hyperv set resolution
if [ "$hypervisor" = "hyperv" ] ; then
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
    apt install -y handbrake gimp rawtherapee krita mypaint inkscape blender obs-studio mgba-qt easytag audacity
EOF
fi

if [ "$OSNAME" = "openmandriva" ]; then
cat << EOF | chroot ${ROOTFS}
    dnf install -y handbrake gimp rawtherapee krita python-numpy mypaint inkscape blender obs-studio audacity
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

cat << EOF | chroot ${ROOTFS}
    curl -Lo /tmp/obs-studio.tar https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/obs/obs-studio.tar
    tar xvf /tmp/obs-studio.tar -C /home/$TARGET_USERNAME/.config/
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/obs-studio
EOF

iappimages $force_reinstall

}

iappimages(){
trap 'return 1' ERR

# APPimages
force_reinstall=${1:-0}

#kdenlive
if [ ! -f ${ROOTFS}/opt/appimages/kdenlive.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/kdenlive.AppImage https://download.kde.org/stable/kdenlive/${KDENLIVE_MAIN_VERSION}/linux/kdenlive-${KDENLIVE_FULL_VERSION}-x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/kdenlive.AppImage
    ln -sf /opt/appimages/kdenlive.AppImage /usr/local/bin/kdenlive
EOF
else
echo "kdenlive already installed, skipping"
fi

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

# Drawio
if [ ! -f ${ROOTFS}/opt/appimages/drawio.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/drawio.AppImage https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VERSION}/drawio-x86_64-${DRAWIO_VERSION}.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/drawio.AppImage
    ln -sf /opt/appimages/drawio.AppImage /usr/local/bin/drawio
EOF
else
echo "drawio already installed, skipping"
fi

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

# librewolf
if [ ! -f ${ROOTFS}/opt/appimages/librewolf.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/opt/appimages/librewolf.AppImage https://gitlab.com/api/v4/projects/24386000/packages/generic/librewolf/${LIBREWOLF_VERSION}/LibreWolf.x86_64.AppImage
cat << EOF | chroot ${ROOTFS}
    chmod 755 /opt/appimages/librewolf.AppImage
    ln -sf /opt/appimages/librewolf.AppImage /usr/local/bin/librewolf
EOF
else
echo "librewolf already installed, skipping"
fi

}

iemulation(){

force_reinstall=${1:-0}

lineinfile ${ROOTFS}/etc/bluetooth/input.conf ".*ClassicBondedOnly.*" "ClassicBondedOnly=false"

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



# https://buildbot.libretro.com/stable/
if [ ! -f ${ROOTFS}/opt/appimages/RetroArch-Linux-x86_64.AppImage ] || [ "$force_reinstall" = "1" ]; then
wget -O ${ROOTFS}/tmp/RetroArch.7z https://buildbot.libretro.com/stable/${RETROARCH_VERSION}/linux/x86_64/RetroArch.7z
wget -O ${ROOTFS}/tmp/RetroArch_cores.7z https://buildbot.libretro.com/stable/${RETROARCH_VERSION}/linux/x86_64/RetroArch_cores.7z
cd ${ROOTFS}/tmp/
7z x RetroArch.7z
7z x RetroArch_cores.7z

wget -O ${ROOTFS}/tmp/bios.zip https://github.com/Abdess/retroarch_system/releases/download/v20220308/RetroArch_v1.10.1.zip
unzip ${ROOTFS}/tmp/bios.zip 'system/*' -d /tmp/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage.home/.config/retroarch/


cat << EOF | chroot ${ROOTFS}
    mv /tmp/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage /opt/appimages/RetroArch-Linux-x86_64.AppImage
    chmod 755 /opt/appimages/RetroArch-Linux-x86_64.AppImage
    ln -sf /opt/appimages/RetroArch-Linux-x86_64.AppImage /usr/local/bin/retroarch
    rm -rf /home/$TARGET_USERNAME/.config/retroarch
    
    mv /tmp/RetroArch-Linux-x86_64/RetroArch-Linux-x86_64.AppImage.home/.config/retroarch /home/$TARGET_USERNAME/.config/
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/$TARGET_USERNAME/.config/retroarch
EOF
else
echo "RetroArch already installed, skipping"
fi

cat << EOF | chroot ${ROOTFS}
    mkdir -p /home/${TARGET_USERNAME}/ROMs
    mkdir -p /home/${TARGET_USERNAME}/ES-DE/downloaded_media
    mkdir -p /home/${TARGET_USERNAME}/.config/retroarch/states
    mkdir -p /home/${TARGET_USERNAME}/.config/retroarch/saves
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/ROMs
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/ES-DE
    chown -R $TARGET_USERNAME:$TARGET_USERNAME /home/${TARGET_USERNAME}/.config/retroarch
EOF

export RARCHCFG=${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/retroarch.cfg
# export RARCHCFG=/home/$TARGET_USERNAME/.config/retroarch/retroarch.cfg
touch $RARCHCFG
lineinfile $RARCHCFG "video_windowed_fullscreen.*=.*" 'video_windowed_fullscreen = "false"'
lineinfile $RARCHCFG "video_fullscreen.*=.*" 'video_fullscreen = "true"'
lineinfile $RARCHCFG "quit_press_twice.*=.*" 'quit_press_twice = "false"'
lineinfile $RARCHCFG "menu_swap_ok_cancel_buttons.*=.*" 'menu_swap_ok_cancel_buttons = "true"'
lineinfile $RARCHCFG "savestate_auto_index.*=.*" 'savestate_auto_index = "true"'
lineinfile $RARCHCFG "savestate_thumbnail_enable.*=.*" 'savestate_thumbnail_enable = "true"'
# deactivate menu button
lineinfile $RARCHCFG "input_menu_toggle_btn.*=.*" 'input_menu_toggle_btn = "200"'

#dpad mode analogue
for i in $(seq 1 16); do
lineinfile $RARCHCFG "input_player${i}_analog_dpad_mode.*=.*" "input_player${i}_analog_dpad_mode = \"1\""
done

# ### Per controller settings

# PS3 controller
export CTRLCFG=${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Sony-PlayStation3-DualShock3-Controller-USB.cfg
# export CTRLCFG=/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Sony-PlayStation3-DualShock3-Controller-USB.cfg
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "10"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "9"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "2"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "3"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'

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

# "ShanWan PS3/PC Wired GamePad
export CTRLCFG="${ROOTFS}/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Spartan Gear Oplon.cfg"
# export CTRLCFG="/home/$TARGET_USERNAME/.config/retroarch/autoconfig/udev/Microsoft X-Box 360 pad.cfg"
touch "$CTRLCFG"
lineinfile "$CTRLCFG" "input_enable_hotkey_btn.*=.*" 'input_enable_hotkey_btn = "12"'
lineinfile "$CTRLCFG" "input_exit_emulator_btn.*=.*" 'input_exit_emulator_btn = "11"'
lineinfile "$CTRLCFG" "input_load_state_btn.*=.*" 'input_load_state_btn = "4"'
lineinfile "$CTRLCFG" "input_save_state_btn.*=.*" 'input_save_state_btn = "3"'
lineinfile "$CTRLCFG" "input_state_slot_decrease_btn.*=.*" 'input_state_slot_decrease_btn = "0"'
lineinfile "$CTRLCFG" "input_state_slot_increase_btn.*=.*" 'input_state_slot_increase_btn = "1"'

emuscripts="emumount.sh emustop.sh"
for script in $emuscripts ; do
curl -Lo ${ROOTFS}/usr/local/bin/$script https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/emulation/$script
cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/$script
EOF
done


}

iautologin(){
if [ "$OSNAME" = "devuan" ]; then
lineinfile ${ROOTFS}/etc/inittab "1.2345.respawn./sbin/getty.*tty1" "1:2345:respawn:/sbin/getty --autologin ${TARGET_USERNAME} --noclear 38400 tty1"
lineinfile ${ROOTFS}/home/$TARGET_USERNAME/.bashrc .*startx.* '[ -z "$DISPLAY" ] && [ $(tty) = /dev/tty1 ] && startx'
fi
}

icorporate(){
## corporate apps
if [ "$OSNAME" = "debian" ] || [ "$OSNAME" = "devuan" ] || [ "$OSNAME" = "ubuntu" ]; then

# install zoom
mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/zoom_amd64.deb https://zoom.us/client/${ZOOM_VERSION}/zoom_amd64.deb
cat << EOF | chroot ${ROOTFS}
    apt install -y /opt/debs/zoom_amd64.deb
EOF

mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/slack.deb https://downloads.slack-edge.com/desktop-releases/linux/x64/${SLACK_VERSION}/slack-desktop-${SLACK_VERSION}-amd64.deb
cat << EOF | chroot ${ROOTFS}
    apt install -y /opt/debs/slack.deb
EOF

fi

if [ "$OSNAME" = "openmandriva" ]; then


mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/zoom.rpm "https://zoom.us/client/${ZOOM_VERSION}/zoom_x86_64.rpm"
cat << EOF | chroot ${ROOTFS}
    dnf install -y /opt/debs/zoom.rpm
EOF


mkdir -p ${ROOTFS}/opt/debs/
wget -O ${ROOTFS}/opt/debs/slack.rpm https://downloads.slack-edge.com/desktop-releases/linux/x64/${SLACK_VERSION}/slack-${SLACK_VERSION}-0.1.el8.x86_64.rpm
cat << EOF | chroot ${ROOTFS}
    dnf install -y libxscrnsaver1 lib64appindicator3_1
    rpm -ivh ${ROOTFS}/opt/debs/slack.rpm --nodeps
EOF

fi

}

ivirt() {
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


curl -Lo ${ROOTFS}/usr/local/bin/vmcr https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/vms/vmcr
curl -Lo ${ROOTFS}/usr/local/bin/vmdl https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/vms/vmdl
curl -Lo ${ROOTFS}/usr/local/bin/vmls https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/vms/vmls
curl -Lo ${ROOTFS}/usr/local/bin/vmsh https://raw.githubusercontent.com/alainpham/debian-os-image/master/scripts/vms/vmsh

cat << EOF | chroot ${ROOTFS}
    chmod 755 /usr/local/bin/vmcr /usr/local/bin/vmdl /usr/local/bin/vmls /usr/local/bin/vmsh

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
    if [ -f ".secret/run.sh" ]; then
        echo "Running .secret/run.sh"
        bash .secret/run.sh
    else
        echo ".secret/run.sh does not exist"
    fi
}

itimezone(){
cat << EOF | chroot ${ROOTFS}
    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
    echo $TIMEZONE > /etc/timezone
EOF
}

cleanupapt() {
echo "cleaning up"
cat << EOF | chroot ${ROOTFS}
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOF
}

unmountraw() {
echo "Unmounting filesystems"
umount ${ROOTFS}/{dev/pts,boot/efi,dev,run,proc,sys,tmp,}

losetup -D

}

init() {
    # Set the default values
    inputversions
    inputtasks $@
}

initdefault(){
    init apham "NA" "authorized_keys" "NA" "NA" "NA"
}

iupdateworkstation(){
    init apham "NA" "authorized_keys" "NA" "NA" "NA"
    bashaliases
    imaven
    idockerbuild
    ikube
    iappimages
}

###############################
##### MAIN FUNCTIONS ##########
###############################

# Model to run all the script
all(){

init apham "NA" "authorized_keys" "NA" "NA" "NA" "fr"
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
invidia
igui
iworkstation
ivirt
iemulation
iautologin
itimezone
cleanupapt
unmountraw
sudo reboot now
}

# baremetal workstation with virtualization and without nvidia cards
wkstatvrt(){

init $1 "ps" "authorized_keys" "NA" "NA" "NA"
bashaliases
rmnouveau
fastboot
disableturbo
smalllogs
reposrc
iaptproxy
iessentials
isudo
allowsshpwd
itouchpad
idev
idocker
ikube
igui
iworkstation
ivirt
itimezone
sudo reboot now
}

# baremetal workstation without virtualization & nvidia
wkstation(){
if ! [ $# -eq 1 ]; then
    echo "Usage: sudo $0 <1_TARGET_USERNAME>"
    echo "sudo $0 apham"
    return
fi
init $1 "ps" "authorized_keys" "NA" "NA" "NA"
bashaliases
rmnouveau
fastboot
disableturbo
smalllogs
reposrc
iaptproxy
iessentials
isudo
allowsshpwd
itouchpad
idev
idocker
ikube
igui
iworkstation
itimezone
sudo reboot now
}

#full gui server
fullgui(){
if ! [ $# -eq 1 ]; then
    echo "Usage: sudo $0 <1_TARGET_USERNAME>"
    echo "sudo $0 apham"
    return
fi
init $1 "ps" "authorized_keys" "NA" "NA" "NA"
bashaliases
rmnouveau
fastboot
disableturbo
smalllogs
reposrc
iaptproxy
iessentials
isudo
allowsshpwd
idev
idocker
ikube
igui
itimezone
sudo reboot now
}

# for cloud servers like on oci, aws, gcp

debianserver(){
if ! [ $# -eq 1 ]; then
    echo "Usage: sudo $0 <1_TARGET_USERNAME>"
    echo "sudo $0 apham"
    return
fi
init $1 "ps" "authorized_keys" "NA" "NA" "NA"
bashaliases
createuser
authkeys
smalllogs
reposrc
iaptproxy
iessentials
isudo
idev
idocker
ikube
sudo reboot now
}

gcpkube(){
if ! [ $# -eq 1 ]; then
    echo "Usage: sudo $0 <1_TARGET_USERNAME>"
    echo "sudo $0 apham"
    return
fi
init $1 "ps" "authorized_keys" "NA" "NA" "NA"
bashaliases
smalllogs
iessentials
idev
idocker
ikube
sudo reboot now
}

kvmkube(){
init apham "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
smalllogs
reposrc
iaptproxy
iessentials
ikeyboard
inumlocktty
idev
idocker
ikube
sudo reboot now
}

rawkube(){
#curl -Lo /home/apham/virt/images/debian-12-nocloud-amd64.raw https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.raw
init apham p /home/apham/.ssh/authorized_keys /home/apham/virt/images/debian-12-nocloud-amd64.raw /home/apham/virt/images/d12-kube.raw 6G
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
rm /home/apham/virt/images/d12-kube.qcow2
qemu-img convert -f raw -O qcow2 /home/apham/virt/images/d12-kube.raw /home/apham/virt/images/d12-kube.qcow2
}

rawkubeminimal(){
#curl -Lo /home/apham/virt/images/debian-12-nocloud-amd64.raw https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.raw
init apham p /home/apham/.ssh/authorized_keys /home/apham/virt/images/debian-12-nocloud-amd64.raw /home/apham/virt/images/d12-kmin.raw 4G
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
ikube
isecret
cleanupapt
unmountraw
rm /home/apham/virt/images/d12-kmin.qcow2
qemu-img convert -f raw -O qcow2 /home/apham/virt/images/d12-kmin.raw /home/apham/virt/images/d12-kmin.qcow2
}

oboo(){
init apham "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
fastboot
smalllogs
reposrc
iaptproxy
iessentials
isudo
ikeyboard
itouchpad
idev
idocker
ikube
igui
iworkstation
itimezone
sudo reboot
}

oair(){
modprobe -r b43 brcmsmac
init apham "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
rmbroadcom
fastboot
disableturbo
smalllogs
reposrc
iaptproxy
iessentials
isudo
ikeyboard
itouchpad
idev
idocker
ikube
igui
iworkstation
iemulation
iautologin
itimezone
sudo reboot
}


fuj(){
init apham "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
fastboot
smalllogs
reposrc
iaptproxy
iessentials
isudo
idev
idocker
ikube
igui
iworkstation
ivirt
itimezone
sudo reboot
}

hped(){
init apham "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
fastboot
smalllogs
reposrc
iaptproxy
iessentials
isudo
idev
idocker
ikube
igui
iworkstation
ivirt
iemulation
iautologin
itimezone
sudo reboot
}

gcpvm(){
init alain_pham_grafana_com "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
smalllogs
iessentials
idocker
}

aaon(){
init apham "NA" "authorized_keys" "NA" "NA" "NA"
bashaliases
fastboot
disableturbo
smalllogs
reposrc
iessentials
isudo
idev
idocker
ikube
igui
iworkstation
ivirt
iemulation
iautologin
itimezone
sudo reboot


}

function postaaon(){
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

}