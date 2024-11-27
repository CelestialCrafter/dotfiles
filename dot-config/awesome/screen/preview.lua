local awful = require("awful")
local gears = require("gears")
local user = require("user")

local function screenshot(c, s)
	local ss = awful.screenshot { client = c, screen = s }
	ss:refresh()
	return ss.content_widget
end

return function(s)
	-- visual updates happen a bit after signal is sent
	local tag_updated = gears.timer {
		timeout = user.preview_update_interval,
		autostart = true,
		callback = function()
			local tags = s.selected_tags
			local full = screenshot(nil, s)

			for _, t in ipairs(tags) do
				t.preview = full
				t:emit_signal("preview")
			end

			for _, c in ipairs(s.clients) do
				c.preview = screenshot(c, nil)
				c:emit_signal("preview")
			end
		end
	}

	local function call() tag_updated:emit_signal("timeout") end

	screen.connect_signal("tag::history::update", call)
	tag.connect_signal("tagged", call)
	tag.connect_signal("untagged", call)
end
