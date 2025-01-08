local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local misc = require("misc")

local function gen_widget()
	return wibox.widget({
		{
			forced_width = beautiful.spacing_xl * 24,
			ellipsize = "start",
			widget = wibox.widget.textbox,
			id = "text",
		},
		margins = beautiful.spacing_l,
		widget = wibox.container.margin,
	})
end

local history_prefix = awful.util.get_cache_dir() .. "/history_"

return function(s)
	local widget = gen_widget()
	local text = misc.children("text", widget)

	s.execute = awful.popup({
		shape = beautiful.rounded,
		widget = widget,
		placement = function(d)
			awful.placement.top(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
		ontop = true,
		visible = false,
	})

	local function done()
		s.execute.visible = false
	end

	s.execute:connect_signal("lua", function()
		awful.prompt.run({
			prompt = "Lua: ",
			textbox = text,
			history_path = history_prefix .. "lua",
			exe_callback = awful.util.eval,
			done_callback = done,
		})
		s.execute.visible = true
	end)

	s.execute:connect_signal("command", function()
		awful.prompt.run({
			prompt = "Command: ",
			textbox = text,
			history_path = history_prefix .. "command",
			exe_callback = awful.spawn.with_shell,
			done_callback = done,
		})
		s.execute.visible = true
	end)
end
