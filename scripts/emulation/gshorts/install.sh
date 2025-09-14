gcc gshorts.c -o gshorts
sudo cp gshorts /usr/local/bin/
killall gshorts
lineinfile /home/$TARGET_USERNAME/.local/share/dwm/autostart.sh .*gshorts.* "killall gshorts ; gshorts \&"
