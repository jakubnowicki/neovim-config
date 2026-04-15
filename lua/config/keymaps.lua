local map = vim.keymap.set

-- leader key
vim.g.mapleader = " "

-- quick save
map("n", "<leader>w", "<cmd>w<cr>")

-- exit terminal mode
map("t", "<Esc>", "<C-\\><C-n>")
