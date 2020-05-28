#!/usr/bin/env bash

icon_enabled=" ON"
icon_disabled=" OFF"

## Get all bluetooth devices
# devices=($(hcitool dev | awk '/hci[0-9]/{print $1}'))
devices=("hci0")
len_devices=${#devices[@]}

## use for loop read all devices
## if one is running the bluetooth is on
for (( i=0; i < ${len_devices}; i++ ));
do
    if [ -f /sys/class/bluetooth/${devices[$i]}/rfkill*/state ]; then
        status=$(cat /sys/class/bluetooth/${devices[$i]}/rfkill*/state)
        # dev_name=$(echo ${devices[$i]}|grep -Eo "[0-9]{,2}")
        if [ $status -eq 1 ]; then
            echo "$icon_enabled"
        else
            echo "$icon_disabled"
        fi
    fi
done
