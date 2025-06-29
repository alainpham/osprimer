#!/bin/bash
extension="${1##*.}"
filename="${1%.*}"

encoder=${2}
quality=28

if [[ "$encoder" == "vaapi" ]]; then
    inputparam="-vaapi_device /dev/dri/renderD128
    -hwaccel vaapi
    -hwaccel_output_format vaapi
    "
    video_codec="-c:v h264_vaapi -vaapi_device /dev/dri/renderD128 -vf format=nv12|vaapi,hwupload,scale_vaapi=w=1024:h=-2 -qp ${quality}"
elif [[ "$encoder" == "nvenc" ]]; then
    inputparam="-hwaccel cuda -hwaccel_output_format cuda"
    video_codec="-preset p1 -c:v h264_nvenc -vf scale_cuda=w=1024:h=-2 -rc:v vbr -cq:v ${quality} -b:v 0"
else
    inputparam=""
    video_codec="-preset fast -pix_fmt yuv420p -c:v libx264 -vf scale=1024:-2 -crf ${quality}"
fi

ffmpeg -y \
    $inputparam \
    -i "$1" \
    -f mp4 \
    $video_codec \
    -c:a libfdk_aac \
    -b:a 32k \
    -ac 1 \
    -movflags +faststart \
    "${filename} - travel.mp4"
