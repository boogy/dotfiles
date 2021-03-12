#!/usr/bin/env bash

_check() {
    PROG_TO_CHECK=$1
    PROG_TO_RUN=${2:-$PROG_TO_CHECK}
    if ! pidof -s -o '%PPID' "$1" &>/dev/null ; then
        echo "Running program $PROG_TO_RUN"
        bash -c "$PROG_TO_RUN" &
    fi
}

## detect screen layout automatically
autorandr -c &>/dev/null

##
## SETTINGS
##

## set keyboard layout (also in: /etc/X11/xorg.conf.d/00-keyboard.conf)
## generate X11 config file with
## localectl --no-convert set-x11-keymap layout [model [variant [options]]]
## localectl --no-convert set-x11-keymap ch     pc105   fr      lv3:ralt_switch

# setxkbmap -model pc105 -layout ch -variant fr -option lv3:ralt_switch
# localectl set-keymap fr_CH-latin1

/usr/bin/numlockx on
xset r rate 190 80
xhost +local:

## enable local fonts in .fonts directory
xset +fp /usr/share/fonts/local &
xset +fp /usr/share/fonts/misc &
xset +fp ~/.fonts &
xset fp rehash &
fc-cache -fv &

## powersaving options
xset s off &
xset s noblank &
xset s noexpose &
xset c on &
xset -dpms &

## set proper cursor
xsetroot -cursor_name left_ptr &

## set screen brightness to 100%
xbacklight -set 100%

## set speed and other options for peripherals
~/.config/i3/scripts/xinput-config.sh &

##
## Applications
##

## set wallpaper from last feh image
[ -f ~/.fehbg ] && ~/.fehbg &

## start pulseaudio
start-pulseaudio-x11
pulseaudio --start

## generate list of files to search with bolt
bolt --generate &>/dev/null

## run applets
_check nm-applet
_check dropbox /opt/dropbox/dropboxd
_check blueman-applet
_check firefox
_check xfce4-notifyd /usr/lib/xfce4/notifyd/xfce4-notifyd

## start tmux session or join if present
(tmux list-sessions|grep -Eo WORK) \
    || alacritty --class work --title work -e tmux new-session -A -s WORK &

## run polkit agent (don't need to check if already running)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

## run gnome keyring daemon
_check gnome-keyring-daemon --start --daemonize --components=gpg,pkcs11,secrets,ssh &

## compositor
# _check picom "picom --experimental-backends -b"
_check picom "picom -b"

## Launch polybar
~/.config/polybar/launch-polybar.sh &

# trayer --edge top --align right --SetDockType true --SetPartialStrut true \
#  --expand true --width 10 --transparent true --tint 0x191970 --height 12 &

## setup screen locker
# xautolock -time 10 -locker "~/.config/scripts/betterlockscreen.sh --lock" &

## start other local programs
test -f ~/.xmonad_autostart_local.sh \
    && ~/.xmonad_autostart_local.sh &>/dev/null
