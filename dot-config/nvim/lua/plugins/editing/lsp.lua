return {
	"neovim/nvim-lspconfig",
	opts = {
		"lua_ls",
		"rust_analyzer",
		"gopls",
		"ts_ls",
		"ruff",
		"marksman",
		"cssls",
		"html",
		"nil_ls",
		"gleam",
	},
	config = function(_, opts)
		vim.lsp.enable(opts)
	end,
}
