#!/usr/bin/env bash

FOCUS_OR_SWAP=${1}
DIRECTION=${2}
LAYOUT=$(bspc query -T -d | jq -r .layout)

## are we swaping or moving the window
[[ "$FOCUS_OR_SWAP" =~ ([Ss]wap|[Mm]ove) ]] && {
    SWAP=yes
} || {
    SWAP=no
}

## if in tiled mode then use the smart move
## or the focus direction {west,south,north,east}
if [[ "$LAYOUT" == "tiled" ]]; then
    [[ "$SWAP" =~ (Y|Yes|YES|yes) ]] && {
        bspwm-smart-move.sh ${DIRECTION}
    } || {
        bspc node --focus ${DIRECTION}
    }
fi

## if we are in monocle mode use the same
## keys to cycle trough windows localy
if [[ "$LAYOUT" == "monocle" ]]; then
    case $DIRECTION in
        west)  FOCUS=prev ;;
        south) FOCUS=next ;;
        north) FOCUS=prev ;;
        east)  FOCUS=next ;;
        *)     FOCUS=next ;;
    esac
    bspc node --focus ${FOCUS}.local
fi
