#!/bin/bash

# External rules for BSPWM.  This script was copied from:
# https://gitlab.com/protesilaos/dotfiles.
#
# Copyright (c) 2019 Protesilaos Stavrou <info@protesilaos.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# Manual tiling
# =============

# Spawn window on the newest receptacle or preselection and switch focus
# to it.  For presels priority is given to the current desktop.
_bspc_query() {
    bspc query -N -n "$@"
}

recept="$(_bspc_query 'any.leaf.!window')"
presel="$(_bspc_query 'newest.!automatic')"

# Receptacles will not switch focus to the present desktop, whereas
# preselection will. This way we can develop different workflows (e.g.
# create 3 recept in one desktop, launch 3 GUIs that take time to load,
# switch to another desktop and continue working, until you decide to go
# back to the GUIs). This has no effect when all actions occur within
# the focused desktop.
#
# Also see my SXHKD bindings for advanced manual tiling actions (refer
# to my dotfiles).
if [ -n "$recept" ]; then
    target="$recept"
    attention="off"
elif [ -n "$presel" ]; then
    target="$presel"
fi

echo "node=${target:-focused}"
echo "follow=${attention:-on}"

# Window rules
# ============

## debug rules live
# echo "$@" >> "$HOME"/.rules_cmd.log

# Operate on windows based on their properties.  The positional
# arguments are defined in the `external_rules_command` of `man bspc`.
window_id="$1"
window_class="$2"
window_instance="$3"
window_title="$(xwininfo -id "$window_id" | sed ' /^xwininfo/!d ; s,.*"\(.*\)".*,\1,')"
windows_instance_class=${window_instance}:${window_class}


case "$windows_instance_class" in
    [Pp]laces:[Ff]irefox)
        echo "state=floating"
        echo "center=on"
        ;;
    [Ss]office:[Ss]office*|[Ll]ibreoffice:[Ll]ibreoffice*|*:[Ll]ibreoffice*)
        echo "state=tiled"
        echo "desktop=focused:^6"
        ;;
    [Ss]cratchpad:[Ss]cratchpad*)
        echo "state=floating"
        echo "hidden=on"
        echo "sticky=off"
        echo "rectangle=1910x1040+0+0"
        echo "center=true"
        ;;
esac


case "$window_class" in
    [Mm]pv|[Vv]lc|[Pp]avucontrol|[Ee]o[mg]|[Ff]eh|[Ss]xiv|my_float_window)
        echo "state=floating"
        echo "center=on"
        ;;
    [Ee]vince|[Pp]inentry-gtk-2|[Aa]randr|*[Rr]emmina*|[Ff]ile-roller|[Pp]iper|[Nn]m-connection-editor)
        echo "state=floating"
        echo "center=on"
        ;;
    [Gg]nome-calculator|[Gg]picview|[Ll]xappearance)
        echo "state=floating"
        ;;
    * )
        case "$(xprop -id "$window_id" _NET_WM_WINDOW_TYPE)" in
            *_NET_WM_WINDOW_TYPE_DIALOG*|*_NET_WM_WINDOW_TYPE_SPLASH*|*_NET_WM_WINDOW_TYPE_TOOLTIP*|*_NET_WM_WINDOW_TYPE_NOTIFICATION*)
                echo "state=floating"
                ;;
            *)
                ## commented out for floating windows
                ## or they will be tiled when focused
                # echo "state=tiled"
                ;;
        esac
        ;;
esac

# FIXME the "file operations" applies to the `caja` file manager.
# TODO There should be a better way of handling this.
case "$window_title" in
    'File Operations'*)
        echo "state=floating"
        echo "center=on"
        ;;
    my_float_window)
        echo "state=floating"
        ;;
esac
