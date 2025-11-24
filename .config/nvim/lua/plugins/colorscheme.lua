return {
	-- add dracula
	{ "Mofiqul/dracula.nvim" },

	-- add catppuccin
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },

	-- Configure LazyVim to load catppuccin
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-frappe",
		},
	},
}
