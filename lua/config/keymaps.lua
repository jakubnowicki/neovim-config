local map = vim.keymap.set
local terminal = require("config.terminal")
local fmt = require("config.format")
local claude = require("config.claude")

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

-- split management
map("n", "<leader>sv", "<cmd>vsplit<cr>", { desc = "Vertical split" })
map("n", "<leader>sh", "<cmd>split<cr>", { desc = "Horizontal split" })

map("n", "<leader><leader>", "<C-^>", { desc = "Alternate buffer" })

-- resize splits
map("n", "<leader>=", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })

-- buffer navigation
map("n", "<leader>bp", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<leader>bn", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- toggle Claude Code
map("n", "<leader>ac", claude.toggle, { desc = "Toggle Claude Code" })
map("n", "<leader>as", claude.send_current_file, { desc = "Send current file to Claude" })
map("v", "<leader>as", function()
  claude.send_selection()
end, { desc = "Send selection to Claude" })
