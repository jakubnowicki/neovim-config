local M = {}

function M.attach(bufnr)
  local map = vim.keymap.set
  local hover = require("config.lsp_hover")

  map("n", "K", hover.small, { buffer = bufnr, desc = "Hover" })
  map("n", "<leader>ld", hover.full, { buffer = bufnr, desc = "Full documentation" })
  map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
  map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
  map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  map("n", "<leader>lh", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature help" })
end

return M
