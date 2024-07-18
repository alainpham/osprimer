sudo su

export MAJOR_KUBE_VERSION=v1.29
export K9S_VERSION=v0.32.5

wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.raw
cp debian-12-generic-amd64.raw d12.raw


qemu-img  resize -f raw  d12.raw +1G

losetup -fP d12.raw
losetup -a

DEVICE=/dev/loop0

printf "fix\n" | parted ---pretend-input-tty $DEVICE print
growpart ${DEVICE} 1
resize2fs ${DEVICE}p1

echo "Mount OS partition"
ROOTFS="/tmp/installing-rootfs"
mkdir -p ${ROOTFS}
mount ${DEVICE}p1 ${ROOTFS}

echo "Get ready for chroot"
mount --bind /dev ${ROOTFS}/dev
mount --bind /run ${ROOTFS}/run

mount -t devpts /dev/pts ${ROOTFS}/dev/pts
mount -t proc proc ${ROOTFS}/proc
mount -t sysfs sysfs ${ROOTFS}/sys
mount -t tmpfs tmpfs ${ROOTFS}/tmp

echo "chroot create user"
cat << EOF | chroot ${ROOTFS}
  useradd -m -s /bin/bash apham
EOF

cat << EOF | chroot ${ROOTFS}
    echo 'apham ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/nopwd
EOF

mkdir -p ${ROOTFS}/home/apham/.ssh/


cp authorized_keys ${ROOTFS}/home/apham/.ssh/

or

cat > ${ROOTFS}/home/apham/.ssh/authorized_keys << _EOF_
_EOF_

chown 1000:1000 -R ${ROOTFS}/home/apham/.ssh

cat << EOF | chroot ${ROOTFS}
    cat /home/apham/.ssh/authorized_keys
EOF

echo "SystemMaxUse=50M">>${ROOTFS}/etc/systemd/journald.conf

mkdir -p /run/systemd/resolve/
cat /etc/resolv.conf>/run/systemd/resolve/resolv.conf

cat << EOF | chroot ${ROOTFS}
    apt update && apt upgrade -y
    apt install -y git tmux vim curl rsync ncdu dnsutils bmon ntp ntpstat htop bash-completion gpg whois containerd cloud-guest-utils
    apt-get clean && rm -rf /var/lib/apt/lists/*
EOF


# Kubernetes

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

cat << EOF | chroot ${ROOTFS}
    rm /etc/apt/keyrings/kubernetes-apt-keyring.gpg /etc/apt/sources.list.d/kubernetes.list
    curl -fsSL https://pkgs.k8s.io/core:/stable:/$MAJOR_KUBE_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$MAJOR_KUBE_VERSION/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
EOF

cat << EOF | chroot ${ROOTFS}
    sudo apt update
    sudo apt install -y kubelet kubeadm kubectl
    sudo apt clean && rm -rf /var/lib/apt/lists/*
EOF

cat << EOF | chroot ${ROOTFS}
    kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
EOF

cat << EOF | chroot ${ROOTFS}
    curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
    sudo apt update
    sudo apt install helm -y
    sudo apt clean && rm -rf /var/lib/apt/lists/*
    helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null
EOF

cat << EOF | chroot ${ROOTFS}
    curl -LO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
    sudo tar -xzvf k9s_Linux_amd64.tar.gz  -C /usr/local/bin/ k9s
    rm k9s_Linux_amd64.tar.gz
EOF

cat << EOF | chroot ${ROOTFS}
    kubeadm config images pull
EOF

cat << EOF | chroot ${ROOTFS}
    echo 'apham:password' | chpasswd
EOF

cat << EOF | chroot ${ROOTFS}
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
EOF

# end kube

echo "Unmounting filesystems"
umount ${ROOTFS}/dev/pts
umount ${ROOTFS}/dev
umount ${ROOTFS}/run
umount ${ROOTFS}/proc
umount ${ROOTFS}/sys
umount ${ROOTFS}/tmp
umount ${ROOTFS}

losetup -D

scp d12-full.raw awon:/home/apham/apps/static/data

curl -X PUT  -u admin:password -T --progress-bar d12-kube.raw https://reposilite.awon.cpss.duckdns.org/releases/d12-kube.raw