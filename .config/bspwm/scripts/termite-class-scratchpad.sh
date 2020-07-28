#!/usr/bin/env bash

termite --class="${1}" --name="${1}" -e "tmux new-session -A -s ${1}"
