-- Project-local config, auto-loaded by Neovim when `:set exrc` is enabled.
-- Run `:trust` (or `vim.secure.trust`) the first time to allow this file.

-- Hot-reload claudehalp lua modules + re-source plugin command file.
vim.keymap.set("n", "<leader>rr", function()
	local reloaded = {}
	for name, _ in pairs(package.loaded) do
		if name == "claudehalp" or name:match("^claudehalp%.") then
			package.loaded[name] = nil
			table.insert(reloaded, name)
		end
	end

	-- Re-require to pick up new code immediately.
	local ok, mod = pcall(require, "claudehalp")
	if not ok then
		vim.notify("[claudehalp] reload failed: " .. tostring(mod), vim.log.levels.ERROR)
		return
	end

	-- Re-apply project debug config.
	if mod.setup then
		mod.setup({ debug = true })
	end

	-- Re-source the plugin/ file so :ClaudeHalp / :CH are redefined.
	local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
	local plugin_file = root .. "/plugin/claudehalp.lua"
	if vim.fn.filereadable(plugin_file) == 1 then
		vim.cmd("source " .. vim.fn.fnameescape(plugin_file))
	end

	vim.notify("[claudehalp] reloaded (" .. #reloaded .. " modules)", vim.log.levels.INFO)
end, { desc = "Reload claudehalp plugin" })
