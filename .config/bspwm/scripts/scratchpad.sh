#!/usr/bin/env sh
#
# A scratchpad utility for bspwm that depends on: bspc, cat, echo, grep, sed, touch and xdotool

registry="/tmp/scratchpad-registry"

# Initialise the scratchpad register if it wasn't already
[ -f "$registry" ] || touch "$registry"

get_focused_node_id() {
    bspc query --nodes --node .focused
}

get_registry() {
    cat "$registry"
}

# '$1' id of the node to add
# '$2' is the position at which to add the node
#   - 'first'
#   - 'last'  (default)
add() {
    ids="$(get_registry)"

    # Avoid empty lines at the beginning of the registry
    if [ -z "$ids" ]; then
        echo "$1" > "$registry"

    # Register the given node at the beginning of the registry
    elif [ "$2" = "first" ]; then
        echo "$1
$ids" > "$registry"

    # Register the given node at the end of the registry
    else
        echo "$1" >> "$registry"
    fi
}

# '$1' id of the node to remove
remove() {
    # The '--in-place' option (from GNU sed) is purposely not used to maintain posix compliance
    new_registry="$(sed "/$1/d" "$registry")"
    echo "$new_registry" > "$registry"
}

case "$1" in
    -a | --add)
        # Hide the node in the scratchpad
        id="$(get_focused_node_id)"
        bspc node "$id" --flag sticky=on --flag hidden=on

        # Only set the node's state to floating if it wasn't already
        bspc query --nodes --node "$id.floating" > /dev/null || bspc node "$id" --state floating

        add "$id" "first"
        ;;

    # Additional option:
    # '--no-focus' Don't focus the nodes brought out
    -c | --cycle)
        ids="$(get_registry)"

        # If no node is registered then quit
        [ -z "$ids" ] && exit 0

        # Check if a registered node isn't hidden
        hiddens="$(bspc query --nodes --node .hidden)"
        for node in $ids; do
            echo "$hiddens" | grep -q "$node" || id="$node"
        done

        # Bring out the last registered node from the scratchpad
        if [ -z "$id" ]; then
            id="${ids%%
*}"

            [ "$2" = "--no-focus" ] && focus="" || focus="--focus"

            # Bring the node and focus it
            bspc node "$id" --to-monitor focused --flag hidden=off "$focus"

            # Put this node at the back of the registry, so that it won't be brought back
            # again on the next call of '--cycle'
            remove "$id"
            add "$id" "last"

        # Hide the registered node
        else
            bspc node "$id" --flag hidden=on
        fi
        ;;

    -l | --list)
        ids="$(get_registry)"

        # Only prints if there is at least one node in the scratchpad
        [ -z "$ids" ] || echo "$ids"
        ;;

    # Additional options:
    # '"<id>"' Remove the node with the specified id instead of the focused one
    # '--remain-floating' After unregistering the node, keep its floating state
    -r | --remove)
        id="$(get_focused_node_id)"

        if [ "$2" = "--remain-floating" ]; then
            state="floating"

        else
            state="tiled"

            # A node id was provided, so remove this node instead of the active one
            [ -z "$2" ] || id="$2"
        fi

        # Bring the node out of the scratchpad
        bspc node "$id" --state "$state" --flag sticky=off

        remove "$id"
        ;;

    -s | --show-all)
        # Remove the hidden flag from every node that has it
        for id in $(bspc query --nodes --node .hidden); do
            bspc node "$id" --flag hidden=off
        done
        ;;

    # This option doesn't interact with the scratchpad built here, instead it allows having some
    # nodes that you can't cycle through, but that you can toggle using this option and a class name
    -t | --toggle)
        # A class name is required
        [ -z "$2" ] && echo "No class name specified" && exit 1

        # Get the node id for the given class, limits to one result because termite somehow spawns 2
        # nodes when given the '--exec' option
        id="$(xdotool search --limit=1 --class "$2")"

        # Hide in or bring out the node
        bspc node "$id" --flag hidden --focus
        ;;

    *)
        echo "Usage: scratchpad <option>"
        echo "  -a | --add"
        echo "  -c | --cycle [--no-focus]"
        echo "  -l | --list"
        echo "  -r | --remove [<id>|--remain-floating]"
        echo "  -s | --show-all"
        echo "  -t | --toggle"
        exit 1
        ;;
esac
