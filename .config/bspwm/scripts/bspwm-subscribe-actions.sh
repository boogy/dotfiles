#!/usr/bin/env bash

##
## Run different actions based on bspwm subscriptions
## The script will needs to have only 1 instance running
##

CURRENT_PID=$$
for CPID in $(pgrep -f bspwm-subscribe-actions.sh); do
    if [ "$CPID" -ne "$CURRENT_PID" ]; then
        kill -9 $PID && sleep 1
    fi
done
## ugly way to kill all bspc subsribers
printf '%s\n' $(ps -ef|grep "[b]spc subscribe"|awk '{print $2}') | xargs -I {} kill -9 {}


_trigger_polybar_windows_number(){
    desktop_layout=$(bspc query -T -d|jq -r .layout)
    [[ $desktop_layout == "monocle" ]] && {
        (polybar-msg hook bspwm-monocle-nb-windows 1) &>/dev/null
    } || {
        (polybar-msg hook bspwm-monocle-nb-windows 2) &>/dev/null
    }
}

bspc subscribe desktop_{layout,focus} node_{add,remove,stack,focus} \
    | while read -a line
do
    case $line in
        desktop_focus)
            _trigger_polybar_windows_number
            ;;
        desktop_layout)
            _trigger_polybar_windows_number
            ;;
        node_add)
            _trigger_polybar_windows_number
            ;;
        node_stack)
            _trigger_polybar_windows_number
            ;;
        node_remove)
            _trigger_polybar_windows_number
            ;;
    esac
done

