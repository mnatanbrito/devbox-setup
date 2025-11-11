-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- additional keymaps

-- open explorer on command+b
vim.keymap.set("n", "<C-b>", function()
	Snacks.explorer.open()
end, { desc = "Toggle Explorer" })
