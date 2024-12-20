local function eval_python()
	local command = vim.system({ "python" }, {
		stdin = table.concat(content.lines, "\n"),
		text = true,
	}):wait()

	return vim.split(command.stdout, "\n", { trimempty = true })
end

return {
	"echasnovski/mini.operators",
	opts = {
		evaluate = { func = eval_python },
		exchange = { prefix = "" },
		multiply = { prefix = "" },
		replace = { prefix = "" },
		sort = { prefix = "" },
	},
}
