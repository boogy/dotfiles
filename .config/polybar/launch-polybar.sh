#!/usr/bin/env bash

if [ -z "$DEFAULT_NETWORK_INTERFACE" ]; then
    export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
fi

if [ -z "$POLYBAR_PRIMARY_MONITOR" ]; then
    export POLYBAR_PRIMARY_MONITOR=$(xrandr | grep primary | cut -d ' ' -f 1)
fi

killall -q polybar

while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

outputs=$(xrandr --listactivemonitors|awk '{print $4}'|sed '/^$/d')
tray_output=${POLYBAR_PRIMARY_MONITOR}

case $DESKTOP_SESSION in
    bspwm)
        for m in $outputs; do
            export MONITOR=$m
            export TRAY_POSITION=none
            if [[ ${m} == ${tray_output} ]]; then
                TRAY_POSITION=right
            fi
            MONITOR=$m polybar --reload bar-bspwm -c ~/.config/polybar/config &
        done
        ;;
    i3)
        polybar --reload bar-i3 -c ~/.config/polybar/config &
        ;;
esac
