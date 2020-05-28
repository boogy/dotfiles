#!/bin/sh

ret_GPU=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{ print "GPU",""$1"","%"}')
if echo "$ret_GPU"|grep -qE ".*[0-9]+"; then
    echo "$ret_GPU"
else
    echo
fi
