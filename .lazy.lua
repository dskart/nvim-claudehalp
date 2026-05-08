-- Project-local lazy.nvim spec override.
-- Loads nvim-claudehalp from this directory instead of the GitHub release.
-- Auto-detected by lazy.nvim when Neovim starts in this project.
return {
	{
		"dskart/nvim-claudehalp",
		dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h"),
		dev = true,
		lazy = false,
		config = function()
			require("claudehalp").setup({ debug = true })
		end,
	},
}
