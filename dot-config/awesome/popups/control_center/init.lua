local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local misc = require("misc")

local function user()
	local w = wibox.widget({
		{
			image = gears.surface.load(os.getenv("HOME") .. "/Pictures/user.png"),
			forced_height = beautiful.spacing_xl * 1.5,
			forced_width = beautiful.spacing_xl * 1.5,
			clip_shape = beautiful.rounded,
			widget = wibox.widget.imagebox,
		},
		{
			{
				{
					id = "user-host",
					widget = wibox.widget.textbox,
				},
				width = beautiful.spacing_xl * 6,
				height = misc.font_height(),
				widget = wibox.container.constraint,
			},
			valign = "center",
			widget = wibox.container.place,
		},
		spacing = beautiful.spacing_m,
		layout = wibox.layout.fixed.horizontal,
	})

	awful.spawn.easy_async("hostname", function(output)
		local textbox = w:get_children_by_id("user-host")[1]
		textbox.markup = string.format("<big>%s@%s</big>", os.getenv("USER"), output)
	end)

	return w
end

return function(s)
	if true then
		return
	end
	local control_center_widget = wibox.widget({
		{
			{
				user(),
				bottom = beautiful.spacing_s,
				widget = wibox.container.margin,
			},
			{
				wibox.widget({}),
				margins = beautiful.spacing_s,
				widget = wibox.container.margin,
				id = "content",
			},
			{
				{
					spacing = beautiful.spacing_s,
					layout = wibox.layout.fixed.horizontal,
					id = "pages",
				},
				halign = "center",
				valign = "bottom",
				widget = wibox.container.place,
			},
			fill_space = true,
			spacing = beautiful.spacing_s,
			layout = wibox.layout.fixed.vertical,
		},
		forced_height = s.workarea.height - beautiful.useless_gap * 4,
		forced_width = beautiful.spacing_xl * 12,
		margins = beautiful.spacing_m,
		widget = wibox.container.margin,
	})

	local content = control_center_widget:get_children_by_id("content")[1]
	local pages = control_center_widget:get_children_by_id("pages")[1]

	local page_ids = {
		"main",
		"network",
		"audio",
	}
	local page_colors = {
		beautiful.primary,
		beautiful.secondary,
		beautiful.accent,
	}

	local default = beautiful.colored_circle(beautiful.subtle)
	for i, id in pairs(page_ids) do
		local w = require("popups.control_center." .. id)()

		local selected = beautiful.colored_circle(page_colors[i])
		local function set_page()
			for j, p in ipairs(pages.children) do
				p.image = i == j and selected or default
			end
			content.widget = w
		end

		local pw = wibox.widget({
			image = default,
			forced_width = 32,
			forced_height = 32,
			widget = wibox.widget.imagebox,
		})
		pw:add_button(awful.button({}, 1, nil, set_page))
		pages:add(pw)

		if i == 1 then
			set_page()
		end
	end

	s.control_center = awful.popup({
		widget = control_center_widget,
		ontop = true,
		placement = function(d)
			awful.placement.left(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
		shape = beautiful.rounded,
	})

	return s.control_center
end
