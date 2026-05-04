local M = {}
local tool_window = require("config.tool_window")

-- store terminal buffer and window
M.term_buf = nil
M.term_win = nil
M.height = 12

local function open_or_focus()
  if tool_window.focus_buffer_window(M.term_buf, { startinsert = true }) then
    M.term_win = vim.api.nvim_get_current_win()
    return
  end

  -- Open terminal at the bottom with fixed height.
  M.term_win = tool_window.open_bottom(M.height)

  -- Reuse existing terminal buffer if possible.
  if tool_window.is_valid_buf(M.term_buf) then
    vim.api.nvim_win_set_buf(0, M.term_buf)
    M.term_win = vim.api.nvim_get_current_win()
    tool_window.focus(M.term_win, { startinsert = true })
    return
  end

  -- Otherwise create a new terminal buffer.
  M.term_buf, M.term_win = tool_window.open_terminal({
    buflisted = false,
    esc = true,
  })

  tool_window.focus(M.term_win, { startinsert = true })
end

function M.toggle()
  -- If the terminal buffer is visible, hide it without killing the job.
  if tool_window.hide_buffer_windows(M.term_buf) then
    M.term_win = nil
    return
  end

  open_or_focus()
end

function M.focus_or_open()
  open_or_focus()
end

return M
