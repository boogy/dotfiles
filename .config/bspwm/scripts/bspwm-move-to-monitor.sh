#!/usr/bin/env bash

## get desktop id
DIRECTION="${1}"
DESKTOP_ID=$(bspc query -D -d focused)

## move desktop to monitor in direction $DIRECTION
bspc desktop -m $DIRECTION

## focus monitor in direction $DIRECTION
bspc monitor -f $DIRECTION

## focus desktop with id $DESKTOP_ID
bspc desktop -f $DESKTOP_ID

## reorder desktops
~/.config/bspwm/scripts/bspwm-reorder-desktops.sh &
