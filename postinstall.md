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

on dell g15
echo "options  iwlwifi  enable_ini=0" > /etc/modprobe.d/iwlwifi.conf ;
systemctl reboot;

/etc/modprobe.d/iwlwifi.conf
