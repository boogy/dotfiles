#!/usr/bin/env bash

## Run program unless it's already running
pgrep $@ > /dev/null || ($@ &)
