```bash
export TARGET_USERNAME=apham

export DOCKER_BUILDX_VERSION=v0.16.0
export MAJOR_KUBE_VERSION=v1.29
export K9S_VERSION=v0.32.5
export MVN_VERSION=3.9.8
export KEYBOARD_LAYOUT=fr

su
echo "${TARGET_USERNAME} ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR='tee -a' visudo -f /etc/sudoers.d/nopwd
exit

sed -i 's/GRUB_TIMEOUT=./GRUB_TIMEOUT=0/g' /etc/default/grub
update-grub

cat <<EOF | sudo tee ${ROOTFS}/etc/profile.d/super_aliases.sh
alias ll="ls -larth"
EOF

echo "lower log volume"
sed -i 's/.SystemMaxUse=/SystemMaxUse=50M/g' /etc/systemd/journald.conf


cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian bookworm main contrib non-free non-free-firmware
deb http://deb.debian.org/debian-security/ bookworm-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian bookworm-updates main contrib non-free non-free-firmware
EOF

apt update && apt upgrade -y

apt install -y git tmux vim curl wget rsync ncdu dnsutils bmon ntp ntpstat htop bash-completion gpg whois containerd haveged

DEBIAN_FRONTEND=noninteractive apt install -y cloud-guest-utils openssh-server console-setup

apt install -y docker.io python3-docker docker-compose skopeo
apt install -y ansible openjdk-17-jdk-headless ntfs-3g

cat <<EOF | tee /etc/docker/daemon.json
{
  "log-opts": {
    "max-size": "10m",
    "max-file": "2" 
  }
}
EOF


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

docker network create --driver=bridge --subnet=172.18.0.0/16 --gateway=172.18.0.1 primenet

docker buildx create --name multibuilder --platform linux/amd64,linux/arm/v7,linux/arm64/v8 --use

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml


curl -fsSL https://pkgs.k8s.io/core:/stable:/$MAJOR_KUBE_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$MAJOR_KUBE_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update
sudo apt install -y kubelet kubeadm kubectl

kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install helm -y
helm completion bash | sudo tee /etc/bash_completion.d/helm > /dev/null

curl -LO https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz
sudo tar -xzvf k9s_Linux_amd64.tar.gz  -C /usr/local/bin/ k9s
rm k9s_Linux_amd64.tar.gz

apt-get clean && rm -rf /var/lib/apt/lists/*


```

