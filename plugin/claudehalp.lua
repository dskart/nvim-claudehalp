vim.api.nvim_create_user_command("ClaudeHalp", function(opts)
	require("claudehalp").halp(opts.args, function(resp, err)
		if err then
			print("claude error: " .. err)
			return
		end
		print("Claude: " .. resp)
	end)
end, {
	desc = "Ask Claude for a Neovim command or keymap",
	nargs = "*",
})

vim.cmd("command! -nargs=* CH ClaudeHalp")
