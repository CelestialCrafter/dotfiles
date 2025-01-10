local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local hover = require("components.widgets.hover")

return function(s)
	local width = beautiful.spacing_xl * 8

	local indicator = {
		{
			{
				{
					id = "text_role",
					align = "center",
					widget = wibox.widget.textbox,
				},
				id = "background_role",
				widget = wibox.container.background,
				forced_width = beautiful.spacing_xl,
				forced_height = beautiful.spacing_xl,
			},
			margins = beautiful.spacing_s,
			widget = wibox.container.margin,
		},
		valign = "top",
		halign = "left",
		widget = wibox.container.place,
	}

	local taglist = awful.widget.taglist({
		screen = s,
		-- @TODO filter out tags that go off the screen
		filter = function(t)
			local default_filter = awful.widget.taglist.filter.noempty
			if default_filter(t) then
				return true
			end

			-- show last non-empty tag + 1
			for i = #s.tags, t.index - 1, -1 do
				local tag = s.tags[i]
				if default_filter(tag) then
					return t.index == tag.index + 1
				end
			end

			return false
		end,
		layout = wibox.layout.fixed.vertical,
		style = {
			spacing = beautiful.spacing_m,
			shape = beautiful.rounded,
			bg_focus = beautiful.accent,
			bg_occupied = beautiful.overlay,
			bg_empty = beautiful.overlay,
		},
		widget_template = {
			{
				id = "preview",
				resize = true,
				clip_shape = beautiful.rounded,
				widget = wibox.widget.imagebox,
			},
			indicator,
			layout = wibox.layout.stack,
			create_callback = function(self, t)
				hover(self)
				t:connect_signal("preview", function()
					self.preview.image = t.preview
				end)

				local wallpaper = beautiful.wallpaper(s)
				local w, h = gears.surface.get_size(wallpaper)
				local r = width / w
				self.preview.forced_height = h * r
				self.preview.image = wallpaper
			end,
		},
		buttons = gears.table.join(awful.button({}, 1, function(t)
			t:view_only()
			s.launcher.visible = false
		end)),
	})

	local margin = beautiful.spacing_m
	taglist = {
		{

			taglist,
			margins = margin,
			widget = wibox.container.margin,
		},
		bg = beautiful.surface,
		forced_width = width + (margin * 2),
		shape = beautiful.rounded,
		widget = wibox.container.background,
		id = "taglist",
	}

	return taglist
end
