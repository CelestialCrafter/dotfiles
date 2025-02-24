local utils = require("utils")

local function search_word(forward)
	return function()
		require("flash").jump({
			pattern = vim.fn.expand("<cword>"),
			mode = "search",
			search = { forward = forward },
			jump = { nohlsearch = false },
		})
	end
end

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {
		label = {
			rainbow = {
				enabled = true,
				shade = 2,
			},
		},
		modes = {
			search = { enabled = true },
			char = { enabled = false },
		},
	},
	keys = {
		{
			"*",
			search_word(true),
			mode = utils.default_mode,
		},
		{
			"#",
			search_word(false),
			mode = utils.default_mode,
		},
	},
}
