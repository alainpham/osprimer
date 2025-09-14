#!/bin/bash

# URL to open
URL="http://192.168.8.100:8096/web/#/home.html"

# Launch Google Chrome in fullscreen (kiosk mode)
google-chrome-stable --start-fullscreen --noerrdialogs --disable-infobars --kiosk "$URL"