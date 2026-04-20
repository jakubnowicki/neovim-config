# Neovim - Plan for Building a Portable Configuration Step by Step

## Goal

Build a **lightweight, portable, and understandable Neovim setup** that:
- works in client environments, which are often restricted,
- does not require special fonts or a GUI,
- supports: **R (Shiny), Python, JavaScript, CSS/Sass, SQL**,
- integrates with AI tools (Copilot, Claude Code),
- is developed **gradually and with full awareness**.

---

## Main Assumptions

### 1. Minimalism > "full IDE"
We are not building a complex environment right away. Every element is added deliberately.

### 2. Terminal-first
The terminal is the central part of the workflow:
- running R / Shiny
- git
- tests
- Claude Code

Without relying on plugins - start with Neovim's built-in terminal.

### 3. No Dependency on Nerd Fonts
The setup must work in "poor" environments:
- no icons as an assumption
- no fancy UI
- readability in a regular terminal

### 4. Every Step Is Understandable and Reversible
After each stage:
- you know what was added
- you know how to disable it
- you know how to debug it

### 5. One Change = One Commit
Config as a repository:
- history = documentation
- easy rollback

---

## Target Architecture

The config should be:
- portable (`git clone ~/.config/nvim`)
- modular (`lua/config`, `lua/plugins`)
- stable (plugin lockfile)
- simple (no unnecessary layers)

---

## Step-by-Step Plan

## Stage 1 - Minimal Neovim (No Plugins)

**Goal:**
- your own `init.lua`
- basic settings
- first keymaps

**Understanding:**
- how the config is loaded
- what `init.lua` is
- how Lua works in Neovim

---

## Stage 2 - Terminal (Key Element)

**Goal:**
- using `:terminal`
- custom shortcuts:
  - opening the terminal (horizontal/vertical split)
  - switching between modes

**Why now:**
- foundation of the workflow
- works everywhere
- zero dependencies

**Use case:**
- R / Shiny
- git
- Claude Code
- npm / python / SQL

---

## Stage 3 - Plugin Manager

**Tool:**
- `lazy.nvim`

**Goal:**
- plugin installation
- lazy loading
- version control (lockfile)

**Understanding:**
- where plugins are stored
- how they are loaded
- what plugin configuration looks like

---

## Stage 4 - First Utility Plugin

**Proposal:**
- `which-key.nvim` or `telescope.nvim`

**Goal:**
- the first real ergonomics boost
- without much complexity

---

## Stage 5 - Treesitter

**Goal:**
- better highlighting
- better code navigation

**Understanding:**
- parsers per language
- difference from classic highlighting

---

## Stage 6 - LSP (For One Language)

**Tools:**
- built-in `vim.lsp`
- `nvim-lspconfig`
- optionally `mason.nvim`

**Goal:**
- completion
- definitions
- rename
- diagnostics

**Important:**
- only one language to start with (for example R or Python)

---

## Stage 7 - Completion

**Tool:**
- `blink.cmp`

**Goal:**
- UI for completion

**Understanding:**
- LSP != completion
- completion sources

---

## Stage 8 - Formatting

**Tool:**
- `conform.nvim`

**Goal:**
- code formatting

**Rule:**
- start with one language
- no global format-on-save

---

## Stage 9 - R / Shiny Workflow

**Tool:**
- `R.nvim`

**Goal:**
- integration with R
- sending code
- working with a session

---

## Stage 10 - AI

**Order:**
1. GitHub Copilot
2. Claude Code

**Rule:**
- AI at the end (so it does not hide gaps in the setup)

**Approach:**
- Copilot as a plugin
- Claude Code mainly through the terminal

---

## Minimal Stack (Target)

- `lazy.nvim`
- `which-key.nvim`
- `telescope.nvim`
- `oil.nvim` (optional)
- `gitsigns.nvim`
- `nvim-treesitter`
- `nvim-lspconfig`
- `mason.nvim` (optional)
- `blink.cmp`
- `conform.nvim`
- `R.nvim`
- `copilot.lua` / `copilot.vim`

---

## What to Avoid

- ready-made distributions (LazyVim, AstroNvim)
- dependency on Nerd Fonts
- too many plugins
- configuring everything at once
- building UI instead of workflow

---

## Usage Profiles

### Minimal (Emergency)
- no LSP
- no AI
- only basics + terminal

### Daily
- LSP
- completion
- R workflow
- Copilot

### Extended (Full Environment Control)
- Claude Code plugin
- additional automations

---

## Key Principle

**You are building a tool for client work, not a "pretty config".**

Most important:
- always works
- easy to debug
- easy to move
- you understand every element

---

## Next Step

**Stage 1 + Stage 2**:
- minimal `init.lua`
- directory structure
- terminal shortcuts

With a full explanation of every line.
