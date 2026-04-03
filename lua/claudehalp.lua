local M = {}

---@param prompt string
---@param callback fun(resp: string|nil, err: string|nil)
function M.halp(prompt, callback)
	local keymaps = {}
	for _, mode in ipairs({ "n", "i", "v", "x" }) do
		for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
			table.insert(keymaps, string.format("[%s] %s -> %s", mode, map.lhs, map.rhs or "<lua>"))
		end
	end

	local plugins = {}
	local ok, lazy = pcall(require, "lazy")
	if ok then
		for _, plugin in pairs(lazy.plugins()) do
			table.insert(plugins, plugin.name)
		end
	end

	local settings = {
		filetype = vim.bo.filetype,
		number = vim.wo.number,
	}

	local full_prompt = table.concat({
		"You are a Neovim expert. The user wants to know what Neovim command or keymap to use.",
		"Reply with ONLY the command or key sequence, nothing else. No explanation.",
		"If you can't find a command or key sequence, reply with 'Not possible :('",
		"",
		"== USER PROMPT ==",
		prompt,
		"",
		"== KEYMAPS ==",
		table.concat(keymaps, "\n"),
		"",
		"== PLUGINS ==",
		table.concat(plugins, ", "),
		"",
		"== SETTINGS ==",
		vim.inspect(settings),
	}, "\n")

	vim.system({ "claude", "-p", full_prompt, "--no-session-persistence" }, { text = true }, function(result)
		vim.schedule(function()
			if result.code ~= 0 then
				callback(nil, result.stderr or "unknown error")
				return
			end
			local resp = vim.trim(result.stdout)
			if resp == "" then
				callback(nil, "no resp from claude")
				return
			end
			callback(resp, nil)
		end)
	end)
end

return M
