local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local misc = require("misc")
local beautiful = require("beautiful")
local mpris = require("connect.mpris")

local function hex(str)
	return (str:gsub(".", function(c)
		return string.format("%02x", string.byte(c))
	end))
end

local function file_exists(name)
	local f = io.open(name, "r")
	return f ~= nil and io.close(f)
end

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

return function()
	local media_widget = wibox.widget({
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

	local function c(name)
		return media_widget:get_children_by_id(name)[1]
	end

	local image = c("image")
	local title = c("title")
	local artist = c("artist")
	local position = c("position")
	local progress = c("progress")

	local prev = c("prev")
	local play_pause = c("play_pause")
	local next = c("next")

	play_pause:add_button(awful.button({}, 1, nil, mpris.play_pause))
	next:add_button(awful.button({}, 1, nil, mpris.next))
	prev:add_button(awful.button({}, 1, nil, mpris.previous))
	progress:connect_signal("button::press", function(self, x)
		mpris.seek(20 or (1 / (self.forced_width / x)))
	end)

	local cache_path = gears.filesystem.get_cache_dir() .. "/media-art/"
	gears.filesystem.make_directories(cache_path)

	local length = 0
	local function handle_metadata(_, metadata)
		local path = cache_path .. hex(metadata.art)
		local function set()
			image.image = gears.surface.load(path)
		end

		if not file_exists(path) then
			local cmd = string.format("curl -L -s %s -o %s", metadata.art, path)
			awful.spawn.with_line_callback(cmd, {
				exit = set,
			})
		else
			set()
		end

		title.markup = "<big>" .. metadata.title .. "</big>"
		artist.text = metadata.artist
		length = metadata.length / 1e+6
	end

	local function handle_position(_, pos)
		local function sm(s)
			return math.floor(s / 60), s % 60
		end
		local cm, cs = sm(pos)
		local lm, ls = sm(length)

		position.text = string.format("%02d:%02d/%02d:%02d", cm, cs, lm, ls)
		progress.value = 1 / (length / pos)
	end

	local function handle_status(_, status)
		play_pause.text = status == "playing" and "+" or "-"
	end

	local function handle_empty()
		image.image = nil
		title.markup = ""
		artist.text = ""
		position.text = ""
		progress.value = 0
		play_pause.text = ""
	end

	handle_empty()
	mpris:connect_signal("metadata", handle_metadata)
	mpris:connect_signal("position", handle_position)
	mpris:connect_signal("status", handle_status)
	mpris:connect_signal("empty", handle_empty)

	return awful.popup({
		widget = media_widget,
		ontop = true,
		placement = function(d)
			awful.placement.top_right(d, {
				margins = beautiful.useless_gap * 2,
				honor_workarea = true,
			})
		end,
		bg = beautiful.surface,
		shape = beautiful.rounded,
		visible = false,
	})
end
