#!/usr/bin/env bash

ACTION="${1}"
DIRECTION="${2}"
LAYOUT=$(bspc query -T -d | jq -r .layout)

## if in tiled mode then use the smart move
## or the focus direction {west,south,north,east}
if [[ "$LAYOUT" == "tiled" ]]; then
    if [[ "$ACTION" =~ ([Ss]wap|[Mm]ove) ]]; then
        bspwm-smart-move.sh $DIRECTION
    else
        bspc node --focus $DIRECTION
    fi
fi

## if we are in monocle mode use the same
## keys to cycle trough non floating windows localy
if [[ "$LAYOUT" == "monocle" ]]; then

    case $DIRECTION in
        west)  FOCUS=prev ;;
        south) FOCUS=next ;;
        north) FOCUS=prev ;;
        east)  FOCUS=next ;;
        *)     FOCUS=next ;;
    esac

    bspc node --focus ${FOCUS}.local.window.!floating
fi
