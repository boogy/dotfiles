#!/usr/bin/env bash

# restore bspwm session
export BSPWM_TREE=/tmp/bspwm.tree
export BSPWM_HISTORY=/tmp/bspwm.history
export BSPWM_STACK=/tmp/bspwm.stack

if [ -e "$BSPWM_TREE" ] ; then
  bspc restore -T "$BSPWM_TREE" -H "$BSPWM_HISTORY" -S "$BSPWM_STACK"
  rm "$BSPWM_TREE" "$BSPWM_HISTORY" "$BSPWM_STACK"
fi
