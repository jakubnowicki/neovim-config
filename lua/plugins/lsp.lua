return {
  "neovim/nvim-lspconfig",
  config = function()
    local fmt = require("config.format")

    vim.lsp.config("air", {
      cmd = { "air", "language-server" },
      filetypes = { "r" },
      root_markers = { ".git" },

      on_attach = function(client, bufnr)
        if client.name == "air" then
          local group = vim.api.nvim_create_augroup(
            "jakub_air_format_" .. bufnr,
            { clear = true }
          )

          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
              if fmt.autoformat_enabled() then
                fmt.format(bufnr)
              end
            end,
          })
        end
      end,
    })

    vim.lsp.enable("air")
  end,
}
