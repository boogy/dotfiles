#!/usr/bin/env bash
#
# Manage audio with dbus for i3 shortcuts
#

## List all dbus sessions
# dbus-send --session           \
#   --dest=org.freedesktop.DBus \
#   --type=method_call          \
#   --print-reply               \
#   /org/freedesktop/DBus       \
#   org.freedesktop.DBus.ListNames

## List all dbus system
# dbus-send --system            \
#   --dest=org.freedesktop.DBus \
#   --type=method_call          \
#   --print-reply               \
#   /org/freedesktop/DBus       \
#   org.freedesktop.DBus.ListNames

## Alternative to dbus-send
## qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
## qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next
## qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
## List all actions
## qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2
##

mediaPlayer=$(dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames|awk 'BEGIN{IGNORECASE=1}/player/{gsub("\"","",$2); print $2}')
mediaPlayerNumber=$(echo $mediaPlayer |grep -Eo "[0-9]+")

function playPause()
{
    dbus-send --type=method_call --dest=$mediaPlayer /org/mpris/MediaPlayer$mediaPlayerNumber org.mpris.MediaPlayer$mediaPlayerNumber.Player.PlayPause
}

function next()
{
    dbus-send --type=method_call --dest=${mediaPlayer} /org/mpris/MediaPlayer${mediaPlayerNumber} org.mpris.MediaPlayer${mediaPlayerNumber}.Player.Next
}

function previous()
{
    dbus-send --type=method_call --dest=${mediaPlayer} /org/mpris/MediaPlayer${mediaPlayerNumber} org.mpris.MediaPlayer${mediaPlayerNumber}.Player.Previous
}

function stop()
{
    dbus-send --type=method_call --dest=${mediaPlayer} /org/mpris/MediaPlayer${mediaPlayerNumber} org.mpris.MediaPlayer${mediaPlayerNumber}.Player.Stop
}
case $1 in
    play|play[Pp]ause)
        playPause
        ;;
    [nN]ext)
        next
        ;;
    [pP]revious)
        previous
        ;;
    [sS]top)
        stop
        ;;
    *)
        echo "unknown option"
        ;;
esac
