#!/bin/bash

function contains() {
	local e
	for e in "${@:2}"; do
		e=$(bspc query -M -m "$e")
		[[ "$e" == "$1" ]] && return 0;
	done
	return 1
}

if [[ -n $@ ]]; then
	order=( "$@" )
else
	#mapfile -t order < <(bspc query -M)
	mapfile -t order < <(xrandr | sed -n "s/^\([^ ]*\) connected.*/\1/p")
fi

monitors=${#order[@]}

removed=( )
for monitor in $(bspc query -M); do
	echo "Considering monitor $monitor"
	if ! contains "$monitor" "${order[@]}"; then
		echo "$monitor was removed"
		removed+=( "$monitor" )
	fi
done

echo "Ordering $monitors monitors"
desktops=$((10 / $monitors))
extras=$((10 % $monitors))
echo "Giving $desktops desktops to each with $extras extras"

#Swapping monitors
i=1
for monitor in "${order[@]}"; do
	monitor=$(bspc query -M -m "$monitor")

	mon_first="$(bspc query -M | awk NR==$i)"
	if [[ $monitor != $mon_first ]]; then
		echo "Swapping $mon_first with $monitor"
		bspc monitor $first -s $mon_first
	fi

	#Make $desktops + 1 temporary desktops to swap around at will
	#We should end up with these getting deleted at the last stage
	tmps=$(seq -f tmp%g -s " " $((($desktops+1) * ($i-1)+1)) $((($desktops+1) * $i)))
	bspc monitor $monitor -a $tmps &>/dev/null

	i=$((i+1))
done

#Swapping desktops
i=1
desk_cnt=1
for monitor in "${order[@]}"; do
	monitor=$(bspc query -M -m "$monitor")
	echo "Swapping desktops on $monitor"
	this_desktops=$desktops
	if [[ "$i" -le "$extras" ]]; then
		this_desktops=$(($this_desktops + 1))
	fi

	desks="$(seq -s " " 1 $this_desktops)"
	for desk in $desks; do
		deskname="$(bspc query -D -m $monitor | awk NR==$desk)"
		thisd=$(bspc query -D -d "$desk_cnt")
		if [[ $deskname -ne $thisd ]]; then
			echo "Swap $deskname and $thisd"
			bspc desktop $deskname -s $desk_cnt
		fi
		desk_cnt=$(($desk_cnt + 1))
	done

	i=$((i+1))
done

for mon in "${removed[@]}"; do
	echo "Deleting $mon"
	bspc monitor $mon -r
	# bspc wm -r $mon
done

#Adjust number of desktops
i=1
desk_cnt=1
for monitor in "${order[@]}"; do
	echo "Adjusting desktops on $monitor"
	this_desktops=$desktops
	if [[ "$i" -le "$extras" ]]; then
		this_desktops=$(($this_desktops + 1))
	fi

	desk="$(seq -s " " $desk_cnt $(($desk_cnt + $this_desktops-1)))"
	desk_cnt=$(($desk_cnt + $this_desktops))

	bspc monitor $monitor -d $desk
	i=$((i+1))
done
