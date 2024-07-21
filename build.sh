#!/bin/bash
set -e

if ! [ $# -eq 7 ]; then
    echo "Usage: $0 <INPUT_IMG> <OUTPUT_IMAGE> <TARGET_USERNAME> <TARGET_PASSWD> <AUTHSSHFILE> <DOCKER_HOST> <KUBE_HOST>"
    echo "ie: $0 debian-12-nocloud-amd64.raw d12-full.raw apham password authorized_keys 1 1"
    exit 1
fi

export DOCKER_BUILDX_VERSION=v0.16.0
export MAJOR_KUBE_VERSION=v1.29
export K9S_VERSION=v0.32.5
export MVN_VERSION=3.9.8
export KEYBOARD_LAYOUT=fr

# Map input parameters
export INPUT_IMG=$1
export OUTPUT_IMAGE=$2
export TARGET_USERNAME=$3
export TARGET_PASSWD=$4
export AUTHSSHFILE=$5
export DOCKER_HOST=$6
export KUBE_HOST=$7

# name devices
export DEVICE=/dev/loop0
export ROOTFS="/tmp/installing-rootfs"

# resize image
cp $INPUT_IMG $OUTPUT_IMAGE

if [ $KUBE_HOST -eq 1 ]; then
    echo "resize kube"
    qemu-img  resize -f raw $OUTPUT_IMAGE 2.5G
fi

if [ $DOCKER_HOST -eq 1 ]; then
    echo "resize docker"
    qemu-img  resize -f raw $OUTPUT_IMAGE 3.5G
fi



# setup loopback
losetup -D 
losetup -fP $OUTPUT_IMAGE

# fix partition
if [ $DOCKER_HOST -eq 1 ] || [ $KUBE_HOST -eq 1 ] ; then
printf "fix\n" | parted ---pretend-input-tty $DEVICE print
growpart ${DEVICE} 1
resize2fs ${DEVICE}p1
fi


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

export TARGET_ENCRYPTED_PASSWD=$(openssl passwd -6 -salt acmh $TARGET_PASSWD)
# create user and setup ssh
echo "chroot setup users"
cat << EOF | chroot ${ROOTFS}
    useradd -m -s /bin/bash $TARGET_USERNAME
    echo "${TARGET_USERNAME}:${TARGET_ENCRYPTED_PASSWD}" | chpasswd -e
    echo "root:${TARGET_ENCRYPTED_PASSWD}" | chpasswd -e
    echo '${TARGET_USERNAME} ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/nopwd
EOF

mkdir -p ${ROOTFS}/home/$TARGET_USERNAME/.ssh/
cp $AUTHSSHFILE ${ROOTFS}/home/$TARGET_USERNAME/.ssh/

cat << EOF | chroot ${ROOTFS}
    chown $TARGET_USERNAME:$TARGET_USERNAME -R /home/$TARGET_USERNAME/.ssh
EOF

# accelerate grub startup
cat << EOF | chroot ${ROOTFS}
    sed -i 's/GRUB_TIMEOUT=./GRUB_TIMEOUT=0/g' /etc/default/grub.d/15_timeout.cfg
    update-grub
EOF

# first boot script
cat <<EOF | sudo tee ${ROOTFS}/usr/local/bin/firstboot.sh
#!/bin/bash
if [ ! -f /var/log/firstboot.log ]; then
    # Code to execute if log file does not exist
    echo "First boot script has run">/var/log/firstboot.log
    growpart /dev/sda 1
    resize2fs /dev/sda1
fi
EOF

chmod 755 ${ROOTFS}/usr/local/bin/firstboot.sh

cat <<EOF | sudo tee ${ROOTFS}/etc/systemd/system/firstboot.service
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
    sudo systemctl enable firstboot.service
EOF


# super aliases
cat <<EOF | sudo tee ${ROOTFS}/etc/profile.d/super_aliases.sh
alias ll="ls -larth"
EOF

echo "lower log volume"
cat << EOF | chroot ${ROOTFS}
    sed -i 's/.SystemMaxUse=/SystemMaxUse=50M/g' /etc/systemd/journald.conf
EOF

echo "setup apt"
cat <<EOF > ${ROOTFS}/etc/apt/sources.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
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


if [ $DOCKER_HOST -eq 1 ]; then

echo "install docker"
cat << EOF | chroot ${ROOTFS}
    sudo apt update
    sudo apt install -y docker.io python3-docker docker-compose skopeo
    sudo apt install -y ansible openjdk-17-jdk-headless ntfs-3g
EOF

cat <<EOF | sudo tee ${ROOTFS}/etc/docker/daemon.json
{
  "log-opts": {
    "max-size": "10m",
    "max-file": "2" 
  }
}
EOF

cat << EOF | chroot ${ROOTFS}
    sudo mkdir -p /usr/lib/docker/cli-plugins
    sudo curl -SL https://github.com/docker/buildx/releases/download/${DOCKER_BUILDX_VERSION}/buildx-${DOCKER_BUILDX_VERSION}.linux-amd64 -o /usr/lib/docker/cli-plugins/docker-buildx
    sudo chmod 755 /usr/lib/docker/cli-plugins/docker-buildx
    
    sudo adduser $TARGET_USERNAME docker

    export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")
    echo "export JAVA_HOME=$JAVA_HOME" | sudo tee -a /etc/profile.d/java_home.sh

    sudo mkdir /opt/appimages/

    curl -L -o /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.tar.gz
    sudo tar xzvf /tmp/maven.tar.gz  -C /opt/appimages/
    sudo ln -s /opt/appimages/apache-maven-${MVN_VERSION}/bin/mvn /usr/local/bin/mvn
    rm /tmp/maven.tar.gz
EOF


# install maven

# TODO on first boot : 
# docker network create --opt com.docker.network.bridge.name=primenet --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 primenet
# docker buildx create --name multibuilder --platform linux/amd64,linux/arm/v7,linux/arm64/v8 --use

cat <<EOF | sudo tee ${ROOTFS}/usr/local/bin/firstboot-dockernet.sh
#!/bin/bash
echo "Setting up dedicated network bridge.."
if [[ -z "\$(docker network ls | grep primenet)" ]] then
     docker network create --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 primenet
     echo "net created"
     echo "✅ primenet docker network created !">/var/log/firstboot-dockernet.log
else
     echo "net exists"
     echo "✅ primenet already exisits ! ">/var/log/firstboot-dockernet.log
fi
EOF

cat <<EOF | sudo tee ${ROOTFS}/usr/local/bin/firstboot-dockerbuildx.sh
#!/bin/bash

echo "Setting up builder"
if [[ -z "\$(docker buildx ls | grep multibuilder.*linux)" ]] then
     docker buildx create --name multibuilder --platform linux/amd64,linux/arm/v7,linux/arm64/v8 --use
     echo "✅ multibuilder docker buildx created !">~/firstboot-dockerbuildx.log
else
     echo "build exists"
     echo "✅ multibuilder already exisits ! ">~/firstboot-dockerbuildx.log
fi
EOF

chmod 755 ${ROOTFS}/usr/local/bin/firstboot-dockernet.sh
chmod 755 ${ROOTFS}/usr/local/bin/firstboot-dockerbuildx.sh

cat <<EOF | sudo tee ${ROOTFS}/etc/systemd/system/firstboot-dockernet.service
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

cat <<EOF | sudo tee ${ROOTFS}/etc/systemd/system/firstboot-dockerbuildx.service
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
    sudo systemctl enable firstboot-dockernet.service
    sudo systemctl enable firstboot-dockerbuildx.service
EOF

fi


if [ $KUBE_HOST -eq 1 ]; then

echo "install kube readiness"

cat <<EOF | sudo tee ${ROOTFS}/etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF

cat <<EOF | sudo tee ${ROOTFS}/etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

cat << EOF | chroot ${ROOTFS}
    containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
    sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
EOF

echo "install kube bins"
cat << EOF | chroot ${ROOTFS}
    curl -fsSL https://pkgs.k8s.io/core:/stable:/$MAJOR_KUBE_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$MAJOR_KUBE_VERSION/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt update
    sudo apt install -y kubelet kubeadm kubectl
    kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
EOF

echo "install helm"
cat << EOF | chroot ${ROOTFS}
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt update
    sudo apt install helm -y
    helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null
EOF

cat << EOF | chroot ${ROOTFS}
    curl -LO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
    sudo tar -xzvf k9s_Linux_amd64.tar.gz  -C /usr/local/bin/ k9s
    rm k9s_Linux_amd64.tar.gz
EOF

echo "download kube images"
cat << EOF | chroot ${ROOTFS}
    kubeadm config images pull
EOF

fi

echo "cleaning up"
cat << EOF | chroot ${ROOTFS}
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOF


echo "Unmounting filesystems"
umount ${ROOTFS}/{dev/pts,dev,run,proc,sys,tmp,}

losetup -D
