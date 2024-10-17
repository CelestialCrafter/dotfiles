local naughty = require("naughty")

function notify_error(error)
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "startup error",
		text = error,
	})
end

-- notify if startup error
if awesome.startup_errors then
	notify_error(awesome.startup_errors)
end

-- handle runtime errors after startup
-- no clue why there are inneffectual assignments
-- they were in the default rc.lua so....
-- might aswell have them in, seems important
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true

		notify_error(tostring(err))
		in_error = false
	end)
end
