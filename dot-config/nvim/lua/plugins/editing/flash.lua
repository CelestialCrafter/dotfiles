local utils = require("utils")

local function search_word(forward)
	require("flash").jump({
		pattern = vim.fn.expand("<cword>"),
		mode = "search",
		search = { forward = forward },
		jump = { nohlsearch = false },
	})
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
			function()
				search_word(true)
			end,
			mode = utils.default_mode,
		},
		{
			"#",
			function()
				search_word(false)
			end,
			mode = utils.default_mode,
		},
	},
}
