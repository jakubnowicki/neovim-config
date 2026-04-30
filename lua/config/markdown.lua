local group = vim.api.nvim_create_augroup("jakub_markdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "markdown", "rmd", "quarto" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.spell = true
    vim.opt_local.conceallevel = 2
  end,
})
