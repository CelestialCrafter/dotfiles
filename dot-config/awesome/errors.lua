local naughty = require("naughty")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "error occured "..(startup and "during startup" or ""),
        message = message
    }
end)
