-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

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


-- Modules
--
require('module.exit-screen')

-- widgets
--
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")
local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")
local ram_widget = require("awesome-wm-widgets.ram-widget.ram-widget")
local volume_widget = require('awesome-wm-widgets.volume-widget.volume')
local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local net_speed_widget = require("awesome-wm-widgets.net-speed-widget.net-speed")
local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

-- TODO
-- _G.root.keys(require('config.keys.global'))
-- _G.root.keys(require('config.keys.client'))


-- {{{ Error handling
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
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local themes = {
    "default",          -- 1*
    "copland",          -- 2**
    "dremora",          -- 3**
    "holo",             -- 4*
    "multicolor",       -- 5*
}
-- choose your theme here
local chosen_theme = themes[2]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

-- use window gaps
-- beautiful.useless_gap = 4

-- This is used later as the default terminal and editor to run.
home       = os.getenv("HOME")
confdir    = home .. "/.config/awesome"
scriptdir  = home .. "/.config/scripts"

terminal   = os.getenv("TERMINAL") or "alacritty"
browser    = os.getenv("BROWSER") or "firefox"
editor     = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
altkey = "Mod1"
winkey = "Mod4"
modkey = "Mod1"

controlKey = "Control"
shiftKey = "Shift"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {

    awful.layout.suit.tile,
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
-- }}}


-- {{{ Menu
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
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

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


local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end


-- Create a textclock widget
--  will display when clicked on the date widget
--
mytextclock = wibox.widget.textclock()
local cw = calendar_widget({
    theme = 'nord',
    placement = 'top_right',
    radius = 8,
})
mytextclock:connect_signal("button::press",
    function(_, _, _, button)
        if button == 1 then cw.toggle() end
    end)


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    -- set_wallpaper(s)

    -- {{{ Tags
    -- Define a tag table which hold all screen tags.

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
        })
    end

    -- https://awesomewm.org/doc/api/documentation/90-FAQ.md.html
    -- layouts    = awful.layout.layouts
    -- l_tiled    = layouts[1]
    -- l_max      = layouts[2]
    -- l_floating = layouts[3]
    -- tags = {
    --     names = {" ", " ", " ", " ", " ", " ", " ", " ", " ", ""},
    --     layout = {
    --         l_tiled,    -- 1
    --         l_max,      -- 2
    --         l_floating, -- 3
    --         l_tiled,    -- 4
    --         l_tiled,    -- 5
    --         l_tiled,    -- 6
    --         l_tiled,    -- 7
    --         l_tiled,    -- 8
    --         l_tiled,    -- 9
    --         l_tiled,    -- 10
    --     }
    -- }
    -- tags[s] = awful.tag(tags.names, s, tags.layouts[1])
    -- }}}

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
            mykeyboardlayout,
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
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}


-- {{{ Key bindings
globalkeys = gears.table.join(

    awful.key({ modkey, }, "s",       hotkeys_popup.show_help,
        {description="show help", group="awesome"}),

    awful.key({ modkey, }, "p",       awful.tag.viewprev,
        {description = "view previous", group = "tag"}),

    awful.key({ modkey, }, "n",       awful.tag.viewnext,
        {description = "view next", group = "tag"}),

    -- uses escape by default
    awful.key({ modkey, }, "Tab",  awful.tag.history.restore,
        {description = "go back", group = "tag"}),

    awful.key({ modkey, }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),

    -- ALSA volume control
    --
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")
        end),

    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.util.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")
        end),

    awful.key({ }, "XF86AudioMute",
        function ()
            awful.util.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
        end),

    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            awful.util.spawn("xbacklight -inc 10")
        end),
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            awful.util.spawn("xbacklight -dec 10")
        end),


    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    awful.key({ winkey,           }, "w",
        function ()
            mymainmenu:show()
        end,
        {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",
        function ()
            awful.client.swap.byidx(  1)
        end,
        {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey, "Shift"   }, "k",
        function ()
            awful.client.swap.byidx( -1)
        end,
        {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey, "Control" }, "j",
        function ()
            awful.screen.focus_relative( 1)
        end,
        {description = "focus the next screen", group = "screen"}),

    awful.key({ modkey, "Control" }, "k",
        function ()
            awful.screen.focus_relative(-1)
        end,
        {description = "focus the previous screen", group = "screen"}),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return",
        function ()
            awful.spawn(terminal)
        end,
        {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",
        function ()
            awful.tag.incmwfact( 0.05)
        end,
        {description = "increase master width factor", group = "layout"}),

    awful.key({ modkey,           }, "h",
        function ()
            awful.tag.incmwfact(-0.05)
        end,
        {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),

    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),

    awful.key({ modkey, "Control" }, "l",
        function ()
            awful.tag.incncol(-1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}),


    -- cycle layouts
    awful.key({ winkey,           }, "space",
        function ()
            awful.layout.inc( 1)
        end,
        {description = "select next", group = "layout"}),

    awful.key({ winkey, "Shift"   }, "space",
        function ()
            awful.layout.inc(-1)
        end,
        {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
            c:emit_signal(
                "request::activate", "key.unminimize", {raise = true}
            )
            end
        end,
        {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey, }, "r",
        function ()
            awful.spawn(string.format("dmenu_run -i -p 'Run '",
            beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
        end,
        {description = "show dmenu", group = "hotkeys"}),

    awful.key({ modkey, }, "d",
        function ()
            awful.spawn.with_shell("rofi -show drun -lines 10 -columns 1 -width 50 -sidebar-mode -dpi 150")
        end,
        {description = "show rofi", group = "hotkeys"}),

    awful.key({ modkey, }, "w",
        function ()
            awful.spawn.with_shell("rofi -show window -dpi 150")
        end,
        {description = "rofi show open windows", group = "hotkeys"}),

    awful.key({ winkey, }, "e",
        function ()
            awful.spawn.with_shell("thunar")
        end,
        {description = "rofi show open windows", group = "hotkeys"}),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
              }
        end,
        {description = "lua execute prompt", group = "awesome"}),


    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"}

    awful.key({modkey, 'Shift'}, 'x',
        function()
          _G.exit_screen_show()
        end,
        {description = 'Log Out Screen', group = 'awesome'})

) -- END globalkeys


clientkeys = gears.table.join(

    -- awful.key({ modkey, }, "f",
    --     function (c)
    --         c.fullscreen = not c.fullscreen
    --         c:rais)
    --     end,
    --     {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            local cur_tag = client.focus and client.focus.first_tag or nil
            for _, cls in ipairs(cur_tag:clients()) do
                -- minimize all windows except the focused one
                if c.window ~= cls.window then
                    cls.hidden = not cls.hidden
                end
            end
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    -- close window
    awful.key({ modkey, "Shift"   }, "c",
        function (c)
            c:kill()
        end,
        {description = "close", group = "client"}),

    -- toggle floating window
    awful.key({ modkey,            }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return",
        function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}),

    awful.key({ modkey,           }, "o",
        function (c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}),

    awful.key({ modkey,           }, "t",
        function (c)
            c.ontop = not c.ontop
        end,
        {description = "toggle keep on top", group = "client"}),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),

    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),

    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),


    -- By direction client focus
    --
    -- Moving window focus works between desktops
    --
    awful.key({ winkey,           }, "j",
        function (c)
            awful.client.focus.global_bydirection("down")
            c:lower()
        end,
        {description = "focus next window up", group = "client"}),

    awful.key({ winkey,           }, "k",
        function (c)
            awful.client.focus.global_bydirection("up")
            c:lower()
        end,
        {description = "focus next window down", group = "client"}),

    awful.key({ winkey,           }, "l",
        function (c)
            awful.client.focus.global_bydirection("right")
            c:lower()
        end,
        {description = "focus next window right", group = "client"}),

    awful.key({ winkey,           }, "h",
        function (c)
            awful.client.focus.global_bydirection("left")
            c:lower()
        end,
        {description = "focus next window left", group = "client"}),


    -- Moving windows between positions works between desktops
    --
    awful.key({ winkey, "Shift"   }, "h",
        function (c)
            awful.client.swap.global_bydirection("left")
            c:raise()
        end,
        {description = "swap with left client", group = "client"}),

    awful.key({ winkey, "Shift"   }, "l",
        function (c)
            awful.client.swap.global_bydirection("right")
            c:raise()
        end,
        {description = "swap with right client", group = "client"}),

    awful.key({ winkey, "Shift"   }, "j",
        function (c)
            awful.client.swap.global_bydirection("down")
            c:raise()
        end,
        {description = "swap with down client", group = "client"}),

    awful.key({ winkey, "Shift"   }, "k",
        function (c)
            awful.client.swap.global_bydirection("up")
            c:raise()
        end,
        {description = "swap with up client", group = "client"}),


    -- Moving floating windows
    --
    awful.key({ modkey, "Shift"   }, "Down",
        function (c)
            c:relative_move(  0,  10,   0,   0) end,
        {description = "Floating Move Down", group = "client"}),

    awful.key({ modkey, "Shift"   }, "Up",
        function (c)
            c:relative_move(  0, -10,   0,   0) end,
        {description = "Floating Move Up", group = "client"}),

    awful.key({ modkey, "Shift"   }, "Left",
        function (c)
            c:relative_move(-10,   0,   0,   0)
        end,
        {description = "Floating Move Left", group = "client"}),

    awful.key({ modkey, "Shift"   }, "Right",
        function (c)
            c:relative_move( 10,   0,   0,   0)
        end,
        {description = "Floating Move Right", group = "client"}),

   -- working toggle titlebar
    awful.key({ modkey, "Control" }, "t",
        function (c)
            awful.titlebar.toggle(c)
            -- awful.titlebar.hide(c)
        end,
        {description = "Show/Hide Titlebars", group="client"})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 9 do
for i = 0, 10 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description = "view tag #"..i, group = "tag"}),

        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
          {description = "move focused client to tag #"..i, group = "tag"}),

        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
          {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Add keys for tag 0
--
-- globalkeys = gears.table.join(globalkeys,
--     awful.key({ modkey }, "0",
--         function ()
--             local screen = awful.screen.focused()
--             local tag = screen.tags[10]
--             if tag then
--                 tag:view_only()
--             end
--         end,
--         {description = "view tag 0", group = "tag"}),
--     awful.key({ modkey, "Control" }, "0",
--         function ()
--             local screen = awful.screen.focused()
--             local tag = screen.tags[10]
--             if tag then
--                awful.tag.viewtoggle(tag)
--             end
--         end,
--         {description = "toggle tag 0", group = "tag"}),
--     awful.key({ modkey, "Shift" }, "0",
--         function ()
--             if client.focus then
--                 local tag = client.focus.screen.tags[10]
--                 if tag then
--                     client.focus:move_to_tag(tag)
--                 end
--             end
--         end,
--         {description = "move focused client to tag 0", group = "tag"}),
--     awful.key({ modkey, "Control", "Shift" }, "0",
--         function ()
--             if client.focus then
--                 local tag = client.focus.screen.tags[10]
--                 if tag then
--                     client.focus:toggle_tag(tag)
--                 end
--             end
--         end,
--         {description = "toggle focused client on tag 0", group = "tag"})
-- )


--
-- client buttons
--
clientbuttons = gears.table.join(

    awful.button({ }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
        end),

    awful.button({ modkey }, 1,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.move(c)
        end),

    awful.button({ modkey }, 3,
        function (c)
            c:emit_signal("request::activate", "mouse_click", {raise = true})
            awful.mouse.client.resize(c)
        end)
)

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
            instance = {
                "DTA",          -- Firefox addon DownThemAll.
                "copyq",        -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",   -- kalarm.
                "Sxiv",
                "Tor Browser",  -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "1Password",
                "Nitrogen",
                "Thunar",
                "Lxappearance",
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",     -- xev.
            },
            role = {
                "AlarmWindow",      -- Thunderbird's calendar.
                "ConfigManager",    -- Thunderbird's about:config.
                "pop-up",           -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, properties = {
            floating = true,
            centered = true,
            placement = awful.placement.centered+awful.placement.no_offscreen}
    },

    -- uncomment to enable title bars for floating only
    { rule_any = { type = { "floating" }
        }, properties = { titlebars_enabled = true }
    },

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
        }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "firefox" },
      properties = { screen = 1, tag = "2", switchtotag = true }
    },

    { rule = { role = "_NET_WM_STATE_FULLSCREEN" },
      properties = { floating = true }
    },

}
-- }}}


-- {{{ Signals
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

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- Autorun programs
awful.spawn.with_shell(confdir .. "/autostart.sh")

