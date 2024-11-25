local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local user = require("user")

local popups = {}

local function render_preview(tag)
	if tag.preview == nil then
		return
	end

	if popups[tag.index] == nil then
		popups[tag.index] = awful.popup {
			widget = {},
			visible = true
		}
	end

	local preview = tag.preview
	local popup = popups[tag.index]

	preview.forced_width = 192
	preview.forced_height = 108

	popup.x = tag.index * 200
	popup.y = 80
	popup.widget = preview
end

local function screenshot(c, s)
	local ss = awful.screenshot { client = c, screen = s }
	ss:refresh()

	local ib = ss.content_widget
	ib.valign = "center"
	ib.halign = "center"
	return ib
end

return function(s)
	local function tag_updated(initial)
		-- visual updates happen a bit after signal is sent
		gears.timer {
			timeout = 0.1,
			autostart = true,
			single_shot = true,
			callback = function()
				local tags
				local full

				if initial == true then
					tags = s.tags
					full = beautiful.wallpaper(s)
				else
					tags = s.selected_tags
					full = screenshot(nil, s)
				end

				for _, tag in ipairs(tags) do
					tag.preview = full
					for _, c in ipairs(tag:clients()) do
						c.preview = screenshot(c, nil)
					end

					render_preview(tag)
				end
			end
		}
	end

	gears.timer {
		timeout = user.preview_update_interval,
		autostart = true,
		callback = tag_updated
	}

	tag_updated(true)
	screen.connect_signal("tag::history::update", tag_updated)
	tag.connect_signal("tagged", tag_updated)
	tag.connect_signal("untagged", tag_updated)
end
