-- import libraries
local awful = require("awful")
local beautiful = require("beautiful")

-- import keys
local keys = require("config.keys")
local clientbuttons = keys.clientbuttons
local clientkeys = keys.clientkeys

-- ===================================================================
-- Rules
-- ===================================================================

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
        },
        properties = {
            floating = true,
            centered = true,
            placement = awful.placement.centered+awful.placement.no_offscreen
        }
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
        properties = {
            screen = awful.screen.focused(),
            tag = function() return awful.screen.focused().tags[2] end,
            switchtotag = true,
        }
    },

    { rule = { role = "_NET_WM_STATE_FULLSCREEN" },
      properties = { floating = true }
    },

}