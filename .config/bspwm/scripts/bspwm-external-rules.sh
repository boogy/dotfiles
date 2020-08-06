#!/usr/bin/env bash

## Script inspired by :
## https://gitlab.com/protesilaos/dotfiles.

## debug rules live
# echo "$@" >> "$HOME"/.rules_cmd.log

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
        echo "desktop=6"
        ;;
    [Ss]cratchpad:[Ss]cratchpad*)
        echo "state=floating"
        echo "hidden=on"
        echo "sticky=on"
        echo "rectangle=1910x1040+0+0"
        echo "center=true"
        ;;
esac


case "$window_class" in
    [Mm]pv|[Vv]lc|[Pp]avucontrol|[Ee]o[mg]|[Ff]eh|[Ss]xiv)
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
            *_KDE_NET_WM_WINDOW_TYPE_OVERRIDE*)
                echo "center=on"
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

case "$window_title" in
    'File Operations'*)
        echo "state=floating"
        echo "center=on"
        ;;
esac
