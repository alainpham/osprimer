@echo off
setlocal

:: Set the filename with date and time

set dt=%DATE:~6,4%_%DATE:~3,2%_%DATE:~0,2%__%TIME:~0,2%_%TIME:~3,2%_%TIME:~6,2%
set dt=%dt: =0%
set filename=%dt%.mkv

:: Set default values for the arguments (preset, crf, ab)
set preset=%1
if "%preset%"=="" set preset=veryfast

set crf=%2
if "%crf%"=="" set crf=23

set ab=%3
if "%ab%"=="" set ab=160

:: show devices : ffmpeg -f dshow -list_devices true -i dummy
:: show options : ffmpeg -f dshow -list_options true -i video="Game Capture HD60 S+"
:: show options : ffmpeg -f dshow -list_options true -i audio="Digital Audio Interface (Game Capture HD60 S+)"

:: Run ffmpeg to capture video and audio


ffmpeg ^
    -f dshow -rtbufsize 64M ^
        -pixel_format yuv420p ^
        -channels 2 -sample_rate 48000 -sample_size 16 ^
        -i video="Game Capture HD60 S+":audio="Digital Audio Interface (Game Capture HD60 S+)" ^
    -f matroska -preset %preset% -pix_fmt yuv420p -c:v libx264 -crf %crf% -g 24 -c:a aac -b:a %ab%k %filename%

endlocal
