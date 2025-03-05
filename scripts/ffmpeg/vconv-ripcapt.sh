#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
duration=${1:-"03:35:00"}
snddriver=${2:-"alsa"}
framerate=${3:-"24000/1001"}
preset=${4:-faster}
crf=${5:-23}
ab=${6:-160}

capdev=$(v4l2-ctl --list-devices | grep -A 1 "HD60" | grep "/dev/video" | awk '{print $1}')

if [ "$snddriver" == "alsa" ]; then
    snddev="hw:CARD=S,DEV=0"
    sndopt="-thread_queue_size 4096"
elif [ "$snddriver" == "pulse" ]; then
    snddev="alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo"
    sndopt="-thread_queue_size 4096 -use_wallclock_as_timestamps 1"
else
    echo "Invalid sound driver"
    exit 1
fi

ffmpeg  \
    -f ${snddriver} \
        ${sndopt} \
        -i ${snddev} \
    -f v4l2 \
        -thread_queue_size 4096 \
        -use_wallclock_as_timestamps 1 \
        -i $capdev \
    -map "0:a" \
    -map "1:v" \
        -t ${duration} \
        -r ${framerate} \
        -fps_mode cfr \
        -preset $preset \
        -pix_fmt yuv420p \
        -c:v libx264 \
        -crf ${crf} \
        -g 24 \
        -c:a aac \
        -b:a ${ab}k \
        -tune zerolatency \
        -report \
        -f matroska $filename
