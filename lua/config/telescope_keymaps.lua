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

  map("n", "<leader>ff", function()
    builtin.find_files({
      hidden = true,
      no_ignore = false,
      file_ignore_patterns = {
        "^%.git/",
        "^node_modules/",
        "^renv/",
        "^%.cache/",
        "^dist/",
        "^build/",
        "^target/",
        "^coverage/",
      },
    })
  end, { desc = "Find files" })

  map("n", "<leader>fg", function()
    builtin.live_grep({
      additional_args = function()
        return { "--hidden" }
      end,
      glob_pattern = {
        "!**/.git/*",
        "!**/node_modules/*",
        "!**/renv/*",
        "!**/.cache/*",
        "!**/dist/*",
        "!**/build/*",
        "!**/target/*",
        "!**/coverage/*",
      },
    })
  end, { desc = "Live grep" })

  map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
  map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
  map("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Document symbols" })

  map("n", "<leader>fF", function()
    builtin.find_files({
      hidden = true,
      no_ignore = true,
    })
  end, { desc = "Find ALL files" })

  map("n", "<leader>fG", function()
    builtin.live_grep({
      additional_args = function()
        return { "--hidden", "--no-ignore" }
      end,
    })
  end, { desc = "Grep ALL" })

  map("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
  map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
  map("n", "<leader>gC", builtin.git_bcommits, { desc = "Buffer commits" })
  map("n", "<leader>gB", builtin.git_branches, { desc = "Git branches" })
  map("n", "<leader>gt", builtin.git_status, { desc = "Git status" })
end

return M
