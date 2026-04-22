return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup()
    require("config.diffview_keymaps").setup()
  end,
}
