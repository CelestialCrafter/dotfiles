local utils = require("utils")

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
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
				"nix"
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
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					include_surrounding_whitespace = function(opts)
						return not opts.query_string:match("@%w+.inner")
					end,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ab"] = "@block.outer",
						["ib"] = "@block.inner",
						["aP"] = "@parameter.outer",
						["iP"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
