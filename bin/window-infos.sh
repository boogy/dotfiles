#!/usr/bin/env bash

exec xprop -notype \
  -f WM_NAME        8s ':\n  title =\? $0\n' \
  -f WM_CLASS       8s ':\n  appName =\? $0\n  className =\? $1\n' \
  -f WM_WINDOW_ROLE 8s ':\n  stringProperty "WM_WINDOW_ROLE" =\? "$0"\n' \
  -f _NET_WM_WINDOW_TYPE 32a ':\n  stringProperty "_NET_WM_WINDOW_TYPE" =\? "$0"\n' \
  WM_NAME WM_CLASS WM_WINDOW_ROLE _NET_WM_WINDOW_TYPE \
  ${1+"$@"}
