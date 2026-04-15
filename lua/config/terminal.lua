local M = {}

-- store terminal buffer and window
M.term_buf = nil
M.term_win = nil
M.height = 12

-- check if window is still valid
local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

-- check if buffer is still valid
local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

function M.toggle()
  -- If terminal window is visible, close only the window.
  if is_valid_win(M.term_win) then
    vim.api.nvim_win_close(M.term_win, true)
    M.term_win = nil
    return
  end

  -- Open terminal at the bottom with fixed height.
  vim.cmd("botright split")
  vim.cmd("resize " .. M.height)

  -- Reuse existing terminal buffer if possible.
  if is_valid_buf(M.term_buf) then
    vim.api.nvim_win_set_buf(0, M.term_buf)
    M.term_win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
    return
  end

  -- Otherwise create a new terminal buffer.
  vim.cmd("terminal")
  M.term_buf = vim.api.nvim_get_current_buf()
  M.term_win = vim.api.nvim_get_current_win()

  -- make terminal buffer "special" (not in buffer list)
  vim.bo[M.term_buf].buflisted = false

  -- allow exiting terminal mode with ESC (local to this buffer)
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = M.term_buf })

  -- go straight to insert mode
  vim.cmd("startinsert")
end

return M
