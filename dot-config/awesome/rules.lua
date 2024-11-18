local awful = require("awful")
local beautiful = require("beautiful")
local keybinds  = require("keybinds")

awful.rules.rules = {
	-- all clients match this
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = keybinds.clientkeys,
			buttons = keybinds.clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- titlebars for normal clients/dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },
}
