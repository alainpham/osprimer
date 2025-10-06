

```sh

apk add curl git dmidecode bash bash-completion 
curl -L tinyurl.com/osprimer | sh


cat <<EOF | tee /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
EOF

apk update
apk upgrade


sed -i 's|/bin/sh|/bin/bash|' /etc/passwd


```