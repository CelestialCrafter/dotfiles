local M = {
	default_mode = { "n", "x", "o" },
}

function M.get_root()
	local function exec(cmd)
		return vim.system(cmd, { text = true, stderr = false }):wait()
	end

	local function trim(str)
		return str:gsub("%s+", "")
	end

	for _, cmd in ipairs({
		{ "jj", "root" },
		{ "git", "rev-parse", "--show-toplevel" },
	}) do
		local cmd_obj = exec(cmd)
		if cmd_obj.code == 0 then
			return trim(cmd_obj.stdout), true
		end
	end

	return trim(vim.fn.getcwd()), false
end

function M.large_file(bufnr, kb_threshold)
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	return ok and stats and stats.size > kb_threshold * 1024
end

function M.bootstrap(path, repo, branch)
	if not vim.uv.fs_stat(path) then
		local command = vim.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--branch=" .. branch,
			repo,
			path,
		}, { text = true, stdout = false }):wait()

		if command.code ~= 0 then
			vim.notify(
				string.format("could not clone %s:\n%s", repo, command.stderr),
				"ErrorMsg",
				{ body = command.stdout }
			)
		end
	end

	vim.opt.rtp:prepend(path)
end

return M
