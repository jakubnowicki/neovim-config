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

opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
