return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd("colorscheme nightfox")

    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
      fg = "#7f8c98",
      italic = true,
    })
  end,
}
