#!/usr/bin/env bash

## Notify BSPWM to run this script for all changes by adding it to:
## ~/.config/autorandr/postswitch
## See Hook scripts: https://github.com/phillipberndt/autorandr
##
## autorandr installs a udev rule which is triggered when monitor state is changed
## rule file: /usr/lib/udev/rules.d/40-monitor-hotplug.rules
## autorandr udev rule:
##   ACTION=="change", SUBSYSTEM=="drm", RUN+="/bin/systemctl start --no-block autorandr.service"

## BUG: device on /sys/class/drm does not update without forcing an update with xrandr
xrandr > /dev/null

_desk_order() {
    while read -r line; do
        printf "%s\\n" "$line"
    done < <(bspc query -D -m "${1:-focused}" --names) | sort -g | paste -d ' ' -s
}

_set_bspwm_config() {
    ## apply the bspwm configs escept external_rules_command
    ## or the desktops will look funny if monitors have changed
    grep --color=never -P '(?=^((?!external_rules_command).)*$)bspc config ' \
        ~/.config/bspwm/bspwmrc | while read line; do (eval $line); done
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
                bspc monitor $MONITOR -d 4 5 6 7 8 9 10
            else
                bspc monitor $MONITOR -d 1 2 3
            fi
            ;;
        *)
            if [[ ${MONITOR} == ${PRIMARY_MONITOR} ]]; then
                bspc monitor $MONITOR -d 1 2 3 4 5 6 7 8 9 10
            else
                bspc monitor $MONITOR -d 1 2 3
            fi
            ;;
    esac

    ## reorder the desktops for each monitor
    bspc monitor $MONITOR -o $(eval _desk_order $MONITOR)
done

_set_bspwm_config

## relaunch polybar
~/.config/polybar/launch-polybar.sh &
