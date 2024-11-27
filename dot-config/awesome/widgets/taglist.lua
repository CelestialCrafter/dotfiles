local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

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
		widget = wibox.container.margin
	},
	valign = "top",
	halign = "left",
	widget = wibox.container.place
}

return function(s)
	local width = beautiful.spacing_xl * 8
	-- @FIX add a limit for rendered tags OR resize previews if height exceeds limit
	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.noempty,
		layout = wibox.layout.fixed.vertical,
		style = {
			spacing = beautiful.spacing_m,
			shape = beautiful.rounded,
			bg_focus = beautiful.primary,
			bg_occupied = beautiful.overlay,
			bg_empty = beautiful.base
		},
		widget_template = {
			{
				id = "preview",
				resize = true,
				clip_shape = beautiful.rounded,
				widget = wibox.widget.imagebox
			},
			indicator,
			layout = wibox.layout.stack,
			create_callback = function(self, t)
				t:connect_signal("preview", function()
					self.preview.image = t.preview
				end)

				local wallpaper = beautiful.wallpaper(s)
				local w, h = gears.surface.get_size(wallpaper)
				local r = width / w
				self.preview.forced_height = h * r
				self.preview.image = wallpaper
			end
		},
		buttons = gears.table.join(awful.button({}, 1, function(t) t:view_only() end))
	})

	local margin = beautiful.spacing_m
	taglist = {
		{

			taglist,
			margins = margin,
			widget = wibox.container.margin
		},
		bg = beautiful.surface,
		widget = wibox.container.background,
		forced_width = width + (margin * 2)
	}

	return taglist
end
