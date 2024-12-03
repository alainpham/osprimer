Connect to VScode
Connect to chrome
Setup OBS using scripts
check for screen tearing.
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