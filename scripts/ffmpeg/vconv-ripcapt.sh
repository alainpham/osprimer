#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
crf=${1:-23}
ab=${2:-160}

# fpsprobesize

capdev=$(v4l2-ctl --list-devices | grep -A 1 "HD60" | grep "/dev/video" | awk '{print $1}')

ffmpeg -f v4l2 -fpsprobesize 120 -i $capdev -f pulse -ac 2  -i alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo -preset fast -pix_fmt yuv420p  -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k -f tee "$filename|[f=nut]-" | ffplay -
