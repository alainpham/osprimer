#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
# duration="03:03:31" is exactly 11011 seconds, 24000/1001*11011=264000 frames
duration=${1:-"03:03:31"}
crf=${2:-23}
ab=${3:-160}

capdev=$(v4l2-ctl --list-devices | grep -A 1 "HD60" | grep "/dev/video" | awk '{print $1}')

export thread_queue_size=1024

export FFREPORT=file="${filename}.log:level=48"

ffmpeg  \
    -f alsa \
        -thread_queue_size $thread_queue_size \
        -use_wallclock_as_timestamps 1 \
        -i "hw:CARD=S,DEV=0" \
    -f v4l2 \
        -thread_queue_size $thread_queue_size \
        -use_wallclock_as_timestamps 1 \
        -i $capdev \
    -f matroska \
        -map "1:v" \
        -map "0:a" \
        -t ${duration} \
        -r 24000/1001 \
        -fps_mode cfr \
        -preset $preset \
        -pix_fmt yuv420p \
        -c:v libx264 \
        -crf ${crf} \
        -g 24 \
        -c:a libfdk_aac \
        -b:a ${ab}k \
        -report \
        $filename
