#!/usr/bin/env bash

# Reorder BSPWM desktops.  This is an excerpt of another script I have
# that implements dynamic desktop creation/deletion.  It is kept here in
# case the reordering functionality is needed on its own.  Everything is
# part of my dotfiles: https://gitlab.com/protesilaos/dotfiles.
#
# Copyright (c) 2019 Protesilaos Stavrou <info@protesilaos.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

_desk_order() {
	while read -r line; do
		printf "%s\\n" "$line"
	done < <(bspc query -D -m "${1:-focused}" --names) | sort -g | paste -d ' ' -s
}

# do not quote! we want term splitting here
bspc monitor -o $(eval _desk_order "${1:-focused}")

# for MONITOR in $(bspc query -M)
# do
#     echo "(bspc monitor $MONITOR -o $(eval _desk_order $MONITOR))"
#     bspc monitor $MONITOR -o $(eval _desk_order $MONITOR)
# done
