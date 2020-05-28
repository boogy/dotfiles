#!/usr/bin/env bash

nm-applet &
/opt/dropbox/dropboxd &
xset r rate 200 60 &
feh --bg-scale ~/Pictures/wallpaper.jpg &
picom -bcCGf -D 1 -I 0.05 -O 0.02 --no-fading-openclose --unredir-if-possible &
xfce4-power-manager &

termite &
firefox &
