local awful = require("awful")
local gears = require("gears")

local misc = require("misc")

local function screenshot(c, s)
	local ss = awful.screenshot({ client = c, screen = s })
	ss:refresh()
	return ss.surface
end

return function(s)
	-- visual updates happen a bit after signal is sent
	local updated_timer = gears.timer({
		timeout = misc.general_update_interval,
		autostart = true,
		callback = function()
			if s.launcher.visible then
				return
			end

			local tags = s.selected_tags
			local full = screenshot(nil, s)

			for _, t in ipairs(tags) do
				t.preview = full
				t:emit_signal("preview")
			end

			for _, c in ipairs(s.clients) do
				c.preview = screenshot(c)
				c:emit_signal("preview")
			end

			collectgarbage("collect")
		end,
	})

	local function call()
		updated_timer:emit_signal("timeout")
	end

	local visual_timer = gears.timer({
		timeout = misc.visual_update_delay,
		single_shot = true,
		callback = call,
	})

	screen.connect_signal("tag::history::update", function()
		visual_timer:start()
	end)
	tag.connect_signal("tagged", call)
	tag.connect_signal("untagged", call)
end
