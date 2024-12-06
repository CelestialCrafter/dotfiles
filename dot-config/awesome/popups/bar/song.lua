local wibox = require("wibox")
local beautiful = require("beautiful")

local player = require("playerctl").player
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
		if metadata == nil then
			s.text = ""
			widget.visible = false
			return
		end

		s.text = format(metadata)
		widget.visible = true
	end

	player:connect_signal("metadata", handle_metadata)
	handle_metadata(nil, player.metadata())

	return widget
end

