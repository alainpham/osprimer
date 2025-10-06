

```sh


cat <<EOF | tee /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
EOF

apk update
apk upgrade

reboot

apk add bash bash-completion 

sed -i 's|/bin/sh|/bin/bash|' /etc/passwd

apk add curl git dmidecode
curl -L tinyurl.com/osprimer | sh

```