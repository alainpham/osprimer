gcc gshorts.c -o gshorts $(pkg-config --cflags --libs sdl2)
sudo cp gshorts /usr/local/bin/
killall gshorts
lineinfile /home/$TARGET_USERNAME/.local/share/dwm/autostart.sh .*gshorts.* "killall gshorts ; gshorts \&"
