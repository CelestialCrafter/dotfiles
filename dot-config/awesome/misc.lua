local awful = require("awful")

local function setup()
	awful.spawn("picom")
end

return {
	setup = setup,
	tags = { "1", "2", "3", "4", "5", "6", "S" },
	titlebar_position = "left",
	bar_position = "top",
	visual_update_delay = 0.05
}
