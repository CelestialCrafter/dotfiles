local utils = require("utils")

return {
	"lewis6991/gitsigns.nvim",
	{
		"3rd/image.nvim",
		build = false,
		opts = {
			backend = "ueberzug",
			processor = "magick_cli",
			max_height_window_percentage = 100,
			window_overlap_clear_enabled = true,
			integrations = {
				neorg = { enabled = false },
				typst = { enabled = false },
			},
		},
	},
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				relative = "win",
				mappings = { i = { ["<Esc>"] = "Close" } },
			},
			select = { backend = { "telescope" } },
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			progress = { suppress_on_insert = true },
			notification = { override_vim_notify = true },
		},
	},
	{
		"mbbill/undotree",
		keys = {
			{
				"<leader>u",
				vim.cmd.UndotreeToggle,
				mode = utils.default_mode,
			},
		},
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		opts = {
			delay = 50,
			should_enable = function(bufnr)
				return not utils.large_file(bufnr, 500)
			end,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
	},
}
