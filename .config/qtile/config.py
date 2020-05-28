# -*- coding: utf-8 -*-
# A customized config.py for Qtile window manager (http://www.qtile.org)
# Modified by Derek Taylor (http://www.gitlab.com/dwt1/ )
#
# The following comments are the copyright and licensing information from the default
# qtile config. Copyright (c) 2010 Aldo Cortesi, 2010, 2014 dequis, 2012 Randall Ma,
# 2012-2014 Tycho Andersen, 2012 Craig Barnes, 2013 horsik, 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be included in all copies
# or substantial portions of the Software.

import os
import re
import socket
import subprocess

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from typing import List

from Xlib import display as xdisplay


def get_num_monitors():
    num_monitors = 0
    try:
        display = xdisplay.Display()
        screen = display.screen()
        resources = screen.root.xrandr_get_screen_resources()

        for output in resources.outputs:
            monitor = display.xrandr_get_output_info(
                output, resources.config_timestamp)
            preferred = False
            if hasattr(monitor, "preferred"):
                preferred = monitor.preferred
            elif hasattr(monitor, "num_preferred"):
                preferred = monitor.num_preferred
            if preferred:
                num_monitors += 1
    except Exception as e:
        # always setup at least one monitor
        return 1
    else:
        return num_monitors


num_monitors = get_num_monitors()

mod = "mod1"
mod2 = "mod4"

def_term = "termite"
hostname = socket.gethostname()
HOME = os.path.expanduser("~/")
#CONFIG_FILE = os.path.expanduser("~/.config/qtile/config.py")


##### KEYBINDINGS #####
keys = [
    # The essentials
    Key([mod], "Return",
        lazy.spawn(def_term)
        ),
    Key([mod], "d",
        lazy.spawn("dmenu_run -p 'Run: '")
        ),
    Key([mod2], "d",
        lazy.spawn(
            "rofi -show drun -show-icons -lines 10 -columns 2 -opacity '80' -bw 1 -bc '#2f343f' -bg '#2f343f' -fg '#f3f4f5' -hlbg '#2f343f' -hlfg '#9575cd' -font 'Ubuntu 11' -width 50 -sidebar-mode -theme Arc-Dark")
        ),
    Key([mod2, "shift"], "space",
        lazy.next_layout()                      # Toggle through layouts
        ),
    Key([mod], "Escape",
        lazy.window.kill()                      # Kill active window
        ),
    Key([mod, "shift"], "r",
        lazy.restart()                          # Restart Qtile
        ),
    Key([mod, "shift"], "q",
        lazy.shutdown()                         # Shutdown Qtile
        ),

    # cycle to next group
    Key([mod], "p",
        lazy.screen.prev_group()
        ),
    Key([mod], "n",
        lazy.screen.next_group()
        ),

    # Switch focus to specific monitor (out of three)
    Key([mod], "w",
        # Keyboard focus to screen(0)
        lazy.to_screen(0)
        ),
    Key([mod], "e",
        # Keyboard focus to screen(1)
        lazy.to_screen(1)
        ),
    Key([mod], "r",
        # Keyboard focus to screen(2)
        lazy.to_screen(2)
        ),

    # Switch focus of monitors
    Key([mod], "period",
        lazy.next_screen()
        ),
    Key([mod], "comma",
        lazy.prev_screen()
        ),
    Key([mod], "Tab",
        lazy.screen.toggle_group()
        ),
    Key([mod2], "Tab",
        lazy.prev_screen()
        ),

    # Treetab controls
    # Key([mod, "control"], "k",
    #     lazy.layout.section_up()                # Move up a section in treetab
    #     ),
    # Key([mod, "control"], "j",
    #     lazy.layout.section_down()              # Move down a section in treetab
    #     ),

    # Window controls
    Key([mod], "h",
        lazy.layout.left()
        ),
    Key([mod], "l",
        lazy.layout.right()
        ),
    Key([mod], "j",
        lazy.layout.down()
        ),
    Key([mod], "k",
        lazy.layout.up()
        ),
    Key([mod, "shift"], "h",
        lazy.layout.swap_left()
        ),
    Key([mod, "shift"], "l",
        lazy.layout.swap_right()
        ),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down()
        ),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up()
        ),
    Key([mod], "i", lazy.layout.grow()
        ),
    Key([mod], "m", lazy.layout.shrink()
        ),
    Key([mod, "shift"], "n", lazy.layout.normalize()
        ),
    Key([mod], "o", lazy.layout.maximize()
        ),
    Key([mod, "shift"], "space", lazy.layout.flip()
        ),

    Key([mod], "f",
        lazy.window.toggle_fullscreen()
        ),

    # Stack controls
    Key([mod, "shift"], "space",
        lazy.layout.rotate(),                   # Swap panes of split stack (Stack)
        # Switch which side main pane occupies (XmonadTall)
        lazy.layout.flip()
        ),
    Key([mod], "space",
        lazy.window.toggle_floating()
        ),

    # Key([mod2], "n",
    #     lazy.layout.next()
    #     ),
    # Key([mod2], "p",
    #     lazy.layout.previous()
    #     ),

    Key([mod, "control"], "Return",
        # Toggle between split and unsplit sides of stack
        lazy.layout.toggle_split()
        ),
    # Sound
    Key([], "XF86AudioMute",
        lazy.spawn(os.path.expanduser("~/.config/i3/scripts/volume.sh mute"))
        ),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn(os.path.expanduser("~/.config/i3/scripts/volume.sh -5%"))
        ),
    Key([], "XF86AudioRaiseVolume",
        lazy.spawn(os.path.expanduser("~/.config/i3/scripts/volume.sh +5%"))
        ),
    Key([mod2], "i",
        lazy.spawn(os.path.expanduser(
            "~/.config/i3/scripts/select-screen-layout.sh"))
        ),
]

##### GROUPS #####
group_names = [("1", {'layout': 'monadtall'}),
               ("2", {'layout': 'monadtall'}),
               ("3", {'layout': 'monadtall'}),
               ("4", {'layout': 'monadtall'}),
               ("5", {'layout': 'monadtall'}),
               ("6", {'layout': 'monadtall'}),
               ("7", {'layout': 'monadtall'}),
               ("8", {'layout': 'monadtall'}),
               ("9", {'layout': 'floating'})]

groups = [Group(name, **kwargs) for name, kwargs in group_names]
for i, (name, kwargs) in enumerate(group_names, 1):
    # Switch to another group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    # Send current window to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))


##### DEFAULT THEME SETTINGS FOR LAYOUTS #####
layout_theme = {"border_width": 2,
                "margin": 3,
                "border_focus": "4c7899",
                "border_normal": "2f343f"
                }

##### THE LAYOUTS #####
layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Tile(shift_windows=True, **layout_theme),
    layout.Stack(num_stacks=2),
    layout.Floating(**layout_theme),
    # layout.Columns(**layout_theme),
    # layout.MonadWide(**layout_theme),
    # layout.Bsp(**layout_theme),
    # layout.Stack(stacks=2, **layout_theme),
    # layout.RatioTile(**layout_theme),
    # layout.VerticalTile(**layout_theme),
    # layout.Matrix(**layout_theme),
    # layout.Zoomy(**layout_theme),
    # layout.TreeTab(
    #     font="Ubuntu",
    #     fontsize=10,
    #     sections=["FIRST", "SECOND"],
    #     section_fontsize=11,
    #     bg_color="141414",
    #     active_bg="90C435",
    #     active_fg="000000",
    #     inactive_bg="384323",
    #     inactive_fg="a0a0a0",
    #     padding_y=5,
    #     section_top=10,
    #     panel_width=320
    # ),
]

##### COLORS #####
colors = [["#2f343f", "#2f343f"],  # panel background
          ["#434758", "#434758"],  # background for current screen tab
          ["#ffffff", "#ffffff"],  # font color for group names
          ["#ff5555", "#ff5555"],  # border line color for current tab
          ["#b8b9ba", "#b8b9ba"],  # border line color for other tab and odd widgets
          ["#668bd7", "#668bd7"],  # color for the even widgets
          ["#f3f4f5", "#f3f4f5"]]  # window name

##### PROMPT #####
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize=11,
    padding=2,
    background=colors[1]
)
widget_defaults2 = dict(
    font="Font Awesome 5 Brands",
    fontsize=12,
    padding=2,
    background=colors[1]
)
extension_defaults = widget_defaults.copy()

##### WIDGETS #####


def init_widgets_list():
    widgets_list = [
        widget.GroupBox(font="Ubuntu Bold",
                        fontsize=9,
                        margin_y=1,
                        margin_x=0,
                        padding_y=5,
                        padding_x=5,
                        borderwidth=3,
                        active=colors[2],
                        inactive=colors[2],
                        rounded=False,
                        highlight_color=colors[1],
                        highlight_method="line",
                        this_current_screen_border=colors[3],
                        this_screen_border=colors[4],
                        other_current_screen_border=colors[0],
                        other_screen_border=colors[0],
                        foreground=colors[2],
                        background=colors[1],
                        ),
        widget.Prompt(
            prompt=prompt,
            font="Ubuntu Mono",
            padding=10,
            foreground=colors[2],
            background=colors[1]
        ),
        widget.WindowName(
            foreground=colors[3],
            background=colors[1],
            markup=True,
            # padding=1
        ),
        widget.TextBox(
            text=" 🌡",
            padding=2,
            foreground=colors[2],
            background=colors[1],
            fontsize=11
        ),
        widget.ThermalSensor(
            foreground=colors[2],
            background=colors[1],
            padding=5
        ),
        widget.TextBox(
            text="",
            padding=2,
            foreground=colors[2],
            background=colors[1],
            fontsize=14
        ),
        widget.Pacman(
            execute="termite -e 'yay -Syyuu --topdown --cleanafter'",
            update_interval=1800,
            foreground=colors[2],
            background=colors[1]
        ),
        widget.TextBox(
            text="Updates",
            padding=5,
            foreground=colors[2],
            background=colors[1]
        ),
        widget.TextBox(
            text=" 🖬",
            foreground=colors[2],
            background=colors[1],
            padding=0,
            fontsize=14
        ),
        widget.Memory(
            foreground=colors[2],
            background=colors[1],
            padding=5
        ),
        widget.TextBox(
            text="",
            foreground=colors[2],
            background=colors[1],
            padding=0,
            fontsize=14
        ),
        widget.Wlan(
            foreground=colors[2],
            background=colors[1],
            padding=5
        ),
        widget.TextBox(
            text="🔉",
            foreground=colors[2],
            background=colors[1],
            padding=0
        ),
        widget.Volume(
            foreground=colors[2],
            background=colors[1],
            padding=5,
            emoji=False,
        ),
        widget.CurrentLayout(
            foreground=colors[2],
            background=colors[1],
            padding=5
        ),
        widget.TextBox(
            text=" ",
            foreground=colors[2],
            background=colors[1],
            padding=0
        ),
        widget.Clock(
            foreground=colors[2],
            background=colors[1],
            format="%Y-%M-%d %H:%M"
        ),
        widget.Systray(
            background=colors[1],
            icon_size=18,
            padding=1
        ),
    ]
    return widgets_list


# Main screen
screens = [
    Screen(top=bar.Bar(widgets=init_widgets_list(), opacity=0.95, size=19))
]

if num_monitors > 1:
    for m in range(num_monitors - 1):
        screens.append(
            Screen(
                bottom=bar.Bar(
                    [
                        widget.WindowName(
                            foreground=colors[3],
                            background=colors[1],
                            markup=True,
                            # padding=1
                        ),
                        widget.CurrentLayout(
                            foreground=colors[2],
                            background=colors[1],
                            padding=5
                        ),
                        widget.Clock(
                            foreground=colors[2],
                            background=colors[1],
                            format="%Y-%M-%d %H:%M"
                        ),
                    ],
                    size=20,
                    opacity=0.95,
                ),
            )
        )

##### DRAG FLOATING WINDOWS #####
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True

##### FLOATING WINDOWS #####
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

##### HOOKS #####
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])


# subscribe for change of screen setup, just restart if called
@hook.subscribe.screen_change
def restart_on_randr(qtile, ev):
    # TODO only if numbers of screens changed
    qtile.cmd_restart()


@hook.subscribe.client_new
def dialogs(window):
    if(window.window.get_wm_type() == 'dialog'
            or window.window.get_wm_transient_for()):
        window.floating = True


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
