return {
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope_keymaps = require("config.telescope_keymaps")

      require("telescope").setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
          },
          sorting_strategy = "ascending",
          mappings = telescope_keymaps.mappings,
        },
      })

      telescope_keymaps.setup()
    end,
  },
}
