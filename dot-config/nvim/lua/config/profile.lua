local utils = require("utils")

utils.bootstrap(vim.fn.stdpath("data") .. "/profile.nvim", "https://github.com/stevearc/profile.nvim", "master")

local ok, prof = pcall(require, "profile")
if ok then
	local should_profile = os.getenv("NVIM_PROFILE")
	if should_profile then
		prof.instrument_autocmds()
		if should_profile:lower():match("^start") then
			prof.start("*")
		else
			prof.instrument("*")
		end
	end

	local function toggle()
		if prof.is_recording() then
			prof.stop()
			vim.ui.input({ prompt = "save to:", completion = "file", default = "profile.json" }, function(filename)
				if filename then
					prof.export(filename)
					vim.notify(string.format("wrote %s", filename))
				end
			end)
		else
			prof.start("*")
		end
	end

	vim.keymap.set("", "<f1>", toggle)
end
