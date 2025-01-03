local naughty = require("naughty")

naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "error occured " .. (startup and "during startup" or ""),
		message = message,
	})
end)

require("connect").setup()
require("misc").setup()
require("config.theme")
require("config.layout")
require("config.keybinds")
require("config.screen")
require("config.client")
require("config.rules")
