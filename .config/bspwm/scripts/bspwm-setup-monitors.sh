#!/usr/bin/env bash

_desk_order() {
    while read -r line; do
        printf "%s\\n" "$line"
    done < <(bspc query -D -m "${1:-focused}" --names) | sort -g | paste -d ' ' -s
}

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

    _desk_order $MONITOR
done

## relaunch polybar
~/.config/polybar/launch-polybar.sh
