local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gio = require("lgi").Gio

local apps = require("misc.apps")
local hover = require("components.widgets.hover")

local icon_size = beautiful.spacing_xl * 1.5
local spacing = beautiful.spacing_l

local function app_widget(app)
	local widget = wibox.widget({
		image = app.icon,
		forced_width = icon_size,
		forced_height = icon_size,
		buttons = { awful.button({}, 1, nil, app.launch) },
		widget = wibox.widget.imagebox,
	})

	return hover(widget)
end

-- stolen from settings/utils.lua
-- @HACK please dont use weird characters in your filename :3
local function listdir(directory)
	local files = {}

	-- this is recursive
	local handle = assert(io.popen(("find '%s' -type f,l -print0"):format(directory)))
	for path in handle:read("*a"):gmatch("[^\0]+") do
		table.insert(files, path)
	end
	handle:close()

	return files
end

return function(s)
	local entries_widget = wibox.widget({
		column_count = s.workarea.width / icon_size + spacing,
		spacing = spacing,
		layout = wibox.layout.grid.vertical,
	})

	for _, filename in ipairs(listdir(os.getenv("HOME") .. "/Desktop")) do
		local appinfo = gio.DesktopAppInfo.new_from_filename(filename)
		if appinfo then
			entries_widget:add(app_widget(apps.parse_appinfo(appinfo)))
		end
	end

	return wibox({
		widget = {
			entries_widget,
			margins = beautiful.useless_gap * 2,
			widget = wibox.container.margin,
		},
		bg = "#00000000",
		width = s.workarea.width,
		height = s.workarea.height,
		x = s.workarea.x,
		y = s.workarea.y,
		visible = true,
	})
end
