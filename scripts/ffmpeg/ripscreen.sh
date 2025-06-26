#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
screen=${1:-"0"}
duration=${2:-"03:03:31"}
preset=${3:-veryfast}
crf=${3:-23}
ab=${4:-160}

xcoord=$(($screen * 1920))

ffmpeg  \
    -f x11grab \
        -probesize 200M \
        -thread_queue_size 1024  \
        -video_size 1920x1080 \
        -framerate 60 \
        -i ":0.0+$xcoord,0" \
    -f pulse \
        -thread_queue_size 1024 \
        -i from-desktop.monitor \
    -f matroska \
        -preset $preset \
        -pix_fmt yuv420p  \
        -c:v libx264 \
        -crf ${crf} \
        -c:a libfdk_aac \
        -b:a ${ab}k \
        $filename


# ffmpeg -video_size 1920x1080 \
#     -framerate 60 \
#     -f x11grab \
#     -probesize 200M \
#     -thread_queue_size 1024  \
#     -i :0.0+0,0 \
#     -f pulse -thread_queue_size 1024 -ac 2  \
#     -i from-desktop.monitor  \
#     -f alsa \
#         ${sndopt} \
#         -i ${snddev} \
#     -preset superfast \
#     -pix_fmt yuv420p  \
#     -c:v libx264 \
#     -crf ${crf} \
#     -c:a libfdk_aac \
#     -b:a ${ab}k \
#     $filename
