#!/bin/bash 
if pgrep -f "mpv.*Music" > /dev/null; then
    pkill -f "mpv.*Music"
else
    mpv --shuffle --loop-playlist=inf --no-video --input-ipc-server=/tmp/mpvsocket ~/Music/* &
fi
 
