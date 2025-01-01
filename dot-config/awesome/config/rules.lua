local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")

local notification_template = require("components.widgets.notification")

ruled.client.connect_signal("request::rules", function()
	ruled.client.append_rules({
		{
			id = "global",
			rule = {},
			properties = {
				focus = awful.client.focus.filter,
				raise = true,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			},
		},
		{
			id = "titlebars",
			rule_any = { type = { "normal", "dialog" } },
			properties = { titlebars_enabled = true },
		},
	})
end)

ruled.notification.connect_signal("request::rules", function()
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end)

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n, widget_template = notification_template.naughty })
end)
