#!/bin/bash
extension="${1##*.}"
filename="${1%.*}"

ffmpeg -y -i "$1" \
    -preset fast \
    -pix_fmt yuv420p \
    -vf scale=-2:576 \
    -c:v libx264 \
    -crf 28 \
    -c:a aac \
    -b:a 64k \
    -ac 1 \
    -f mp4 \
    -movflags +faststart \
    "${filename}.travel.mp4"
