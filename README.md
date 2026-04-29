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
│   │   ├── claude.lua
│   │   ├── cmp_keymaps.lua
│   │   ├── diffview_keymaps.lua
│   │   ├── format.lua
│   │   ├── gitsigns_keymaps.lua
│   │   ├── keymaps.lua
│   │   ├── lazy.lua
│   │   ├── lsp_hover.lua
│   │   ├── lsp_keymaps.lua
│   │   ├── options.lua
│   │   ├── r_console.lua
│   │   ├── r_keymaps.lua
│   │   ├── telescope_keymaps.lua
│   │   └── terminal.lua
│   └── plugins
│       ├── cmp.lua
│       ├── colorscheme.lua
│       ├── diffview.lua
│       ├── gitsigns.lua
│       ├── init.lua
│       ├── lsp.lua
│       ├── r.lua
│       ├── statusline.lua
│       ├── telescope.lua
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
- `lua/config/claude.lua` contains the Claude Code terminal toggle.
- `lua/config/lazy.lua` bootstraps and configures `lazy.nvim`.
- `lua/config/format.lua` centralizes formatting behavior.
- `lua/config/lsp_keymaps.lua` defines buffer-local LSP mappings.
- `lua/config/lsp_hover.lua` provides compact and full hover popups.
- `lua/config/cmp_keymaps.lua` defines completion mappings.
- `lua/config/r_console.lua` chooses the R console executable.
- `lua/config/r_keymaps.lua` defines R.nvim mappings.
- `lua/config/telescope_keymaps.lua` defines Telescope mappings and picker
  defaults.
- `lua/config/gitsigns_keymaps.lua` defines buffer-local Git hunk mappings.
- `lua/config/diffview_keymaps.lua` defines Git diff and history mappings.
- `lua/plugins/*.lua` contains plugin specs loaded by `lazy.nvim`.

## Keymaps

Leader is `<Space>`.
Local leader is `\`.

Global mappings:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Close current window |
| `<leader>tt` | Normal | Toggle bottom terminal |
| `<leader>ac` | Normal | Toggle Claude Code terminal |
| `<leader>as` | Normal | Send current file path to Claude Code |
| `<leader>as` | Visual | Send selection to Claude Code |
| `<leader>d` | Visual | Delete occurrences of selection, confirming each |
| `<leader>r` | Visual | Replace occurrences of selection, confirming each |
| `<leader>bf` | Normal | Format current buffer |
| `<leader>sv` | Normal | Open vertical split |
| `<leader>sh` | Normal | Open horizontal split |
| `<leader>sx` | Normal | Close split |
| `<leader>=` | Normal | Equalize splits |
| `<leader><leader>` | Normal | Switch to alternate buffer |
| `<leader>bp` | Normal | Previous buffer |
| `<leader>bn` | Normal | Next buffer |
| `<leader>bd` | Normal | Delete buffer |
| `gt` | Normal | Next tab, built-in Vim mapping |
| `gT` | Normal | Previous tab, built-in Vim mapping |
| `{count}gt` | Normal | Go to tab number, built-in Vim mapping |
| `<C-h>` | Normal | Move to left window |
| `<C-j>` | Normal | Move to lower window |
| `<C-k>` | Normal | Move to upper window |
| `<C-l>` | Normal | Move to right window |
| `<Esc>` | Terminal | Leave terminal mode |

Telescope mappings:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ff` | Normal | Find files, respecting common ignores |
| `<leader>fg` | Normal | Live grep, respecting common ignores |
| `<leader>fb` | Normal | Buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>fs` | Normal | Document symbols |
| `<leader>fF` | Normal | Find all files, including ignored files |
| `<leader>fG` | Normal | Grep all files, including ignored files |
| `<leader>gf` | Normal | Git files |
| `<leader>gc` | Normal | Git commits |
| `<leader>gC` | Normal | Current buffer commits |
| `<leader>gB` | Normal | Git branches |
| `<leader>gt` | Normal | Git status |
| `<C-j>` | Telescope insert | Move selection down |
| `<C-k>` | Telescope insert | Move selection up |
| `<C-x>` | Telescope insert/normal | Open selection in horizontal split |
| `<C-v>` | Telescope insert/normal | Open selection in vertical split |
| `<C-t>` | Telescope insert/normal | Open selection in new tab |

LSP mappings are attached only when an LSP client is active:

| Key | Mode | Action |
| --- | --- | --- |
| `K` | Normal | Compact hover |
| `<leader>ld` | Normal | Full documentation hover |
| `gd` | Normal | Go to definition |
| `gr` | Normal | References |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>lh` | Normal | Signature help |

Gitsigns mappings are attached only for buffers managed by Git:

| Key | Mode | Action |
| --- | --- | --- |
| `]c` | Normal | Next hunk |
| `[c` | Normal | Previous hunk |
| `<leader>gp` | Normal | Preview hunk |
| `<leader>gs` | Normal | Stage hunk |
| `<leader>gr` | Normal | Reset hunk |
| `<leader>gS` | Normal | Stage buffer |
| `<leader>gR` | Normal | Reset buffer |
| `<leader>gb` | Normal | Toggle current line blame |

Diffview mappings:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>gd` | Normal | Open Git diff view |
| `<leader>gD` | Normal | Close Git diff view |
| `<leader>gh` | Normal | Current file history |
| `<leader>gh` | Visual | Selection history |
| `<leader>gH` | Normal | Project history |

Completion mappings are active in insert/select mode:

| Key | Mode | Action |
| --- | --- | --- |
| `<C-n>` | Insert/Select | Select next completion item |
| `<C-p>` | Insert/Select | Select previous completion item |
| `<C-e>` | Insert/Select | Abort completion |
| `<C-Space>` | Insert/Select | Open completion menu |
| `<C-y>` | Insert/Select | Confirm selected completion item |
| `<CR>` | Insert/Select | Confirm selected completion item |

R.nvim mappings:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>rr` | Normal | Start R |
| `<leader>rl` | Normal | Send line to R |
| `<leader>rs` | Visual | Send selection to R |
| `<leader>rf` | Normal | Send file to R |
| `<leader>rb` | Normal | Send current function to R |

## R Setup Notes

The current language setup is deliberately R-first.

Expected external tools:

- R
- optional `radian` or `arf` for a nicer R console
- R package `languageserver`
- `air` available on `PATH`

R console integration is handled by `R.nvim`. The configured console is chosen
in this order:

1. `$NVIM_R_CONSOLE`, when set.
2. `radian`, when available.
3. `arf`, when available.
4. `R`.

R.nvim starts the console with `--quiet --no-save`, uses bracketed paste, and
opens the R console in a side split once the editor is wide enough.

Formatting is still handled only by `air`. The R language server is used for
editor features and has document formatting disabled to avoid conflicts.

To disable automatic formatting for a project, create this file in the project
root:

```text
.disable_autoformat
```

Manual formatting through `<leader>bf` still uses the configured `air` LSP
client.

## Claude Code Notes

Claude Code is run through Neovim's built-in terminal, not through a plugin.

Expected external tool:

- `claude` available on `PATH`

`<leader>ac` opens Claude Code in a right-side window, starts it from the current
project root, and reuses the Claude terminal buffer when toggled again.
`<leader>as` sends either the current file path from normal mode or the selected
text from visual mode.

## Roadmap

The broader plan lives in `project.md`. The next likely steps are:

1. Keep tightening the current R workflow.
2. Add a file explorer such as Oil if the workflow needs it.
3. Add formatting support for one more language at a time.
4. Add Copilot only after the core editing workflow is solid.

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
