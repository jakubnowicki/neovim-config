local opt = vim.opt

-- line numbers
opt.number = true
opt.relativenumber = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- better UI defaults
opt.termguicolors = true
opt.cursorline = true

-- splits
opt.splitright = true
opt.splitbelow = true

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})
