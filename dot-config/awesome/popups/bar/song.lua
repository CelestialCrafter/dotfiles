local wibox = require("wibox")
local beautiful = require("beautiful")
local mpris     = require("connect.mpris")

local element = require("widgets.element")

return function()
	local function format(metadata)
		return metadata.title .. ' - ' .. metadata.artist
	end

	local widget = element({
		{
			widget = wibox.widget.textbox,
			id = "song"
		},
		widget = wibox.container.constraint,
		width = beautiful.spacing_xl * 10
	})

	local s = widget:get_children_by_id("song")[1]
	local function handle_metadata(_, metadata)
		s.text = format(metadata)
		widget.visible = true
	end

	mpris:connect_signal("metadata", handle_metadata)

	return widget
end

