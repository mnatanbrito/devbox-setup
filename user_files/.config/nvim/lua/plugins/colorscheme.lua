return {
	-- add dracula
	{ "Mofiqul/dracula.nvim" },

	-- add catppuccin
	{ "catppuccin/nvim", name = "catppuccin" },

	-- rose pine
	{ "rose-pine/neovim", name = "rose-pine" },

	-- Configure LazyVim to load rose pine dawn
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "rose-pine-dawn",
		},
	},
}
