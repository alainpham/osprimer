#!/bin/bash

# Take one argument from the commandline: VM name
if ! [ $# -eq 1 ]; then
    echo "Usage: $0 <hostname>"
    echo "ie: make-cidata hp00"
    exit 1
fi

TARGET_HOSTNAME=$1

cat > meta-data << _EOF_
instance-id: $TARGET_HOSTNAME
local-hostname: $TARGET_HOSTNAME
_EOF_

genisoimage -output $TARGET_HOSTNAME-cidata.iso  -volid CIDATA -joliet -rock meta-data



# for after

# SSH_PUB_KEY=`cat ~/.ssh/id_rsa.pub`

# SSH_PRIVVM_KEY=`cat ~/.ssh/vm | sed 's/^/    /'`
# SSH_PUBVM_KEY=`cat ~/.ssh/vm.pub`


# cat > user-data << _EOF_
# #cloud-config
# ssh_pwauth: True
# ssh_authorized_keys:
#   - $SSH_PUB_KEY
# ssh_keys:
#   rsa_private: | 
# $SSH_PRIVVM_KEY
#   rsa_public: $SSH_PUBVM_KEY
# users:
#   - name: $TARGET_USER
#     gecos: $TARGET_USER
#     shell: /bin/bash
#     lock-passwd: false
#     sudo: ALL=(ALL) NOPASSWD:ALL
#     ssh_authorized_keys:
#       - $SSH_PUB_KEY
# chpasswd:
#   list: |
#      $TARGET_USER:password
#   expire: False
# _EOF_
