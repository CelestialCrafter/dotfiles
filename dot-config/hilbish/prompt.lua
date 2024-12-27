local hilbish = require("hilbish")
local bait = require("bait")

-- lunacolors is stupid and doesnt do what i need..
local primary = "\27[38;5;229m"
local secondary = "\27[38;5;230m"
local accent = "\27[38;5;231m"
local reset = "\27[0m"

local function prompt(fail)
	local fail_color = (fail and secondary or primary)
	hilbish.prompt(("%s%%u %s%%d %s"):format(fail_color, accent, reset))
end

prompt()
bait.catch("command.exit", function(code)
	prompt(code ~= 0)
end)
