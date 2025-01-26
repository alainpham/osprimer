#!/bin/bash
filename=$(date +"%Y-%m-%d_%H-%M-%S").mkv
preset=${1:-fast}
crf=${2:-23}
ab=${3:-160}

capdev=$(v4l2-ctl --list-devices | grep -A 1 "HD60" | grep "/dev/video" | awk '{print $1}')
alsadev="hw:CARD=S,DEV=0"
pulsdev="alsa_input.usb-Elgato_Game_Capture_HD60_S__0007798D4B000-03.analog-stereo"
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

ffmpeg  \
    -f pulse -thread_queue_size 1024 -probesize 1G -analyzeduration 1G -use_wallclock_as_timestamps 1 -ac 2 -i $pulsdev \
    -f v4l2   -thread_queue_size 1024 -probesize 1G -analyzeduration 1G -use_wallclock_as_timestamps 1 -i $capdev \
    -f matroska  -map 0:a -map 1:v -max_muxing_queue_size 1024 -preset $preset -pix_fmt yuv420p -c:v libx264 -crf ${crf} -g 24 -c:a aac -b:a ${ab}k $filename