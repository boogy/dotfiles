#!/usr/bin/env bash

# if [ -z "$DEFAULT_NETWORK_INTERFACE" ]; then
#     export DEFAULT_NETWORK_INTERFACE=$(command -p ip route | grep '^default' | awk '{print $5}' | head -n1)
# fi

if [ -z "$DEFAULT_NIC_INTERFACE" ]; then
    export DEFAULT_NIC_INTERFACE=$(command -p ip link ls|awk '/[0-9]+.*eth[0-9]+:.*state UP/ { gsub(":", "");print $2 }')
fi

if [ -z "$DEFAULT_WLAN_INTERFACE" ]; then
    export DEFAULT_WLAN_INTERFACE=$(command -p ip link ls|awk '/[0-9]+.*wlan[0-9]+:.*state UP/ { gsub(":", "");print $2 }')
fi

if [ -z "$POLYBAR_PRIMARY_MONITOR" ]; then
    export POLYBAR_PRIMARY_MONITOR=$(xrandr | grep primary | cut -d ' ' -f 1)
fi

## set polybar DPI value
AUTORANDR_CONFIG=$(autorandr --detect)
case $AUTORANDR_CONFIG in
    home*)
        export POLYBAR_DPI_VALUE=130 ;;
    *)
        export POLYBAR_DPI_VALUE=0 ;;
esac

killall -q polybar

while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

outputs=$(xrandr --listactivemonitors|awk '{print $4}'|sed '/^$/d')
tray_output=${POLYBAR_PRIMARY_MONITOR}

_BAR_NAME=""
case $DESKTOP_SESSION in
    bspwm | i3 | xmonad)
        _BAR_NAME="bar-${DESKTOP_SESSION}"
        ;;
    *)
        _BAR_NAME="bar-default"
        ;;
esac

## run a polybar instance per screen
for m in $outputs; do
    export MONITOR=$m
    export TRAY_POSITION=none

    if [[ ${m} == ${tray_output} ]]; then
        TRAY_POSITION=right
    fi
    MONITOR=$m polybar --reload "$_BAR_NAME" -c ~/.config/polybar/config &
done
