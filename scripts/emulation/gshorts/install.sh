gcc gshorts.c -o gshorts
sudo cp gshorts /usr/local/bin/
lineinfile /home/apham/.local/share/dwm/autostart.sh .*gshorts.* 'gshorts &'
