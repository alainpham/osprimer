#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
crf=${1:-23}
ab=${2:-160}
ffmpeg -video_size 1920x1080 \
    -framerate 60 \
    -f x11grab \
    -probesize 200M \
    -thread_queue_size 1024  \
    -i :0.0+0,0 \
    -f pulse -thread_queue_size 1024 -ac 2  \
    -i from-desktop.monitor  \
    -f alsa \
        ${sndopt} \
        -i ${snddev} \
    -preset superfast \
    -pix_fmt yuv420p  \
    -c:v libx264 \
    -crf ${crf} \
    -c:a libfdk_aac \
    -b:a ${ab}k \
    $filename
