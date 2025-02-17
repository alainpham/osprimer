#!/bin/bash
extension="${1##*.}"
filename="${1%.*}"

ffmpeg -y -i "$1" -preset slow -pix_fmt yuv420p -vf scale=-2:576 -c:v libx264 -crf 28 -c:a aac -b:a 96k -f mp4 -movflags +faststart "${filename}-576p-x264-crf28-aac-ab96k.mp4"
