-- create a group for our custom autocmds
local augroup = vim.api.nvim_create_augroup("jakub_config", { clear = true })

-- enter insert mode automatically when opening a terminal
vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = "*",
  command = "startinsert",
})
