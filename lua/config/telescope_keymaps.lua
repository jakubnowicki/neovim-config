local M = {}

M.mappings = {
  i = {
    ["<C-j>"] = require("telescope.actions").move_selection_next,
    ["<C-k>"] = require("telescope.actions").move_selection_previous,
  },
}

function M.setup()
  local map = vim.keymap.set
  local builtin = require("telescope.builtin")

  map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
  map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
end

return M
