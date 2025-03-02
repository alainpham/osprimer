#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
duration=${1:-"03:35:00"}
snddriver=${2:-"alsa"}
pixel_format=${3:-"yuv420p"}
framerate=${4:-"24000/1001"}
preset=${5:-faster}
crf=${6:-23}
ab=${7:-160}

capdev=$(v4l2-ctl --list-devices | grep -A 1 "HD60" | grep "/dev/video" | awk '{print $1}')

if [ "$snddriver" == "alsa" ]; then
    snddev="hw:CARD=S,DEV=0"
    sndopt=""
elif [ "$snddriver" == "pulse" ]; then
    snddev="alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo"
    sndopt="-thread_queue_size 1024 -use_wallclock_as_timestamps 1"
else
    echo "Invalid sound driver"
    exit 1
fi
# ffmpeg -f v4l2 -thread_queue_size 1024 -i $capdev -f pulse -thread_queue_size 1024 -ac 2 -i alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo -f matroska  -preset fast -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k $filename


# ffmpeg -f v4l2 -thread_queue_size 1024 -fpsprobesize 150 -i $capdev -f pulse -thread_queue_size 1024 -ac 2 -i alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo -f matroska  -preset fast -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k $filename
# ffmpeg -f v4l2 -thread_queue_size 2048 -fpsprobesize 150 -i $capdev -f alsa -thread_queue_size 2048 -ac 2 -i hw:CARD=S,DEV=0 -f matroska  -preset fast -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 48 -c:a aac -b:a ${ab}k $filename


# ffmpeg  \
#     -f pulse -thread_queue_size 1024 -probesize 1G -analyzeduration 1G -use_wallclock_as_timestamps 1 -ac 2 -i alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo \
#     -f v4l2 -thread_queue_size 1024 -probesize 1G -analyzeduration 1G -use_wallclock_as_timestamps 1 -i $capdev \
#     -f matroska -map 0:a -map 1:v  -preset fast -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k $filename

# alsa
# ffmpeg  \
#     -f alsa -thread_queue_size 1024 -probesize 1G -analyzeduration 1G -use_wallclock_as_timestamps 1 -ac 2 -i $alsadev\
#     -f v4l2 -thread_queue_size 1024 -probesize 1G -analyzeduration 1G -use_wallclock_as_timestamps 1 -i $capdev \
#     -f matroska -map 0:a -map 1:v -max_muxing_queue_size 1024 -preset $preset -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k $filename

echo "
ffmpeg  \
    -f ${snddriver} \
        ${sndopt} \
        -i ${snddev} \
    -f v4l2 \
        -thread_queue_size 1024 \
        -use_wallclock_as_timestamps 1 \
        -i $capdev \
    -f matroska -t ${duration} -r ${framerate} -fps_mode cfr -map 0:a -map 1:v -preset $preset -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k  $filename
">$filename.command

ffmpeg  \
    -f ${snddriver} \
        ${sndopt} \
        -i ${snddev} \
    -f v4l2 \
        -thread_queue_size 1024 \
        -use_wallclock_as_timestamps 1 \
        -i $capdev \
    -f matroska -t ${duration} -r ${framerate} -fps_mode cfr -map 0:a -map 1:v -preset $preset -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k -ar 44100 $filename
