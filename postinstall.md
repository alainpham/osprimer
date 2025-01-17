Connect to VScode
Connect to chrome
Setup OBS using scripts
check for screen tearing.
LX theme : breeze-dark , noto sans nerdfont 10
select icon themes breeze-dark
Set default pulse select

Add bluetooth mouse.
 
 bluetoothctl power on
 bluetoothctl discoverable on
 bluetoothctl pairable on
 bluetoothctl scan on
 bluetoothctl devices
 bluetoothctl pair 3C:4D:BE:84:1F:BC
 bluetoothctl connect 3C:4D:BE:84:1F:BC
 bluetoothctl disconnect 3C:4D:BE:84:1F:BC



setup git default
git config --global core.editor "vim"
git config --global apham
git config --global apham@work

on dell g15
echo "options  iwlwifi  enable_ini=0" > /etc/modprobe.d/iwlwifi.conf ;
systemctl reboot;

/etc/modprobe.d/iwlwifi.conf




image=debian-12-genericcloud-amd64
variant=debiantesting

vmcr master 4096 4 $image 10 40G 1G $variant
vmcr node01 2048 4 $image 11 40G 1G $variant
vmcr node02 2048 4 $image 12 40G 1G $variant
vmcr node03 2048 4 $image 13 40G 1G $variant

vmcr splunk 6144 4  $image 40 40G 1G $variant
vmcr vrbx 6144 4  $image 30 40G 1G $variant




rm -rf /home/${USER}/apps/tls
mkdir -p /home/${USER}/apps/tls/cfg /home/${USER}/apps/tls/logs

docker run --rm --name certbot  -v "/home/${USER}/apps/tls/cfg:/etc/letsencrypt" -v "/home/${USER}/apps/tls/logs:/var/log/letsencrypt" infinityofspace/certbot_dns_duckdns:${CERTBOT_DUCKDNS_VERSION} \
   certonly \
     --non-interactive \
     --agree-tos \
     --email ${EMAIL} \
     --preferred-challenges dns \
     --authenticator dns-duckdns \
     --dns-duckdns-token ${DUCKDNS_TOKEN} \
     --dns-duckdns-propagation-seconds 20 \
     -d "*.${WILDCARD_DOMAIN}"

sudo chown -R ${USER}:${USER} /home/${USER}/apps/tls/cfg

openssl pkcs12 -export -out /home/${USER}/apps/tls/cfg/live/${WILDCARD_DOMAIN}/privkey.p12  -in /home/${USER}/apps/tls/cfg/live/${WILDCARD_DOMAIN}/fullchain.pem -inkey  /home/${USER}/apps/tls/cfg/live/${WILDCARD_DOMAIN}/privkey.pem -passin pass:password -passout pass:password


curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
    | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
    | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
    | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
