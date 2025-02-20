local utils = require("utils")

return {
	-- @FIX bwaa
	-- @TODO bwaa
	-- @HACK bwaa
	-- @WARN bwaa
	-- @PERF bwaa
	-- @NOTE bwaa
	-- @TEST bwaa

	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false,
	keys = {
		{
			"<leader>ft",
			vim.cmd.TodoTelescope,
			mode = utils.default_mode,
		},
	},
	opts = {
		search = { pattern = [[\b(KEYWORDS)(:| )]] },
		highlight = {
			multiline = false,
			pattern = [[.*<(KEYWORDS)\s*]],
			keyword = "fg",
			before = "fg",
		},
	},
}
