local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful.xresources").apply_dpi

-- No borders if only one window on screen
function border_adjust(c)
    if #c.screen.clients == 1 then
        c.border_width = 0
    elseif #c.screen.clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end