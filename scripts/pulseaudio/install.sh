#!/bin/bash

sudo cp confsnd /usr/local/bin/confsnd
sudo cp confpw /usr/local/bin/confpw
sudo cp confpa /usr/local/bin/confpa
sudo cp confsnddefault /usr/local/bin/confsnddefault
sudo cp sndsel /usr/local/bin/sndsel
sudo cp pulsepod.pa /etc/pulse/default.pa.d/pulsepod.pa 
sudo cp 89-pulseaudio-udev.rules /etc/udev/rules.d/89-pulseaudio-udev.rules

# pipewire
cp pipewire-pulse.conf ~/.config/pipewire/pipewire-pulse.conf
cp pipewire.conf ~/.config/pipewire/pipewire.conf
cp podcast.conf ~/.config/pipewire/pipewire.conf.d/podcast.conf
cp 50-alsa-config.lua ~/.config/wireplumber/main.lua.d/50-alsa-config.lua