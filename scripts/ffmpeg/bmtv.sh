#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
# duration="03:03:31" is exactly 11011 seconds, 24000/1001*11011=264000 frames
duration=${1:-"03:03:31"}
preset=${2:-faster}
crf=${3:-23}
ab=${4:-160}

export FFREPORT=file="${filename}.log:level=48"

ffmpeg  \
    -f decklink \
        -format_code 23ps \
        -i 'DeckLink Mini Recorder' \
        \
        -t ${duration} \
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
