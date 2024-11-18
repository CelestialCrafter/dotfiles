local hilbish = require("hilbish")
local lunacolors = require("lunacolors")
local bait = require("bait")

local function prompt(fail)
	hilbish.prompt(lunacolors.format(
		(fail and "{green}" or "{red}") .. "%u {yellow}%d "
	))
end

prompt()
bait.catch("command.exit", function(code)
	prompt(code ~= 0)
end)
