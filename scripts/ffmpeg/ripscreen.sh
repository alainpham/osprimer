#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
screen=${1:-"0"}
duration=${2:-"03:03:31"}
preset=${3:-fast}
crf=${3:-23}
ab=${4:-160}

xcoord=$(($screen * 1920))

#gst-launch-1.0 audiotestsrc wave=sine freq=440 ! pulsesink device=from-desktop >/dev/null 2>&1 &
gst-launch-1.0 audiotestsrc wave=silence ! pulsesink device=from-desktop >/dev/null 2>&1 &
gst-launch-1.0 audiotestsrc wave=silence ! pulsesink device=from-caller >/dev/null 2>&1 &

sleep 3

ffmpeg  \
    -f x11grab \
        -video_size 1920x1080 \
        -framerate 60 \
        -i ":0.0+$xcoord,0" \
    -f pulse \
        -i from-desktop.monitor \
    -f pulse \
        -i from-caller.monitor \
    -f pulse \
        -i mic01-processed \
    -f pulse \
        -i mic02-processed \
    -f matroska \
        -filter_complex "[1:a][2:a][3:a][4:a]amix=inputs=4:duration=longest[mixed]" \
        -map "0:v" \
        -map "[mixed]" \
        -preset $preset \
        -pix_fmt yuv420p  \
        -fps_mode cfr \
        -c:v libx264 \
        -crf ${crf} \
        -c:a libfdk_aac \
        -b:a ${ab}k \
        $filename

killall gst-launch-1.0

