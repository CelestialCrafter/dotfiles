local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

return function(s)
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
				widget = wibox.container.margin,
			},
			indicator,
			forced_width = beautiful.spacing_xl * 8,
			layout = wibox.layout.stack,
			create_callback = function(self, t)
				local function set_properties()
					self.preview.widget.resize = true
					self.preview.widget.clip_shape = beautiful.rounded
				end

				t:connect_signal("preview", function()
					self.preview.widget = t.preview
					set_properties()
				end)

				local wallpaper = beautiful.wallpaper(s)
				local w, h = gears.surface.get_size(wallpaper)
				local r = self.forced_width / w
				self.forced_height = h * r

				self.preview.widget = wibox.widget.imagebox(wallpaper, true)
				set_properties()
			end
		},
		buttons = gears.table.join(
		awful.button({}, 1, function(t)
			t:view_only()
		end),
		awful.button({}, 3, awful.tag.viewtoggle)
		)
	})

	-- @FIX add a limit for rendered tags OR resize previews if height exceeds limit
	s.taglist = awful.popup {
		widget = {
			taglist,
			margins = beautiful.spacing_m,
			widget = wibox.container.margin
		},
		placement = function(d) awful.placement.left(d, { margins = beautiful.useless_gap * 2 }) end,
		shape = beautiful.rounded,
		bg = beautiful.base,
		ontop = true,
		visible = true
	}
end
