#!/usr/bin/env bash

id=$(xdo id)
xdo hide
("$@" > /dev/null 2>&1)
xdo show "$id"
