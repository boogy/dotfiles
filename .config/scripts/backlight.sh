#!/usr/bin/env bash

## example usage
## backlight.sh inc 50
## backlight.sh dec 50

max_value=$(cat /sys/class/backlight/intel_backlight/max_brightness)
actual_value=$(cat /sys/class/backlight/intel_backlight/brightness)
WANTED_VALUE=0


if echo $1|grep -qEo "inc"; then
    WANTED_VALUE=$(($actual_value + $2))
elif echo $1|grep -qEo "dec"; then
    WANTED_VALUE=$((${actual_value} - ${2}))
else
    WANTED_VALUE=$max_value
fi

# echo $WANTED_VALUE
if [[ "$WANTED_VALUE" -le 1500 ]]; then
    echo "${WANTED_VALUE}" > /sys/class/backlight/intel_backlight/brightness
else
    echo "brightness at maximum"
fi
