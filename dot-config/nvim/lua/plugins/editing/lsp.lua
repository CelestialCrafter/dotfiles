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
	},
	config = function(_, opts)
		local lspconfig = require("lspconfig")
		for _, lsp in ipairs(opts) do
			lspconfig[lsp].setup({})
		end
	end,
}
