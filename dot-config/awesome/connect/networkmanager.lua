local gears = require("gears")
local glib = require("lgi").GLib

-- avoid circular dependence
local c = function()
    return require("connect")
end

local M = gears.object {}

function M.networks(networks)
    M:emit_signal("networks", networks)
end

function M.connect(ssid)
    c().signal("Connect", glib.Variant("(s)", { ssid }))
end

function M.disconnect(ssid)
    c().signal("Disconnect", glib.Variant("(s)", { ssid }))
end

return M
