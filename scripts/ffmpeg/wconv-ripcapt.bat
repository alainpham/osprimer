@echo off
setlocal

set filename=%1
if "%filename%"=="" set filename="out.mkv"

:: Set default values for the arguments (preset, crf, ab) by default run for 3h30 max

set duration=%2
if "%duration%"=="" set duration="03:45:00"

set preset=%3
if "%preset%"=="" set preset=faster

set crf=%4
if "%crf%"=="" set crf=23

set ab=%5
if "%ab%"=="" set ab=160

:: show devices : ffmpeg -f dshow -list_devices true -i dummy
:: show options : ffmpeg -f dshow -list_options true -i video="Game Capture HD60 S+"
:: show options : ffmpeg -f dshow -list_options true -i audio="Digital Audio Interface (Game Capture HD60 S+)"

:: Run ffmpeg to capture video and audio

:: -max_interleave_delta 0 if cluster error

ffmpeg -y ^
    -t %duration% ^
    -f dshow -rtbufsize 512M ^
        -pixel_format yuv420p ^
        -channels 2 -sample_rate 48000 -sample_size 16 ^
        -i video="Game Capture HD60 S+":audio="Digital Audio Interface (Game Capture HD60 S+)" ^
    -f matroska -preset %preset% -pix_fmt yuv420p -c:v libx264 -crf %crf% -g 24 -c:a aac -b:a %ab%k %filename%
endlocal
