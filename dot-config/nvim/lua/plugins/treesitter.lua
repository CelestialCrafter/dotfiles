local utils = require("utils")

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	"RRethy/nvim-treesitter-textsubjects",
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
				"markdown",
			},
			highlight = {
				enable = true,
				disable = function(_, bufnr)
					return utils.large_file(bufnr, 500)
				end,
			},
			textsubjects = {
				enable = true,
				prev_selection = "<S-cr>",
				keymaps = { ["<cr>"] = "textsubjects-smart" },
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
						["iP"] = "@parameter.inner",
						["aP"] = "@parameter.outer",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
