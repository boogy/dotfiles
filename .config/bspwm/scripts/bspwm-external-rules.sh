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
        echo "follow=on"
        ;;
    [Ss]cratchpad:[Ss]cratchpad*)
        echo "state=floating"
        echo "hidden=on"
        echo "sticky=on"
        echo "rectangle=1910x1040+0+0"
        echo "center=true"
        ;;
    [Ww]ork:[Ww]ork*|[Ww]ork:[Aa]lacritty*)
        echo "desktop=1"
        echo "state=tiled"
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
            *)
                ## do nothing
                # exit 0
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


#has_presel=$(bspc query --nodes --node '.!automatic')
#if [ ! -z $has_presel ]; then
#        exit 0
#fi
## Check if root node is horizontal (sorry you need "jq" for this)
#firstSplit=$(bspc query -T -d -n '@/' | jq -r '.splitType')
#if [ $firstSplit = 'horizontal' ]; then
#        # Horizontal mode, create the main window on the left
#        echo "node=@/"
#        echo "split_dir=west"
#        echo "split_ratio=0.5"
#        exit 0
#fi
#
## Otherwise, it depends on the number of existing (non-float) windows
#num=$(bspc query -N -n '.leaf.!floating' -d | wc -l)
#if [ $num -eq 0 ]; then
#        # No window, just put it here
#        exit 0
#elif [ $num -eq 1 ]; then
#        # One window, split east
#        echo "split_dir=east"
#        echo "split_ratio=0.5"
#else
#        # More than one window, split south
#        echo "node=@/2"
#        echo "split_dir=south"
#        echo "split_ratio=0.5"
#fi

# node_number=$(bspc query --nodes --desktop --node .window | wc -l)
# case "$node_number" in
# 	1) split_dir=east;;
# 	2) split_dir=south;;
# 	3) bspc node -f biggest.local && echo split_dir=south;;
# 	4) bspc desktop -f next;;
# esac
