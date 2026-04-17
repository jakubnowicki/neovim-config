return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "r",
        "python",
        "javascript",
        "css",
        "scss",
        "sql",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
      },
      auto_install = false,
      highlight = {
        enable = true,
      },
      indent = {
        enable = false,
      },
    })
  end,
}
