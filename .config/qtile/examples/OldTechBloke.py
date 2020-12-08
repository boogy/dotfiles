# -*- coding: utf-8 -*-
import os
import re
import socket
import subprocess
from libqtile.config import Drag, Key, Screen, Group, Drag, Click, Rule
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook
from libqtile.widget import Spacer


mod = "mod4"
mod1 = "alt"
mod2 = "control"
myTerm = "alacritty"
home = os.path.expanduser('~')


def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

def window_to_previous_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group)

def window_to_next_screen(qtile):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group)

def switch_screens(qtile):
    i = qtile.screens.index(qtile.current_screen)
    group = qtile.screens[i - 1].group
    qtile.current_screen.set_group(group)

keys = [

    # Launch terminal, kill window, restart and exit Qtile

    Key([mod], "Return", lazy.spawn(myTerm)),
    Key([mod], "w", lazy.window.kill()),
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "q", lazy.shutdown()),
    Key([mod], "x", lazy.spawn("powerspec")),

    # Dmenu, Rofi and Gmrun

    Key([mod, "mod1"], "d", lazy.spawn("dmenu_run")),
    Key([mod, "mod1"], "n", lazy.spawn("networkmanager_dmenu")),
    Key([mod, "mod1"], "r", lazy.spawn("dmenufm")),
    Key([mod, "mod1"], "space", lazy.spawn("rofi -modi drun -show drun -show-icons")),
    Key([mod, "mod1"], "c", lazy.spawn("rofi -show emoji -modi emoji")),
    Key([mod, "mod1"], "v", lazy.spawn("rofi-locate")),
    Key([mod, "mod1"], "z", lazy.spawn("gmrun")),

    # Custom key bindings

    Key([mod, "mod1"], "w", lazy.spawn("chromium")),
    Key([mod, "mod1"], "f", lazy.spawn("pcmanfm")),
    Key([mod, "mod1"], "t", lazy.spawn("geany")),
    Key([mod, "mod1"], "s", lazy.spawn("pamac-manager")),
    Key([mod, "mod1"], "i", lazy.spawn("nitrogen")),
    Key([mod, "mod1"], "p", lazy.spawn('pavucontrol')),

    # Volume keys

    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+")),

    # Brightness Keys

    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),

    # Toggle layouts

    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "space", lazy.next_layout()),
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),

   # Change window focus

    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod, "mod1"], "h", lazy.layout.previous()), # Stack
    Key([mod, "mod1"], "l", lazy.layout.next()),     # Stack

   # Switch focus to a physical monitor (dual/triple set up)

    Key([mod], "period", lazy.next_screen()),
    Key([mod], "comma", lazy.prev_screen()),
    Key([mod], "a", lazy.to_screen(0)),
    Key([mod], "b", lazy.to_screen(1)),
    Key([mod], "c", lazy.to_screen(2)),

   # Move windows to different physical screens

    Key([mod, "shift"], "period", lazy.function(window_to_previous_screen)),
    Key([mod, "shift"], "comma", lazy.function(window_to_next_screen)),
    Key([mod], "t", lazy.function(switch_screens)),


   # Resize layout

    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),

   # Flip left and right pains and move windows

    Key([mod, "shift"], "f", lazy.layout.flip()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod], "m", lazy.layout.toggle_maximize()), # Stack
    Key([mod, "shift"], "Left",
        lazy.layout.swap_left(),
        lazy.layout.client_to_previous()), # Stack
    Key([mod, "shift"], "Right",
        lazy.layout.swap_right(),
        lazy.layout.client_to_next()), # Stack

        ]

groups = []

   # Allocate layouts and labels

group_names = ["1", "2", "3", "4", "5", "6", "7", "8",]
group_labels = ["", "", "", "", "", "", "", "",]
group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

   # Workspace navigation

    Key([mod], i.name, lazy.group[i.name].toscreen()),
    Key([mod], "Tab", lazy.screen.next_group()),
    Key([mod, "control"], i.name, lazy.window.togroup(i.name)),
    Key([mod, "shift"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin":5,
            "border_width":2,
            "border_focus": "#5e81ac",
            "border_normal": "#4c566a"
            }

layout_theme = init_layout_theme()


layouts = [
    layout.MonadTall(margin=5, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    layout.MonadWide(margin=8, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    layout.Stack(stacks=2, **layout_theme),
    layout.Floating(**layout_theme),
    layout.Max(**layout_theme)
]

   # Bar colours

def init_colors():
    return [["#2E3440", "#2E3440"], # color 0
            ["#2E3440", "#2E3440"], # color 1
            ["#c0c5ce", "#c0c5ce"], # color 2
            ["#fba922", "#fba922"], # color 3
            ["#3384d0", "#3384d0"], # color 4
            ["#f3f4f5", "#f3f4f5"], # color 5
            ["#cd1f3f", "#cd1f3f"], # color 6
            ["#62FF00", "#62FF00"], # color 7
            ["#6790eb", "#6790eb"], # color 8
            ["#a9a9a9", "#a9a9a9"]] # color 9


colors = init_colors()


   # Widgets

def init_widgets_defaults():
    return dict(font="UbuntuMono Nerd Font",
                fontsize = 14,
                padding = 2,
                background=colors[1])

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
               widget.GroupBox(font="FontAwesome",
                        fontsize = 14,
                        margin_y = 3,
                        margin_x = 0,
                        padding_y = 6,
                        padding_x = 5,
                        borderwidth = 0,
                        disable_drag = True,
                        active = colors[9],
                        inactive = colors[5],
                        rounded = False,
                        highlight_method = "text",
                        this_current_screen_border = colors[8],
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.CurrentLayout(
                        font = "UbuntuMono Nerd Font",
                        fontsize = 14,
                        foreground = colors[5],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.WindowName(font="UbuntuMono Nerd Font",
                        fontsize = 14,
                        foreground = colors[5],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
              widget.CurrentLayoutIcon(
                       foreground = colors[5],
                       background = colors[1],
                       padding = 0,
                       scale = 0.7
                       ),
              widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.TextBox(
                        text="  🖥️ ",
                        foreground=colors[6],
                        background=colors[1],
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e gtop')},
                        padding = 2,
                        fontsize=12
                        ),
               widget.CPU(
            format = '{load_percent}% ',
            font = "UbuntuMono Nerd Font",
                        fontsize = 14,
            foreground = colors[5],
                        background = colors[1],
                        update_interval = 3
            ),
                widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
                widget.TextBox(
                        text="  🧠 ",
                        foreground=colors[4],
                        background=colors[1],
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e htop')},
                        padding = 0,
                        fontsize=12
                        ),
                widget.Memory(
                        font="UbuntuMono Nerd Font",
                        format = '{MemUsed}M/{MemTotal}M ',
                        update_interval = 1,
                        fontsize = 14,
                        foreground = colors[5],
                        background = colors[1]
                        ),
                widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
                widget.TextBox(
                        text = " 🌡️",
                        padding = 2,
                        foreground = colors[5],
                        background = colors[1],
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('xsensors')},
                        fontsize = 12
                        ),
                widget.ThermalSensor(
                        font="UbuntuMono Nerd Font",
                        fontsize = 14,
                        fmt = '{} ',
                        foreground = colors[5],
                        background = colors[1],
                        threshold = 90,
                        padding = 5
                        ),
                widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.TextBox(
                        text = " 💾",
                        foreground = colors[5],
                        background = colors[1],
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('xdiskusage')},
                        padding = 0,
                        fontsize = 12
                        ),
               widget.GenPollText(
            update_interval=60,
            fmt = ' {} ',
            font="UbuntuMono Nerd Font",
                        fontsize = 14,
            func = lambda: subprocess.check_output("/home/steve/dwmscripts/qtiledisk").decode("utf-8").replace('\n', ''),
            foreground = colors[5],
                        background = colors[1]
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
           widget.TextBox(
                        text = " 🔊",
                        foreground = colors[5],
                        background = colors[1],
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(myTerm + ' -e pulsemixer')},
                        padding = 0,
                        fontsize = 12
                        ),
               widget.Volume(
                        font="UbuntuMono Nerd Font",
                        fontsize = 14,
                        fmt = '{} ',
                        channel = 'Master',
                        foreground = colors[5],
                        background = colors[1],
                        padding = 5
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Battery(
                        format = '{char}{percent:2.0%}',
                        charge_char = '⚡ ',
                        discharge_char = '🔋 '
                        ),
               widget.Sep(
                         linewidth = 1,
                         padding = 10,
                         foreground = colors[2],
                         background = colors[1]
                         ),
               widget.TextBox(
                        text = " 🛠️ ",
                        foreground = colors[5],
                        background = colors[1],
                        mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn('pamac-manager')},
                        padding = 0,
                        fontsize = 12
                        ),
               widget.GenPollText(
                    update_interval=1800,
                fmt = ' {} ',
                font="UbuntuMono Nerd Font",
                        fontsize = 14,
                func = lambda: subprocess.check_output("/home/steve/dwmscripts/qtileupdates").decode("utf-8").replace('\n', ''),
                foreground = colors[5],
                        background = colors[1]
                ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.TextBox(
                        text = " 📅 ",
                        padding = 0,
                        fontsize=12
                        ),
               widget.Clock(
                        foreground = colors[5],
                        background = colors[1],
                        font="UbuntuMono Nerd Font",
                        fontsize = 14,
                        format="%d-%m-%Y %H:%M"
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
             ]
    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26)),
            Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26))]

screens = init_screens()


   # Mouse config

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []


main = None

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'Arandr'},
    {'wname': 'branchdialog'},
    {'wname': 'Open File'},
    {'wmclass': 'ssh-askpass'},

],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True

focus_on_window_activation = "focus" # or smart

wmname = "LG3D"
