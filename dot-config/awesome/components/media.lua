local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mpris = require("connect.mpris")
local hover = require("components.widgets.hover")
local misc = require("misc")

local function hex(str)
	return (str:gsub(".", function(c)
		return string.format("%02x", string.byte(c))
	end))
end

local function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

local function gen_widget()
	local font_height = misc.font_height()
	local height = beautiful.spacing_xl * 5
	local width = height * 2

	local info = {
		{
			widget = wibox.widget.textbox,
			forced_height = font_height,
			halign = "center",
			id = "title",
		},
		{
			{
				widget = wibox.widget.textbox,
				forced_height = font_height,
				halign = "center",
				id = "artist",
			},
			fg = beautiful.text_subtle,
			widget = wibox.container.background,
		},
		layout = wibox.layout.fixed.vertical,
		forced_width = width,
	}

	local controls = {
		{
			{
				halign = "center",
				widget = wibox.widget.textbox,
				id = "position",
			},
			widget = wibox.container.margin,
		},
		{
			forced_width = width,
			forced_height = beautiful.spacing_l,
			widget = wibox.widget.progressbar,
			color = beautiful.accent,
			background_color = beautiful.subtle,
			shape = beautiful.rounded,
			id = "progress",
		},
		{
			{
				{
					id = "prev",
					text = "<",
					widget = wibox.widget.textbox,
				},
				{
					id = "play_pause",
					widget = wibox.widget.textbox,
				},
				{
					id = "next",
					text = ">",
					widget = wibox.widget.textbox,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			halign = "center",
			widget = wibox.container.place,
		},
		spacing = beautiful.spacing_s,
		layout = wibox.layout.fixed.vertical,
	}

	return wibox.widget({
		{
			resize = true,
			forced_height = height,
			forced_width = height,
			widget = wibox.widget.imagebox,
			id = "image",
		},
		{
			{
				info,
				nil,
				controls,
				layout = wibox.layout.align.vertical,
			},
			margins = beautiful.spacing_l,
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
	})
end

local function init()
	local model = {}

	local widget = gen_widget()
	local children = misc.children({
		"image",
		"title",
		"artist",

		"position",
		"progress",

		"prev",
		"play_pause",
		"next",
	}, widget)

	children.play_pause:add_button(awful.button({}, 1, nil, mpris.play_pause))
	children.next:add_button(awful.button({}, 1, nil, mpris.next))
	children.prev:add_button(awful.button({}, 1, nil, mpris.previous))
	children.progress:connect_signal("button::press", function(self, x)
		mpris.seek(20 or (1 / (self.forced_width / x)))
	end)

	hover(children.play_pause)
	hover(children.next)
	hover(children.prev)
	hover(children.progress)

	return model,
		widget,
		function()
			children.image.image = model.image
			children.title.markup = model.title and "<big>" .. model.title .. "</big>" or "No Title"
			children.artist.text = model.artist or "No Artist"
			children.position.text = ("%02d:%02d/%02d:%02d"):format(table.unpack(model.position or { 0, 0, 0, 0 }))
			children.progress.value = model.progress or 0
			children.play_pause.text = model.status == "playing" and "+" or "-"
		end
end

return function()
	local model, widget, view = init()

	local cache_path = gears.filesystem.get_cache_dir() .. "/media-art/"
	gears.filesystem.make_directories(cache_path)

	local function handle_metadata(_, metadata)
		local path = cache_path .. hex(metadata.art)
		local function set()
			model.image = gears.surface.load(path)
		end

		if not file_exists(path) then
			local cmd = string.format("curl -L -s %s -o %s", metadata.art, path)
			awful.spawn.with_line_callback(cmd, {
				exit = set,
			})
		else
			set()
		end

		model.title = metadata.title
		model.artist = metadata.artist
		model.length = metadata.length / 1e+6
		view()
	end

	local function handle_position(_, pos)
		local length = model.length or 0

		local function sm(s)
			return math.floor(s / 60), s % 60
		end
		local cm, cs = sm(pos)
		local lm, ls = sm(length)

		model.position = { cm, cs, lm, ls }
		model.progress = 1 / (length / pos)
		view()
	end

	local function handle_status(_, status)
		model.status = status
		view()
	end

	local function handle_empty()
		model.image = nil
		model.title = nil
		model.artist = nil
		model.position = nil
		model.progress = nil
		model.status = nil
		view()
	end

	mpris:connect_signal("metadata", handle_metadata)
	mpris:connect_signal("position", handle_position)
	mpris:connect_signal("status", handle_status)
	mpris:connect_signal("empty", handle_empty)
	view()

	return awful.popup({
		widget = widget,
		ontop = true,
		placement = function(d)
			awful.placement.top_right(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
		shape = beautiful.rounded,
		visible = false,
	})
end
