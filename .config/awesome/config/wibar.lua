-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
              require("awful.autofocus")

-- Theme handling library
local beautiful = require("beautiful")

-- Widget and layout library
local wibox = require("wibox")

local lain = require("lain")

-- import keys
local keys = require("config.keys")
local modkey = keys.modkey
local winkey = keys.winkey


-- ===================================================================
-- Widgets
-- ===================================================================
local cpu_widget = require("widgets.cpu-widget.cpu-widget")
local batteryarc_widget = require("widgets.batteryarc-widget.batteryarc")
local logout_menu_widget = require("widgets.logout-menu-widget.logout-menu")
local ram_widget = require("widgets.ram-widget.ram-widget")
local volume_widget = require('widgets.volume-widget.volume')
local brightness_widget = require("widgets.brightness-widget.brightness")
local calendar_widget = require("widgets.calendar-widget.calendar")

-- ===================================================================
-- Wibar setup
-- ===================================================================

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),

    awful.button({ modkey }, 1,
        function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),

    awful.button({ }, 3,        awful.tag.viewtoggle),

    awful.button({ modkey }, 3,
        function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),

    awful.button({ }, 4,
        function(t)
           awful.tag.viewnext(t.screen)
        end),

    awful.button({ }, 5,
        function(t)
            awful.tag.viewprev(t.screen)
        end)
) -- END taglist_buttons

local tasklist_buttons = gears.table.join(
    awful.button({ }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                c:emit_signal(
                    "request::activate",
                    "tasklist",
                    {raise = true}
                )
            end
        end),

    awful.button({ }, 3,
        function()
            awful.menu.client_list({ theme = { width = 250 } })
        end),

    awful.button({ }, 4,
        function ()
            awful.client.focus.byidx(1)
        end),

    awful.button({ }, 5,
        function ()
            awful.client.focus.byidx(-1)
        end)
) -- END tasklist_buttons


-- Create a textclock widget
-- will display when clicked on the date widget
mytextclock = wibox.widget.textclock("<span font='Terminus 5'> </span>%H:%M ")
mytextclock.font = beautiful.font

local cal_widget= calendar_widget({
    theme = 'nord',
    placement = 'top_right',
    radius = 8,
})
-- signal to show calendar on mouse click
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cal_widget.toggle() end
    end)

-- setup tags for each screen
awful.screen.connect_for_each_screen(function(s)

    --         1     2     3     4     5     6     7     8     9     10
    tagnum = {" ", " ", " ", " ", " ", " ", " ", " ", " ", ""}

    for i = 1, 10 do
        awful.tag.add((tagnum[i]), {
                layout = awful.layout.suit.tile,
                master_fill_policy = "expand",
                gap_single_client = false,
                master_count = 1,
                gap = 4,
                screen = s,
                index = i,
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
            mylauncher,
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
                -- main_color = beautiful.fg_color,
                main_color = "#43a047",
                bg_color = "#ffffff11",
                medium_level_color = "#c0ca33",
                low_level_color = "#e53935",
                charging_color = "#43a047",
            }),
            wibox.widget.textbox(" | "),
            wibox.widget.systray(),
            mytextclock,
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