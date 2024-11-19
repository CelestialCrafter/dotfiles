local awful = require("awful")
local gears = require("gears")
local menubar = require("menubar")
local popup = require("awful.hotkeys_popup")
local misc = require("misc")

local modkey = "Mod4"

local globalkeys = gears.table.join(
	-- awesome
	awful.key({ "Mod1", "Control" }, "r", awesome.restart, { description = "reload", group = "awesome" }),
	awful.key({ "Mod1", "Control" }, "q", awesome.quit, { description = "quit", group = "awesome" }),

	awful.key({ modkey, "Shift" }, "/", popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "run lua", group = "awesome" }),

	awful.key({}, "Print", function()
		awful.spawn.with_shell("maim -u -s | xclip -selection clipboard -t image/png")
	end, { description = "screenshot", group = "awesome" }),

	-- layout
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width", group = "layout" }),

	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase master clients", group = "layout" }),

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

	-- launcher
	awful.key({ modkey }, "r", function()
		awful.screen.focused().prompt:run()
	end, { description = "run prompt", group = "launcher" }),
	awful.key({ modkey }, "Return", function()
		awful.spawn(misc.terminal)
	end, { description = "open terminal", group = "launcher" }),
	awful.key({ modkey }, "p", menubar.show, { description = "show menubar", group = "launcher" })
)

-- tags
globalkeys = gears.table.join(
	globalkeys,
	awful.key({ modkey }, "0", awful.tag.history.restore, { description = "previous tag", group = "tag" })
)

local function tag_code(name)
	local number = tonumber(name, 10)
	if number ~= nil then
		return "#" .. number + 9
	end

	return name:lower()
end

for i, name in ipairs(misc.tags) do
	local code = tag_code(name)

	globalkeys = gears.table.join(
		globalkeys,
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
		end, { description = "toggle client on tag #" .. name, group = "tag" })
	)
end

local clientkeys = gears.table.join(
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),

	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "layout" }),

	awful.key(
		{ modkey, "Mod1" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),

	awful.key({ modkey, "Mod1" }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),

	awful.key({ modkey, "Mod1" }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),

	awful.key({ modkey, "Mod1" }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "toggle maximized", group = "client" })
)

local clientbuttons = gears.table.join(
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

root.keys(globalkeys)

return {
	clientbuttons = clientbuttons,
	clientkeys = clientkeys
}
