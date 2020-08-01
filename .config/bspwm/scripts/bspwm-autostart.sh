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
autorandr -c

##
## SETTINGS
##

## set keyboard layout (also in: /etc/X11/xorg.conf.d/00-keyboard.conf)
## generate X11 config file with
## localectl --no-convert set-x11-keymap layout [model [variant [options]]]
## localectl --no-convert set-x11-keymap ch     pc105   fr      lv3:ralt_switch

# setxkbmap -model pc105 -layout ch -variant fr -option lv3:ralt_switch
# localectl set-keymap fr_CH-latin1

xrdb -merge ~/.Xresources
/usr/bin/numlockx on
xset r rate 200 70
xhost +local:

## daemon mode for filemanager makes mounting volumes easier
#thunar --daemon &

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
xbacklight -set 15 &

## launch keybinding daemon after setting the keyboard layout
_check sxhkd "sxhkd -m -1 > /tmp/sxhkd.log"

## Caps Lock is Espace key
# xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
# xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

## set proper cursor (bspwm)
xsetroot -cursor_name left_ptr &

## set screen brightness to 100%
xbacklight -set 100%

## add mousepad gestures
libinput-gestures-setup start &

## set speed and other options for peripherals
~/.config/i3/scripts/xinput-config.sh &

##
## Applications
##

## set wallpaper from last feh image
[ -f ~/.fehbg ] && ~/.fehbg &

## start pulseaudio
pulseaudio --start
ps -ef|grep "[p]ulseaudio" || {
    pulseaudio -k; pulseaudio -D
    start-pulseaudio-x11
}

## launch polybar after pulseaudio
~/.config/polybar/launch-polybar.sh &

bsp-layout set tall 1
bsp-layout set monocle 2
bsp-layout set tall 3
bsp-layout set monocle 4
bsp-layout set monocle 5
bsp-layout set tiled 6
bsp-layout set monocle 8
bsp-layout set tiled 7
bsp-layout set monocle 10

## generate list of files to search with bolt
bolt --generate &>/dev/null

## run applets
_check nm-applet
_check dropbox /opt/dropbox/dropboxd
_check blueman-applet
_check firefox
# _check xfce4-power-manager

## start tmux session or join if present
(tmux list-sessions|grep -Eo WORK) \
    || termite --class work --name work -e "tmux new-session -A -s 'WORK'" &

## run polkit agent (don't need to check if already running)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

## run gnome keyring daemon
_check gnome-keyring-daemon --start --daemonize --components=gpg,pkcs11,secrets,ssh &

## compositor
_check picom "picom -bcCGf -D 1 -I 0.05 -O 0.02 --no-fading-openclose --unredir-if-possible"

##
## SUBSCRIBE TO BSPWM ACTIONS
##
bspwm-subscribe-actions.sh &

