local map = vim.keymap.set

-- leader key
vim.g.mapleader = " "

-- quick save
map("n", "<leader>w", "<cmd>w<cr>")

-- exit terminal mode
map("t", "<Esc>", "<C-\\><C-n>")

-- open terminal (horizontal split)
map("n", "<leader>th", function()
  vim.cmd("split")
  vim.cmd("terminal")
end)

-- open terminal (vertical split)
map("n", "<leader>tv", function()
  vim.cmd("vsplit")
  vim.cmd("terminal")
end)

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")

-- close current window
map("n", "<leader>q", "<cmd>close<cr>")
