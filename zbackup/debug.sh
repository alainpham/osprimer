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

echo $TARGET_PASSWD

export TARGET_ENCRYPTED_PASSWD=$(openssl passwd -6 -salt xyz $TARGET_PASSWD)

echo $TARGET_ENCRYPTED_PASSWD