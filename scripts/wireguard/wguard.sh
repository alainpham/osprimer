#!/bin/bash
# docker exec -it wireguard /app/show-peer $1 && cat wg/config/peer_$1/peer_$1.conf
# docker exec -it wireguard wg show

docker rm -f wireguard
sudo rm -rf /home/${USER}/wg
mkdir -p /home/${USER}/wg/config
docker run -d \
  --name=wireguard \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE `#optional` \
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=Etc/UTC \
  -e SERVERURL=euas.duckdns.org `#optional` \
  -e SERVERPORT=51820 `#optional` \
  -e PEERS=euas,awon,owrt,work,surfacequang,surfacehuyen,iphonequang,ipadquang,ipadchloe,popi,iphonedong,iphonehuyen,iphonehoa,iphonehang,iphoneanh,iphonedavid `#optional` \
  -e PEERDNS="auto" \
  -e INTERNAL_SUBNET=10.13.13.0 `#optional` \
  -e ALLOWEDIPS=10.13.13.0/24 `#optional` \
  -e PERSISTENTKEEPALIVE_PEERS=all `#optional` \
  -e LOG_CONFS=true `#optional` \
  -p 51820:51820/udp \
  -v /home/${USER}/wg/config:/config \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --restart unless-stopped \
  linuxserver/wireguard:1.0.20210914