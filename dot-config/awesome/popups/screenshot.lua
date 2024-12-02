local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local function post_screenshot(self, filename, path)
	local ss = self.widget:get_children_by_id("screenshot")[1]
	local surface = gears.surface.load(path)
	local w, h = gears.surface.get_size(surface)

	local r = ss.forced_width / w
	ss.forced_height = h * r
	ss.image = surface

	local desc = self.widget:get_children_by_id("description")[1]
	desc.markup = "<big>Saved as " .. filename .. "</big>"

	self.visible = true
end

local function screenshot(self, skip)
	local date = os.date("%Y-%m-%d-%H%M%S")
	local random = string.format("%x", math.random(0, 255))
	local name = string.format("%s-%s.png", date, random)
	local path = os.getenv("HOME") .. "/Pictures/Screenshots/" .. name
	gears.filesystem.make_parent_directories(path)

	local copy = "xclip -selection clipboard -t image/png " ..  path
	local maim = "maim -u -s " .. path

	awful.spawn.easy_async(maim, function(_, _, _, code)
		if code ~= 0 then
			return
		end

		awful.spawn(copy)
		if not skip then
			post_screenshot(self, name, path)
		end
	end)
end

return function()
	local widget = wibox.widget {
		{
			{
				forced_width = beautiful.spacing_xl * 18,
				clip_shape = beautiful.rounded,
				widget = wibox.widget.imagebox,
				id = "screenshot"
			},
			{

				{
					{
						{
							halign = "center",
							widget = wibox.widget.textbox,
							id = "description"
						},
						margins = beautiful.spacing_xl,
						widget = wibox.container.margin
					},
					{
						{
							{
								{
									widget = wibox.widget.textbox,
									-- delete
									text = "-"
								},
								widget = wibox.container.background,
								bg = beautiful.secondary
							},
							{
								{
									widget = wibox.widget.textbox,
									-- open
									text = "*"
								},
								widget = wibox.container.background,
								bg = beautiful.primary
							},
							layout = wibox.layout.fixed.horizontal
						},
						margins = beautiful.spacing_m,
						widget = wibox.container.margin
					},
					layout = wibox.layout.stack
				},
				bg = beautiful.overlay,
				shape = beautiful.rounded,
				widget = wibox.container.background
			},
			spacing = beautiful.spacing_m,
			layout = wibox.layout.fixed.vertical
		},
		margins = beautiful.spacing_m,
		widget = wibox.container.margin
	}

	local popup = awful.popup {
		widget = widget,
		placement = awful.placement.centered,
		shape = beautiful.rounded,
		ontop = true,
		bg = beautiful.surface,
		hide_on_right_click = true,
		visible = false
	}

	popup:connect_signal("screenshot", screenshot)

	return popup
end
