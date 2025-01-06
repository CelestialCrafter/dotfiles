local hilbish = require("hilbish")
local commander = require("commander")
local bait = require("bait")
local fs = require("fs")

commander.register("z", function(args, sinks)
	local code, stdout, stderr = hilbish.run("zoxide query " .. table.concat(args, " "), false)
	if stderr ~= "" or code ~= 0 then
		return sinks.err:write(stderr)
	end

	fs.cd(stdout)
end)

bait.catch("command.exit", function(_, cmd)
	if cmd ~= nil and cmd:gmatch("%w+")() == "cd" then
		hilbish.run("zoxide add " .. hilbish.cwd(), false)
	end
end)
