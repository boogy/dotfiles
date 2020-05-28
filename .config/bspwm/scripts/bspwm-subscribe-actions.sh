#!/usr/bin/env bash

## run different actions on bspwm changes


_trigger_polybar_windows_number(){
    desktop_layout=$(bspc query -T -d|jq -r .layout)
    [[ $desktop_layout == "monocle" ]] && {
        (polybar-msg hook bspwm-monocle-nb-windows 1) &>/dev/null
    } || {
        (polybar-msg hook bspwm-monocle-nb-windows 2) &>/dev/null
    }
}

bspc subscribe \
    desktop_layout desktop_focus \
    node_add node_remove node_stack node_focus \
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
done &
