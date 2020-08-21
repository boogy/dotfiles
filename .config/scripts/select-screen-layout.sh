#!/usr/bin/env bash

# autorandr $(echo -en "docked\nlaptop\nhome" | dmenu -nb '#2f343f' -nf '#f3f4f5' -sb '#9575cd' -sf '#f3f4f5' -fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' -i -p "Select screenlayout setup")

autorandr_layouts=$(autorandr|awk '{print $1}')

autorandr $(for i in ${autorandr_layouts[@]};do echo $i; done \
    | dmenu -nb '#2f343f' -nf '#f3f4f5' -sb '#9575cd' -sf '#f3f4f5' -fn '-*-*-medium-r-normal-*-*-*-*-*-*-100-*-*' -i -p "Select screenlayout ")

[[ "$1" =~ polybar ]] && ~/.config/polybar/launch-polybar.sh
