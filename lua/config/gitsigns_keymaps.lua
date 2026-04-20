local M = {}

function M.attach(bufnr)
  local map = vim.keymap.set
  local gs = require("gitsigns")

  local opts = { buffer = bufnr }

  map("n", "]c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "]c", bang = true })
    else
      gs.nav_hunk("next")
    end
  end, opts)

  map("n", "[c", function()
    if vim.wo.diff then
      vim.cmd.normal({ "[c", bang = true })
    else
      gs.nav_hunk("prev")
    end
  end, opts)

  map("n", "<leader>gp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
  map("n", "<leader>gs", gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
  map("n", "<leader>gr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
  map("n", "<leader>gS", gs.stage_buffer, { buffer = bufnr, desc = "Stage buffer" })
  map("n", "<leader>gR", gs.reset_buffer, { buffer = bufnr, desc = "Reset buffer" })
  map("n", "<leader>gb", gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
end

return M
