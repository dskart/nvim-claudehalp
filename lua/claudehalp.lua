local M = {}

---@class ClaudeHalpConfig
---@field debug boolean? Enable debug logging
M.config = {
	debug = false,
}

---@param config ClaudeHalpConfig?
function M.setup(config)
	M.config = vim.tbl_deep_extend("force", M.config, config or {})
end

---@param msg string
---@param data any?
local function dbg(msg, data)
	if not M.config.debug then
		return
	end
	if data ~= nil then
		vim.notify("[claudehalp] " .. msg .. "\n" .. vim.inspect(data), vim.log.levels.INFO)
	else
		vim.notify("[claudehalp] " .. msg, vim.log.levels.INFO)
	end
end

---@param prompt string
---@param callback fun(resp: string|nil, err: string|nil)
function M.halp(prompt, callback)
	dbg("halp called with prompt", prompt)

	local keymaps = {}
	for _, mode in ipairs({ "n", "i", "v", "x" }) do
		for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
			table.insert(keymaps, string.format("[%s] %s -> %s", mode, map.lhs, map.rhs or "<lua>"))
		end
	end
	dbg("collected keymaps count", #keymaps)

	local plugins = {}
	local ok, lazy = pcall(require, "lazy")
	if ok then
		for _, plugin in pairs(lazy.plugins()) do
			table.insert(plugins, plugin.name)
		end
	end
	dbg("collected plugins count", #plugins)

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

	dbg("full prompt length", #full_prompt)
	dbg("full prompt", full_prompt)

	local cmd = { "claude", "-p", full_prompt, "--no-session-persistence" }
	dbg("running cmd", { "claude", "-p", "<prompt>", "--no-session-persistence" })

	vim.system(cmd, { text = true }, function(result)
		vim.schedule(function()
			dbg("claude exited", { code = result.code, signal = result.signal })
			dbg("claude stdout", result.stdout)
			dbg("claude stderr", result.stderr)

			if result.code ~= 0 then
				callback(nil, result.stderr or "unknown error")
				return
			end
			local resp = vim.trim(result.stdout or "")
			if resp == "" then
				callback(nil, "no resp from claude")
				return
			end
			callback(resp, nil)
		end)
	end)
end

return M
