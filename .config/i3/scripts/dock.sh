#!/usr/bin/env bash

# MONITOR1="$(xrandr --listmonitors | grep "0:" | cut -d ' ' -f6)"
# MONITOR2="$(xrandr --listmonitors | grep "1:" | cut -d ' ' -f6)"

## Display configuration
displayCount=$(xrandr -q|grep " connected"|wc -l)
intDisplay=$(xrandr -q | grep " connected" | grep "eDP1" | awk '{print $1}')
extDisplays=($(xrandr -q | grep " connected" |  grep -P "DP(.*)-[0-9]" | awk '{print $1}'))

if [ -z "$POLYBAR_PRIMARY_MONITOR" ]; then
    export POLYBAR_PRIMARY_MONITOR=$(xrandr | grep primary | cut -d ' ' -f 1)
fi

echo "Monitor count: ${displayCount} -> Int: ${intDisplay} | Ext: ${extDisplays[*]}"
echo "Primary moinitor: ${POLYBAR_PRIMARY_MONITOR}"
sleep 2

# xrandr --auto
if [ $displayCount -eq 3 ]; then
    echo "Enabling work dock"
    $HOME/.config/i3/scripts/display work

elif [ $displayCount -eq 2 ]; then
    echo "Enabling home dock"
    $HOME/.config/i3/scripts/display home

elif [ $displayCount -eq 1 ]; then
    echo "Enabling one display $intDisplay"
    $HOME/.config/i3/scripts/display laptop
fi

sleep 1
