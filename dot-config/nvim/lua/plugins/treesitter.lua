local utils = require("utils")

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"c",
			"lua",
			"javascript",
			"html",
			"rust",
			"go",
			"scss",
			"css",
			"markdown",
			"nix",
			"gleam",
			"zig"
		},
		highlight = {
			enable = true,
			disable = function(_, bufnr)
				return utils.large_file(bufnr, 500)
			end,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = false,
				node_incremental = "<CR>",
				node_decremental = "<S-CR>",
			},
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
