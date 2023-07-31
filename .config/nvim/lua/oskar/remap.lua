vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move selection
vim.keymap.set("n", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("n", "<A-k>", ":m '<-2<CR>gv=gv")

-- Half-page scroll, centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Search terms centered
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Pase over selection without overwriting buffer
vim.keymap.set("x", "<leader>p", "\"_dP")

-- Yank to system clipboard (Not WSL?)
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- Remap Ctrl-C to ESC
-- https://unix.stackexchange.com/questions/53633/does-using-ctrlc-instead-of-esc-to-exit-insert-mode-break-anything-in-vi
vim.keymap.set("i", "<C-c>", "<Esc>")

