#!/usr/bin/env bash

## true = battery mode
## false = AC mode
LAPTOP_MODE=$1

if echo $1|grep -Eo "true"; then

    ## disable nvidia card
    echo -n auto > /sys/bus/pci/devices/0000:3c:00.0/power/control

    ## cpu performence
    ## cat /sys/devices/system/cpu/cpufreq/policy?/energy_performance_available_preferences
    ## default performance balance_performance balance_power power
    echo -n balance_power > /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference

else
    echo -n performance > /sys/devices/system/cpu/cpufreq/policy?/energy_performance_preference
fi
