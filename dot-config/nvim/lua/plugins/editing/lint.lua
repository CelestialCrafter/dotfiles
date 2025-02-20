return {
	"mfussenegger/nvim-lint",
	opts = {
		by_ft = {
			javascript = { "eslint_d" },
			go = { "golangcilint" },
			lua = { "luacheck" },
			markdown = { "vale" },
			python = { "ruff" },
			c = { "cpplint" },
		},
	},
	config = function(_, opts)
		local lint = require("lint")

		lint.linters_by_ft = opts.linters_by_ft or {}
		for name, linter_opts in pairs(opts.linter_opts or {}) do
			lint.linters[name] = linter_opts
		end

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
