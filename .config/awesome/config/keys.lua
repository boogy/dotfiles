local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local hotkeys_popup = require("awful.hotkeys_popup")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Define mod keys
-- set modkey to alt
local altkey = "Mod1"
local winkey = "Mod4"
local modkey = "Mod1"
local controlkey = "Control"
local shiftkey = "Shift"

-- This is used later as the default terminal and editor to run.
home       = os.getenv("HOME")
confdir    = home .. "/.config/awesome"
scriptdir  = home .. "/.config/scripts"

terminal   = os.getenv("TERMINAL") or "alacritty"
browser    = os.getenv("BROWSER") or "firefox"
editor     = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor


-- define module table
local keys = {}

keys.modkey = modkey
keys.altkey = altkey
keys.winkey = winkey
keys.controlkey = controlkey
keys.shiftkey = shiftkey

-- ===================================================================
-- Mouse bindings
-- ===================================================================

keys.mousebuttons = gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
)


-- ===================================================================
-- Global keys
-- ===================================================================

keys.globalkeys = gears.table.join(

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
            -- TODO: use awesome dpi() function for rofi
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

    awful.key( { modkey }, "b",
        function ()
            mouse.screen.mywibox.visible = not mouse.screen.mywibox.visible
        end,
        {description = "Toggle wibox visibility", group = "awesome"}),

    -- Menubar
    -- awful.key({ modkey }, "p", function() menubar.show() end,
    --           {description = "show the menubar", group = "launcher"})
    awful.key({modkey, 'Shift'}, 'x',
        function()
          _G.exit_screen_show()
        end,
        {description = 'Log Out Screen', group = 'awesome'})

)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
-- for i = 1, 9 do
for i = 0, 10 do
    keys.globalkeys = gears.table.join(keys.globalkeys,
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


-- ===================================================================
-- Client keys
-- ===================================================================

keys.clientkeys = gears.table.join(

    awful.key({ modkey }, "f",
        function (c)
            -- hide wibox when client is fullscreen
            mouse.screen.mywibox.visible = c.fullscreen

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
    awful.key({ modkey }, "space",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return",
        function (c)
            c:swap(awful.client.getmaster())
        end,
        {description = "move to master", group = "client"}),

    awful.key({ modkey }, "o",
        function (c)
            c:move_to_screen()
        end,
        {description = "move to screen", group = "client"}),

    awful.key({ modkey }, "t",
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

    awful.key({ modkey }, "m",
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


-- ===================================================================
-- Client buttons
-- ===================================================================

keys.clientbuttons = gears.table.join(

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


-- ===================================================================
-- Wibox keys / buttons
-- ===================================================================

-- Tag list buttons for wibox
keys.taglist_buttons = gears.table.join(
    awful.button({ }, 1,
        function(t)
            t:view_only()
        end),

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


-- Task list buttons
keys.tasklist_buttons = gears.table.join(
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


return keys