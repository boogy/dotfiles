#!/usr/bin/env bash

## Create a scratchpad like windows by using ID
## to maximize and minimize

_start_alacritty(){
    alacritty --class=Scratchpad --title=Scratchpad -e tmux new-session -A -s SCRATCHPAD
}

scratchpad_id=$(yabai -m query --windows | jq '.[] | select(.title=="Scratchpad").id')

if [[ "$scratchpad_id" -lt 1 ]]; then
    # scratchpad_id=$(iterm Scratchpad | awk '{print $NF}')
    scratchpad_id=$(_start_alacritty)
    sleep 1
    yabai -m window --focus "$scratchpad_id"
    yabai -m window --toggle float
    yabai -m window --center
    # yabai -m window --resize abs:1920:1080
    # yabai -m window --move abs:960:540
else
    is_minimized=$(yabai -m query --windows --window "$scratchpad_id" | jq '.minimized')
    current_space=$(yabai -m query --spaces --space | jq '.index')

    if [[ "$is_minimized" -eq 1 ]]; then
        yabai -m window "$scratchpad_id" --space "$current_space"
        yabai -m window --focus "$scratchpad_id"
    else
        yabai -m window "$scratchpad_id" --minimize
    fi
fi
