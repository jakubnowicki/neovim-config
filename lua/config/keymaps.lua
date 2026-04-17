local map = vim.keymap.set
local terminal = require("config.terminal")
local fmt = require("config.format")

-- leader key
vim.g.mapleader = " "

-- quick save
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- close current window
map("n", "<leader>q", "<cmd>close<cr>", { desc = "Close window" })

-- toggle terminal
map("n", "<leader>tt", terminal.toggle, { desc = "Toggle terminal" })

-- format buffer
map("n", "<leader>bf", function()
  fmt.format(0)
end, { desc = "Format buffer" })
