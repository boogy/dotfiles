#!/usr/bin/env bash

case $1 in
    next)
        yabai -m window --focus stack.next || yabai -m window --focus stack.first
        ;;
    prev)
        yabai -m window --focus stack.prev || yabai -m window --focus stack.last
        ;;
esac

# yabai -m window --focus stack.next || yabai -m window --focus stack.first
