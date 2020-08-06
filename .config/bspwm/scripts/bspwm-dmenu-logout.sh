#!/usr/bin/env bash


# Set environment
export BSPWM_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/bspwm"

dump_bspwm_state(){
    bspc wm --dump-state > "$BSPWM_STATE" \
        && dunstify "BSPWM Wm" "Window manager dumped into $BSPWM_STATE"
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
[ -f "$HOME/.dmenurc" ] && . "$HOME/.dmenurc" || DMENU='dmenu -i'

# Menu items
items="restart
logout
hibernate
suspend
reboot
poweroff
save
lock
reset-monitors"

# Open menu
selection=$(printf '%s' "$items" | $DMENU)

case $selection in
    restart)
        restart
        ;;
    logout)
        logout
        ;;
    hibernate)
        ~/.config/i3/scripts/betterlockscreen.sh --lock \
        && sudo systemctl hibernate
        ;;
    suspend)
        ~/.config/i3/scripts/betterlockscreen.sh --lock \
        && sudo systemctl suspend
        ;;
    reboot)
        logout
        sudo systemctl reboot
        ;;
    halt|poweroff|shutdown)
        logout
        sudo systemctl poweroff
        ;;
    save|dump|save_state)
        dump_bspwm_state
        ;;
    lock)
        ~/.config/i3/scripts/betterlockscreen.sh --lock
        ;;
    reset-monitors)
        ## reset monitors without restarting bspwm
        ~/.config/bspwm/scripts/bspwm-setup-monitors.sh
        ;;
esac

exit
