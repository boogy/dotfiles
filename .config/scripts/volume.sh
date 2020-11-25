#!/usr/bin/env bash

# SOUND_DEVICE=$(pacmd list-sinks | grep -Eo "\*[ \t]+index:[ \t]+[0-9]+"|awk -F":" '{gsub(/^[ \t]+/,"",$2);print $2}')

if echo "$1"|grep -qE "mute"; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
else
    pactl set-sink-volume @DEFAULT_SINK@ "$@"
fi
