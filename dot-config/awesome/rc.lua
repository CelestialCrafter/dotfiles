pcall(require, "luarocks.loader")

local naughty = require("naughty")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "error occured " .. (startup and "during startup" or ""),
		message = message,
	})
end)

require("misc").setup()
require("system")
require("config.theme")
require("config.layout")
require("config.rules")
require("config.keybinds")
require("config.screen")
require("config.client")
