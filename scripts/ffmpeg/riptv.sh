#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
# duration="03:03:31" is exactly 11011 seconds, 24000/1001*11011=264000 frames
duration=${1:-"03:03:31"}
snddriver=${2:-"alsa"}
framerate=${3:-"24000/1001"}
preset=${4:-faster}
crf=${5:-23}
ab=${6:-160}

capdev=$(v4l2-ctl --list-devices | grep -A 1 "HD60" | grep "/dev/video" | awk '{print $1}')

export thread_queue_size=1024

if [ "$snddriver" == "alsa" ]; then
    snddev="hw:CARD=S,DEV=0"
    sndopt="-thread_queue_size $thread_queue_size"
elif [ "$snddriver" == "pulse" ]; then
    snddev="alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo"
    sndopt="-thread_queue_size $thread_queue_size -use_wallclock_as_timestamps 1"
else
    echo "Invalid sound driver"
    exit 1
fi

# tuning="-tune zerolatency"
tuning=""

ffmpeg  \
    -f ${snddriver} \
        ${sndopt} \
        -i ${snddev} \
    -f v4l2 \
        -thread_queue_size $thread_queue_size \
        -
         1 \
        -i $capdev \
    -map "1:v" \
    -map "0:a" \
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
        $tuning \
        -report \
        -f matroska $filename
