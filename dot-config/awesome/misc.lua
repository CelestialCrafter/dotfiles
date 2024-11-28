local awful = require("awful")

local function setup()
	awful.spawn("picom")
end

return {
	setup = setup,
	tags = { "1", "2", "3", "4", "5", "6", "S" },
	position = "left",
	expose_position = "bottom",
	visual_update_delay = 0.05
}
