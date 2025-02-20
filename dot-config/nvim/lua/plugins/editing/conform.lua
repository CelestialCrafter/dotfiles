return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
			rust = { "rustfmt" },
			javascript = { "prettierd" },
			go = { "goimports", "gofmt" },
			css = { "stylelint" },
			c = { "clang-format" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	},
}
