local M = {}

function M.setup()
  local map = vim.keymap.set

  map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git diff view" })
  map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Close diff view" })

  map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", { desc = "Git file history" })
  map("v", "<leader>gh", ":DiffviewFileHistory<cr>", { desc = "Git selection history" })

  map("n", "<leader>gH", "<cmd>DiffviewFileHistory<cr>", { desc = "Git project history" })
end

return M
