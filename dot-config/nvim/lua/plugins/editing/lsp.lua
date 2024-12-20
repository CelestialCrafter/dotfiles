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
		"jsonls",
	},
	config = function(_, opts)
		opts = opts or {}

		local lspconfig = require("lspconfig")
		for _, lsp in ipairs(opts) do
			lspconfig[lsp].setup({})
		end
	end,
}
