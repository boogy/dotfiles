#!/usr/bin/env bash

# Set environment
export BSPWM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/bspwm"

dump_bspwm_state() {
    bspc wm --dump-state > "$BSPWM_STATE" \
        && dunstify "BSPWM Wm" "Window manager dumped into $BSPWM_STATE"
}

lock_screen() {
    ~/.config/scripts/betterlockscreen.sh --lock
}

# Restart function
restart() {
    case $DESKTOP_SESSION in
        bspwm )
            # Save session status
            . "$BSPWM_CONFIG/restore.cfg"
            bspc wm --dump-state > "$BSPWM_STATE"
            bspc quit 0
            ;;
        i3)
            i3-msg restart
            ;;
        xmonad)
            xdotool key super+r
            ;;
    esac
}

# Logout function
logout() {
    case $DESKTOP_SESSION in
        bspwm )
            # For each opened window
            bspc query --nodes | while read -r winid; do
                # Close it
                xdotool windowkill "$winid"
            done
            bspc quit 1
            ;;
        i3)
            i3-msg exit
            ;;
        xmonad)
            ## exit xmonad using it's shortcut
            xdotool key alt+shift+q
            ;;
    esac
}

# Load dmenu config
# [ -f "$HOME/.dmenurc" ] && source "$HOME/.dmenurc" || DMENU='dmenu -i'

# Menu items
items="Restart
Logout
Hibernate
Suspend
Reboot
Poweroff
Save
Lock
Monitors-Reset"

# Open menu
# selection=$(printf '%s' "$items" | $DMENU)
selection=$(printf '%s' "$items" | dmenu -p "Select Action: " -i -fn 'Droid Sans Mono-10' -nb '#1e1e1e' -sf '#1e1e1e' -sb '#f4800d' -nf '#fffefc')

case $selection in
    Restart)
        restart
        ;;
    Logout)
        logout
        ;;
    Hibernate)
        lock_screen \
        && sudo systemctl hibernate
        ;;
    Suspend)
        lock_screen \
        && sudo systemctl suspend
        ;;
    Reboot)
        logout
        sudo systemctl reboot
        ;;
    Halt|Poweroff|Shutdown)
        logout
        # sudo systemctl poweroff
        sudo poweroff -f
        ;;
    Save|Dump|Save_state)
        dump_bspwm_state
        ;;
    Lock)
        lock_screen
        ;;
    Monitors-Reset)
        ## reset monitors without restarting bspwm
        bspwm-setup-monitors.sh
        ;;
esac

exit
