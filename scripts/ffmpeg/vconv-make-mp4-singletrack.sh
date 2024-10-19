#!/bin/bash
extension="${1##*.}"
filename="${1%.*}"
videostream=${2:-"0:v:0"}
audiostream=${2:-"0:a:1"}
format=${3:-mp4}

echo "ffmpeg -i $1 -map ${videostream} -map ${audiostream} -vcodec copy -acodec copy -movflags +faststart ${filename}.${format}"

ffmpeg -i $1 -map ${videostream} -map ${audiostream} -vcodec copy -acodec copy -movflags +faststart ${filename}.${format}
