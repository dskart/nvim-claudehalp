vim.api.nvim_create_user_command("ClaudeHalp", function(opts)
	local ok, ch = pcall(require, "claudehalp")
	if not ok then
		vim.notify("claudehalp not loaded: " .. tostring(ch), vim.log.levels.ERROR)
		return
	end

	if ch.config and ch.config.debug then
		vim.notify("[claudehalp] :ClaudeHalp invoked, args=" .. vim.inspect(opts.args), vim.log.levels.INFO)
	end

	if opts.args == nil or vim.trim(opts.args) == "" then
		vim.notify("[claudehalp] usage: :ClaudeHalp <your question>", vim.log.levels.WARN)
		return
	end

	ch.halp(opts.args, function(resp, err)
		if err then
			vim.notify("claude error: " .. err, vim.log.levels.ERROR)
			return
		end
		-- Print to message area so it stays visible and ends up in :messages.
		vim.api.nvim_echo({ { "Claude: ", "Title" }, { resp } }, true, {})
	end)
end, {
	desc = "Ask Claude for a Neovim command or keymap",
	nargs = "*",
})

vim.cmd("command! -nargs=* CH ClaudeHalp <args>")
