local map = vim.keymap.set
local terminal = require("config.terminal")
local fmt = require("config.format")
local ai = require("config.ai")

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
map("n", "<leader>tf", terminal.focus_or_open, { desc = "Focus or open terminal" })

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

-- AI tools
map("n", "<leader>ac", function()
  ai.toggle("claude")
end, { desc = "Toggle Claude Code" })
map("n", "<leader>ax", function()
  ai.toggle("codex")
end, { desc = "Toggle Codex" })
map("n", "<leader>ao", function()
  ai.toggle("opencode")
end, { desc = "Toggle OpenCode" })
map("n", "<leader>ag", function()
  ai.toggle("gemini")
end, { desc = "Toggle Gemini" })
map("n", "<leader>ap", function()
  ai.toggle("copilot")
end, { desc = "Toggle GitHub Copilot" })
map("n", "<leader>as", ai.send_current_file, { desc = "Send current file to active AI tool" })
map("v", "<leader>as", function()
  ai.send_selection()
end, { desc = "Send selection to active AI tool" })

local function get_visual_selection()
  local save_reg = vim.fn.getreg('z')
  local save_type = vim.fn.getregtype('z')
  vim.cmd('noautocmd silent normal! "zy')
  local text = vim.fn.getreg('z')
  vim.fn.setreg('z', save_reg, save_type)
  return text
end

local function escape_search(text)
  return vim.fn.escape(text, '/\\'):gsub('\n', '\\n')
end

local function substitute_in_file(replacement)
  local pattern = escape_search(get_visual_selection())
  local repl = vim.fn.escape(replacement, '/\\&')
  local pos = vim.fn.getpos('.')
  vim.cmd('keepjumps normal! gg')
  vim.cmd(string.format([[%%s/\V%s/%s/gc]], pattern, repl))
  vim.fn.setpos('.', pos)
end

-- 1) Delete occurrences of the selection, confirming each
vim.keymap.set('x', '<leader>d', function()
  substitute_in_file('')
end, { desc = 'Delete occurrences of selection (confirm each)' })

-- 2) Replace occurrences of the selection, confirming each
vim.keymap.set('x', '<leader>r', function()
  local replacement = vim.fn.input('Replace with: ')
  substitute_in_file(replacement)
end, { desc = 'Replace occurrences of selection (confirm each)' })
