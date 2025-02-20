local function eval_python(content)
	local lines = {}
	local whitelisted = { "python", "lua", "node" }
	local program = whitelisted[1]

	for i, line in ipairs(content.lines) do
		line = line:match("^%s*(.*)")

		if i ~= 1 then
			lines[i - 1] = line
			goto continue
		end

		for _, p in ipairs(whitelisted) do
			if line == p then
				program = p
			end
		end

		::continue::
	end

	local command = vim.system({ program }, {
		stdin = table.concat(lines, "\n"),
		text = true,
	}):wait()

	local split = vim.split(command.stdout, "\n", { trimempty = true })
	if #split == 0 then
		split[1] = "no output"
	end

	return split
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
