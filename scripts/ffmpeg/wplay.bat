@echo off
setlocal

:: show devices : ffmpeg -f dshow -list_devices true -i dummy
:: show options : ffmpeg -f dshow -list_options true -i video="Game Capture HD60 S+"
:: show options : ffmpeg -f dshow -list_options true -i audio="Digital Audio Interface (Game Capture HD60 S+)"

:: Run ffmpeg to capture video and audio
::set vdevice="UGREEN 25773"
::set adevice="Digital Audio Interface (UGREEN 25773)"
::set pxformat="yuyv422"


ffplay ^
    -f dshow -rtbufsize 2048M ^
        -pixel_format yuv420p ^
        -channels 2 -sample_rate 48000 -sample_size 16 ^
        -i video="Game Capture HD60 S+":audio="Digital Audio Interface (Game Capture HD60 S+)"

endlocal
