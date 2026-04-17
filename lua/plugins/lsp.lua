return {
  "neovim/nvim-lspconfig",
  config = function()
    local fmt = require("config.format")
    local lsp_keymaps = require("config.lsp_keymaps")

    -- Air: formatting only
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

    -- R languageserver: IDE features only
    vim.lsp.config("r_language_server", {
      cmd = { "R", "--slave", "-e", "languageserver::run()" },
      filetypes = { "r", "rmd", "quarto" },
      root_markers = { ".git" },
      on_attach = function(client, bufnr)
        -- keep formatting exclusively on Air
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        lsp_keymaps.attach(bufnr)
      end,
    })

    vim.lsp.enable("air")
    vim.lsp.enable("r_language_server")
  end,
}
