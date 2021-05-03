#!/usr/bin/env bash

DESKTOP="$@"
yabai -m space --focus "$DESKTOP" || yabai -m space --focus recent
