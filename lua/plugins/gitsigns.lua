return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      current_line_blame_opts = {
        delay = 200,
        virt_text_pos = "right_align",
      },
      on_attach = function(bufnr)
        require("config.gitsigns_keymaps").attach(bufnr)
      end,
    })
  end,
}
