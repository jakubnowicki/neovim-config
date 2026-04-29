local M = {}

function M.setup()
  local map = vim.keymap.set
  local r_console = require("config.r_console")

  map("n", "<leader>rr", r_console.toggle, { desc = "Toggle R console" })

  map("n", "<leader>rl", "<Plug>RSendLine", { desc = "Send line to R" })
  map("v", "<leader>rs", "<Plug>RSendSelection", { desc = "Send selection to R" })

  map("n", "<leader>rf", "<Plug>RSendFile", { desc = "Send file to R" })
  map("n", "<leader>rb", "<Plug>RSendCurrentFun", { desc = "Send current function to R" })
end

return M
