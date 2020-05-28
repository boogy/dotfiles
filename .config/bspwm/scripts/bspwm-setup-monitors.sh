#!/usr/bin/env bash

PRIMARY_MONITOR=$(xrandr | grep primary | cut -d ' ' -f 1)
OUTPUTS=($(xrandr --listactivemonitors|awk '{print $4}'|sed '/^$/d'))
NB_OF_MONITORS=${#OUTPUTS[@]}

for MONITOR in ${OUTPUTS[@]}; do
    case $NB_OF_MONITORS in
        1)
            bspc monitor $MONITOR -d 1 2 3 4 5 6 7 8 9 10
            ;;
        2)
            if [[ ${MONITOR} == ${PRIMARY_MONITOR} ]]; then
                bspc monitor $MONITOR -d 4 5 6 7 8 10
            else
                bspc monitor $MONITOR -d 1 2 3 9
            fi
            ;;
        *)
            bspc monitor $MONITOR -d 1 2 3 4 5 6 7 8 9 10
            ;;
    esac
done
