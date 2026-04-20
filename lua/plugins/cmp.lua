return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local cmp_keymaps = require("config.cmp_keymaps")

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },

        mapping = cmp_keymaps.get(cmp),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
