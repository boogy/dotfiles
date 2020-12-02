#!/usr/bin/env bash

## alltab-bspwm.sh brings tabbing functionality to bspwm.
## It relies on tabbed, xdotool, and xwininfo.

currentWID=$(bspc query -N -n focused)
case $1 in
    east|north|south|west)
        targetWID=$(bspc query -N -n $1) || exit 1
        if bspc query -T -n focused | grep -q tabbed ; then
            if bspc query -T -n $1 | grep -q tabbed ; then
                if [ $(xwininfo -id $currentWID -children | wc -l) -eq 9 ] ; then
                    xdotool windowreparent $(xwininfo -id $currentWID -children | awk 'NR==8 {print $1}') $(xwininfo -root | awk '/Window id:/ {print $4}')
                fi
                xdotool windowreparent $(xwininfo -id $currentWID -children | awk 'NR==7 {print $1}') $targetWID
            else
                bspc config -n $targetWID border_width 0
                xdotool windowreparent $targetWID $currentWID
            fi
        elif bspc query -T -n $1 | grep -q tabbed ; then
            bspc config -n $currentWID border_width 0
            xdotool windowreparent $currentWID $targetWID
        else
            tabbedWID=$(tabbed -c -d | tail -n 1)
            bspc config -n $currentWID border_width 0
            bspc config -n $targetWID border_width 0
            xdotool windowreparent $currentWID $tabbedWID
            xdotool windowreparent $targetWID $tabbedWID
        fi
        ;;
    detach)
        if bspc query -T -n focused | grep -q tabbed ; then
            rootWID=$(xwininfo -root | awk '/Window id:/ {print $4}')
            if [ $(xwininfo -id $currentWID -children | wc -l) -eq 9 ] ; then
                xdotool windowreparent $(xwininfo -id $currentWID -children | awk 'NR==8 {print $1}') $rootWID
            fi
            xdotool windowreparent $(xwininfo -id $currentWID -children | awk 'NR==7 {print $1}') $rootWID
        fi
        ;;
    *)
        echo "Usage: ./alltab-bspwm.sh [east|north|south|west|detach]"
        echo "You probably want to add something like this to your sxhkdrc file:"
        echo "# Tabbing functionality for bspwm"
        echo "super + t; {h,j,k,l,d}"
        echo "    /path/to/alltab-bspwm.sh {west,south,north,east,detach}"
        ;;
    esac
