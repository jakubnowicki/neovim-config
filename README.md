# Neovim Config

A lightweight, portable Neovim configuration built step by step for real work in
client environments.

This setup is intentionally a **work in progress**. The goal is not to become a
full IDE or a polished distribution. The goal is to keep a configuration that is
small enough to understand, easy to debug, and useful in restricted terminals.

## Principles

- Terminal-first workflow for R/Shiny, git, tests, shell tools, and Claude Code.
- No dependency on Nerd Fonts or GUI-only features.
- Minimal plugins, added only when they solve a clear problem.
- Modular Lua structure with each part easy to disable or replace.
- Stable plugin versions through `lazy-lock.json`.
- One change at a time, so the git history stays useful as documentation.

## Structure

```text
.
├── init.lua
├── lazy-lock.json
├── project.md
├── lua
│   ├── config
│   │   ├── autocmds.lua
│   │   ├── format.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── lsp_hover.lua
│   │   ├── lsp_keymaps.lua
│   │   ├── options.lua
│   │   └── terminal.lua
│   └── plugins
│       ├── colorscheme.lua
│       ├── init.lua
│       ├── lsp.lua
│       ├── statusline.lua
│       ├── treesitter.lua
│       └── which-key.lua
└── README.md
```

## Module Overview

- `init.lua` loads the core config first, then bootstraps plugins.
- `lua/config/options.lua` contains editor defaults.
- `lua/config/keymaps.lua` contains global keymaps.
- `lua/config/autocmds.lua` contains small automatic behaviors.
- `lua/config/terminal.lua` contains the reusable bottom terminal.
- `lua/config/lazy.lua` bootstraps and configures `lazy.nvim`.
- `lua/config/format.lua` centralizes formatting behavior.
- `lua/config/lsp_keymaps.lua` defines buffer-local LSP mappings.
- `lua/config/lsp_hover.lua` provides compact and full hover popups.
- `lua/plugins/*.lua` contains plugin specs loaded by `lazy.nvim`.

## Keymaps

Leader is `<Space>`.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Close current window |
| `<leader>tt` | Normal | Toggle bottom terminal |
| `<leader>bf` | Normal | Format current buffer |
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to lower window |
| `<C-k>` | Normal | Move to upper window |
| `<C-l>` | Normal | Move to right window |
| `<Esc>` | Terminal | Leave terminal mode |

LSP mappings are attached only when an LSP client is active:

| Key | Mode | Action |
| --- | --- | --- |
| `K` | Normal | Compact hover |
| `<leader>ld` | Normal | Full documentation hover |
| `gd` | Normal | Go to definition |
| `gr` | Normal | References |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>lh` | Normal | Signature help |

## R Setup Notes

The current language setup is deliberately R-first.

Expected external tools:

- R
- R package `languageserver`
- `air` available on `PATH`

Formatting is handled only by `air`. The R language server is used for editor
features and has document formatting disabled to avoid conflicts.

To disable automatic formatting for a project, create this file in the project
root:

```text
.disable_autoformat
```

Manual formatting through `<leader>bf` still uses the configured `air` LSP
client.

## Roadmap

The broader plan lives in `project.md`. The next likely steps are:

1. Keep tightening the current R workflow.
2. Add completion with `blink.cmp`.
3. Add focused navigation/search tooling.
4. Add formatting support for one more language at a time.
5. Add AI tools only after the core editing workflow is solid.

## What This Config Avoids

- Ready-made Neovim distributions.
- Nerd Font assumptions.
- Plugin-heavy setup before the workflow needs it.
- Fancy UI at the cost of portability.
- Hiding complexity behind tools that are not understood yet.

## Guiding Rule

Build a tool for client work, not a pretty config.

It should always be possible to open the config, understand what is happening,
disable a piece, and keep working.
