#!/usr/bin/env bash

BAR_TO_RUN=$1

if [ -z "$DEFAULT_NETWORK_INTERFACE" ]; then
    export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
fi

if [ -z "$POLYBAR_PRIMARY_MONITOR" ]; then
    export POLYBAR_PRIMARY_MONITOR=$(xrandr | grep primary | cut -d ' ' -f 1)
fi

# Terminate already running bar instances
sleep 3
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
# $HOME/.config/i3/scripts/polybar -c $HOME/.config/i3/polybar_config default &
polybar -c $HOME/.config/i3/polybar_config $BAR_TO_RUN &

echo "Bars launched..."
