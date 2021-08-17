-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- ===================================================================
-- Library imports
-- ===================================================================
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
              require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 100

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")


-- ===================================================================
-- Configuration
-- ===================================================================
local keys = require("config.keys")
local clientkeys = keys.clientkeys
local clientbuttons = keys.clientbuttons
local modkey = keys.modkey
local winkey = keys.winkey

-- add keys
root.keys(keys.globalkeys)
root.buttons(keys.mousebuttons)

-- import rules
require("config.rules")


-- ===================================================================
-- Modules
-- ===================================================================
require('modules.exit-screen')


-- ===================================================================
-- Widgets
-- ===================================================================
local cpu_widget = require("widgets.cpu-widget.cpu-widget")
local batteryarc_widget = require("widgets.batteryarc-widget.batteryarc")
local logout_menu_widget = require("widgets.logout-menu-widget.logout-menu")
local ram_widget = require("widgets.ram-widget.ram-widget")
local volume_widget = require('widgets.volume-widget.volume')
local brightness_widget = require("widgets.brightness-widget.brightness")
local net_speed_widget = require("widgets.net-speed-widget.net-speed")
local calendar_widget = require("widgets.calendar-widget.calendar")


-- ===================================================================
-- Error handling
-- ===================================================================

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end


-- ===================================================================
-- Variable definitions
-- ===================================================================

-- use window gaps
-- beautiful.useless_gap = 4

-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local themes = {
    "copland",          -- 1
    "default",          -- 2
}
-- choose your theme here
local chosen_theme = themes[1]
beautiful.init(
    string.format("%s/.config/awesome/themes/%s/theme-personal.lua", os.getenv("HOME"), chosen_theme)
)


-- ===================================================================
-- Layouts
-- ===================================================================

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {

    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,

    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


-- ===================================================================
-- Menu setup
-- ===================================================================

-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys"     , function() hotkeys_popup.show_help(nil  , awful.screen.focused()) end } ,
   { "manual"      , terminal .. " -e man awesome" }         ,
   { "edit config" , editor_cmd .. " " .. awesome.conffile } ,
   { "restart"     , awesome.restart }                       ,
   { "quit"        , function() awesome.quit() end }         ,
}

mymainmenu = awful.menu({
        items = {
            { "awesome"       , myawesomemenu , beautiful.awesome_icon }                             ,
            { "open terminal" , terminal      , "/usr/share/icons/Papirus/32x32/apps/Alacritty.svg"} ,
            { "Firefox"       , browser       , "/usr/share/icons/hicolor/48x48/apps/firefox.png"}
        }
    })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it


-- ===================================================================
-- Wibar setup
-- ===================================================================
-- import keys / buttons for wibox
local taglist_buttons = keys.taglist_buttons
local tasklist_buttons = keys.tasklist_buttons

-- Create a textclock widget
local mytextclock = wibox.widget.textclock("%a %b %d %H:%M")
mytextclock.font = beautiful.font

local cw = calendar_widget({
    theme = 'nord',
    placement = 'top_right',
    radius = 8,
})
-- show calendar_widget on mouse 1 click
mytextclock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then cw.toggle() end
end)


-- setup tags for each screen
awful.screen.connect_for_each_screen(function(s)
    --         1     2     3     4     5     6     7     8     9     10
    tagnum = {" ", " ", " ", " ", " ", " ", " ", " ", " ", ""}

    for i = 1, 10 do
        awful.tag.add((tagnum[i]), {
                layout = awful.layout.suit.tile,
                -- master_fill_policy = "expand",
                gap_single_client = false,
                master_count = 1,
                gap = 4,
                screen = s,
        })
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })


    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            wibox.widget.textbox(" "),
            s.mytaglist,
            wibox.widget.textbox(" "),
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget

        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            -- net_speed_widget(),
            wibox.widget.textbox(" "),
            cpu_widget({
                width = 70,
                step_width = 4,
                step_spacing = 1,
                timeout = 1,
                color = "#e53935",
            }),
            wibox.widget.textbox(" "),
            volume_widget{
                widget_type = 'icon_and_text'
                -- widget_type = 'horizontal_bar',
                -- with_icon = true,
            },
            wibox.widget.textbox(" "),
            brightness_widget{
                type = 'icon_and_text',
                program = 'xbacklight',
                step = 5,
            },
            wibox.widget.textbox(" "),
            ram_widget({
                color_used = "#e53935",
                color_free = "#43a047",
                timeout    = 2,
            }),
            wibox.widget.textbox(" "),
            batteryarc_widget({
                show_current_level = true,
                arc_thickness = 2,
                size = 20,
                main_color = "#43a047",
                bg_color = "#ffffff11",
                medium_level_color = "#c0ca33",
                low_level_color = "#e53935",
                charging_color = "#43a047",
            }),
            wibox.widget.textbox(" | "),
            wibox.widget.systray(),
            wibox.widget.textbox(" | "),
            mytextclock,
            wibox.widget.textbox(" | "),
            logout_menu_widget {
                font = 'Play 14',
                onlock = function() awful.spawn.with_shell('i3lock-fancy') end,
                onreboot = function() awful.spawn.with_shell("reboot") end,
                onpoweroff = function() awful.spawn.with_shell("systemctl poweroff") end
            },
            s.mylayoutbox,
        },
    }
end)


-- ===================================================================
-- Signals
-- ===================================================================

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)
screen.connect_signal("property::geometry", function()
    awful.spawn.with_shell("nitrogen --restore")
end)


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("property::floating", function(c)
    if c.floating then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

-- remove gaps if layout is set to max
tag.connect_signal('property::layout', function(t)
   local current_layout = awful.tag.getproperty(t, 'layout')
   if (current_layout == awful.layout.suit.max) then
      t.gap = 0
   else
      t.gap = beautiful.useless_gap
   end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- ===================================================================
-- Autorun programs
-- ===================================================================
awful.spawn.with_shell(confdir .. "/autostart.sh")
