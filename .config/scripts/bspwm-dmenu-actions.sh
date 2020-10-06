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

# Function to kill programs
killprogs() {
    # Kill udisks-glue
    pkill -x udisks-glue
    # Kill panel
    pkill -x panel
    # Kill Redshift
    pkill -x redshift
}

# Restart function
restart() {
    # Save session status
    . "$BSPWM_CONFIG/restore.cfg"
    bspc wm --dump-state > "$BSPWM_STATE"
    # Kill programs
    killprogs
    # Quit bspwm
    bspc quit 0
}

# Logout function
logout() {
    # For each opened window
    bspc query --nodes | while read -r winid; do
        # Close it
        xdotool windowkill "$winid"
    done
    # Kill programs
    killprogs
    # Quit bspwm
    bspc quit 1
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
