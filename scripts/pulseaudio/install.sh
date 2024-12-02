#!/bin/bash

sudo cp confsnd /usr/local/bin/confsnd
sudo cp confsnddefault /usr/local/bin/confsnddefault
sudo cp sndsel /usr/local/bin/sndsel
sudo cp pulsepod.pa /etc/pulse/default.pa.d/pulsepod.pa 
sudo cp 89-pulseaudio-udev.rules /etc/udev/rules.d/89-pulseaudio-udev.rules