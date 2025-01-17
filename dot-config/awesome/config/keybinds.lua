local awful = require("awful")
local mpris = require("core.mpris")
local backlight = require("core.backlight")

local user = require("user")
local pulseaudio = require("core.pulseaudio")
local screenshot = require("misc.screenshot")
local apps = require("misc.apps")

local M = {}

local modkey = "Mod4"
local function s()
	return awful.screen.focused()
end

awful.keyboard.append_global_keybindings({
	-- awesome
	awful.key({ "Mod1", "Control" }, "r", awesome.restart, { description = "reload", group = "awesome" }),
	awful.key({ "Mod1", "Control" }, "q", awesome.quit, { description = "quit", group = "awesome" }),

	awful.key({}, "Print", screenshot, { description = "screenshot", group = "awesome" }),

	-- media
	awful.key({}, "XF86AudioMute", function()
		pulseaudio.muted = not pulseaudio.muted
		s().osd:emit_signal("show", "pulseaudio")
	end),

	awful.key({}, "XF86AudioLowerVolume", function()
		pulseaudio.volume = math.max(pulseaudio.volume - user.volume_adjust, 0)
		s().osd:emit_signal("show", "pulseaudio")
	end),
	awful.key({}, "XF86AudioRaiseVolume", function()
		pulseaudio.volume = math.min(pulseaudio.volume + user.volume_adjust, 100)
		s().osd:emit_signal("show", "pulseaudio")
	end),

	awful.key({}, "XF86AudioPlay", function()
		mpris.play_pause()
	end),
	awful.key({}, "XF86AudioNext", function()
		mpris.next()
	end),
	awful.key({}, "XF86AudioPrev", function()
		mpris.prev()
	end),
	awful.key({}, "XF86AudioStop", function()
		mpris:shift(1)
	end),

	-- backlight
	awful.key({}, "XF86MonBrightnessDown", function()
		backlight.brightness = math.max(backlight.brightness - user.brightness_adjust, 0)
		s().osd:emit_signal("show", "backlight")
	end),
	awful.key({}, "XF86MonBrightnessUp", function()
		backlight.brightness = math.min(backlight.brightness + user.brightness_adjust, 100)
		s().osd:emit_signal("show", "backlight")
	end),

	-- layout
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width", group = "layout" }),

	awful.key({ modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	-- client
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous", group = "client" }),

	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous", group = "client" }),

	-- components
	awful.key({ modkey }, "o", function()
		local c = s().control_center
		c.visible = not c.visible
	end, { description = "execute", group = "launcher" }),

	awful.key({ modkey }, "e", function()
		s().execute:emit_signal("command")
	end, { description = "execute", group = "launcher" }),

	awful.key({ modkey }, "x", function()
		s().execute:emit_signal("lua")
	end, { description = "run lua", group = "awesome" }),

	awful.key({ modkey }, "Return", function()
		awful.spawn(assert(apps.entries[user.terminal], ("app id %s does not exist"):format(user.terminal)).launch())
	end, { description = "open terminal", group = "launcher" }),

	awful.key({ modkey }, "r", function()
		local l = s().launcher
		l.visible = not l.visible
	end, { description = "show launcher", group = "launcher" }),
})

-- tags
local function tag_code(name)
	local number = tonumber(name, 10)
	if number ~= nil then
		return "#" .. number + 9
	end

	return name:lower()
end

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { modkey },
		keygroup = "numrow",
		description = "view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, "Control" },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, "Shift" },
		keygroup = "numrow",
		description = "move client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { modkey, "Control", "Shift" },
		keygroup = "numrow",
		description = "toggle client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
})

for i, name in ipairs(user.tags) do
	local code = tag_code(name)

	awful.keyboard.append_global_keybindings({
		awful.key({ modkey }, code, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view #" .. name, group = "tag" }),

		awful.key({ modkey, "Control" }, code, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle #" .. name, group = "tag" }),

		awful.key({ modkey, "Shift" }, code, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move client to #" .. name, group = "tag" }),

		awful.key({ modkey, "Control", "Shift" }, code, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle client on tag #" .. name, group = "tag" }),
	})
end

-- client
function M.clientkeys()
	awful.keyboard.append_client_keybindings({
		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close", group = "client" }),

		awful.key({ modkey, "Shift" }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, { description = "move to master", group = "layout" }),

		awful.key({ modkey }, "t", function(c)
			awful.titlebar.toggle(c, user.titlebar_position)
		end, { description = "toggle titlebar", group = "client" }),
	})
end

function M.clientbuttons()
	awful.mouse.append_client_mousebindings({
		awful.button({ modkey }, 1, function(c)
			c:activate({ context = "mouse_click", action = "mouse_move" })
		end),
		awful.button({ modkey }, 3, function(c)
			c:activate({ context = "mouse_click", action = "mouse_resize" })
		end),
	})
end

return M
