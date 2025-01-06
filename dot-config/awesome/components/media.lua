local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local mpris = require("dbus.mpris")
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
			id = "art",
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

local function format_sec(s)
	s = math.floor(s)
	return { m = math.floor(s / 60), s = s % 60 }
end

local function init()
	local model = {
		position = { length = 0, current = 0 },
	}

	local widget = gen_widget()
	local children = misc.children({
		"art",
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
	children.prev:add_button(awful.button({}, 1, nil, mpris.prev))
	children.progress:connect_signal("button::press", function(self, x)
		mpris.seek(1 / (self.forced_width / x))
	end)

	hover(children.play_pause)
	hover(children.next)
	hover(children.prev)
	hover(children.progress)

	return model,
		widget,
		function()
			local l = format_sec(model.position.length or 0)
			local c = format_sec(model.position.current or 0)

			children.art.image = model.art
			children.title.markup = model.title and "<big>" .. model.title .. "</big>" or "No Title"
			children.artist.text = model.artist or "No Artist"
			children.position.text = ("%02d:%02d/%02d:%02d"):format(table.unpack({ c.m, c.s, l.m, l.s }))
			children.progress.value = model.progress or 0
			children.play_pause.text = model.playing and "+" or "-"
		end
end

return function()
	local model, widget, view = init()

	local cache_path = gears.filesystem.get_cache_dir() .. "media-art/"
	gears.filesystem.make_directories(cache_path)

	local function handle_metadata(_, metadata)
		if not metadata then
			model.art = nil
			model.title = nil
			model.artist = nil
			model.position.length = nil
			view()
			return
		end

		local path, count = metadata.art:gsub("^file://", "")
		if count == 0 then
			path = cache_path .. hex(path)
		end

		local function set()
			model.art = gears.surface.load(path)
			collectgarbage("collect")
		end

		if not file_exists(path) then
			local cmd = string.format("curl -L -s %s -o %s", metadata.art, path)
			awful.spawn.with_line_callback(cmd, {
				exit = function()
					set()
					view()
				end,
			})
		else
			set()
		end

		model.title = metadata.title
		model.artist = table.concat(metadata.artists, ", ")
		model.position.length = metadata.length
		view()
	end

	local function handle_position(_, pos)
		if pos then
			model.position.current = pos
			model.progress = 1 / (model.position.length / pos)
		else
			model.position.current = nil
			model.progress = nil
		end

		view()
	end

	local function handle_playing(_, playing)
		model.playing = playing
		view()
	end

	mpris:connect_signal("metadata", handle_metadata)
	mpris:connect_signal("position", handle_position)
	mpris:connect_signal("playing", handle_playing)
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
