#!/usr/bin/env bash

#Toggle status no matter what
amixer set Capture toggle;

#Save 7th element (on/off) from proper line of "amixer get" result to status variable
status=`amixer get Capture |grep "Front Left:" |   awk '{ print ($7) }'`

#Print gnome notification with current mic state (on/off)
#change ~/Scripts/imic.png to path of prefered image to accompany the message if desired
notify-send "Mic Status" "$status" -u normal -i ~/Scripts/imic.png -t 1000 -h int:transient:1;

#-t=time in ms for notification to stay up (not sure if working properly)
#--hint=int:transient:1; so that notification doesn't stay on gnome 3 bottom panel.
