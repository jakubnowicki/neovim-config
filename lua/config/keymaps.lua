local map = vim.keymap.set
local terminal = require("config.terminal")

-- leader key
vim.g.mapleader = " "

-- quick save
map("n", "<leader>w", "<cmd>w<cr>")

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- close current window
map("n", "<leader>q", "<cmd>close<cr>")

-- toggle terminal
map("n", "<leader>tt", terminal.toggle)
