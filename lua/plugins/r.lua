return {
  "R-nvim/R.nvim",
  lazy = false,
  config = function()
    local r_console = require("config.r_console").get()

    local opts = {
      R_app = r_console,
      R_cmd = "R",
      R_args = { "--quiet", "--no-save" },
      min_editor_width = 72,
      rconsole_width = 80,
    }

    require("r").setup(opts)
  end,
}
