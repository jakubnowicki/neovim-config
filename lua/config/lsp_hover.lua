local M = {}

local function close_win(win)
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
end

local function set_close_keymaps(buf, win)
  local function close()
    close_win(win)
  end

  vim.keymap.set("n", "q", close, { buffer = buf, silent = true })
  vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true })
end

local function get_hover_contents()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  local results = vim.lsp.buf_request_sync(0, "textDocument/hover", params, 1000)

  if not results then
    return nil
  end

  for _, res in pairs(results) do
    if res.result and res.result.contents then
      local lines = vim.lsp.util.convert_input_to_markdown_lines(res.result.contents)
      lines = vim.lsp.util.trim_empty_lines(lines)

      if not vim.tbl_isempty(lines) then
        return lines
      end
    end
  end

  return nil
end

local function open_hover(opts)
  local lines = get_hover_contents()

  if not lines then
    vim.notify("No hover information available", vim.log.levels.INFO)
    return
  end

  local buf, win = vim.lsp.util.open_floating_preview(lines, "markdown", opts)

  return buf, win
end

function M.small()
  open_hover({
    border = "rounded",
    focusable = false,
    max_width = 80,
    max_height = 12,
    close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre", "WinScrolled" },
  })
end

function M.full()
  local buf, win = open_hover({
    border = "rounded",
    focusable = true,
    max_width = math.floor(vim.o.columns * 0.8),
    max_height = math.floor(vim.o.lines * 0.7),
  })

  if not buf or not win then
    return
  end

  vim.api.nvim_set_current_win(win)
  set_close_keymaps(buf, win)
end

return M
