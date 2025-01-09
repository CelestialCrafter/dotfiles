local awful = require("awful")
local user = require("user")

local apps = require("misc.apps")

local autostart = { "picom" }

for _, proc in ipairs(autostart) do
	awful.spawn.easy_async("pkill " .. proc, function()
		awful.spawn(proc)
	end)
end

for _, id in ipairs(user.autostart) do
	assert(apps.entries[id], ("app id %s does not exist"):format(id)).launch()
end
