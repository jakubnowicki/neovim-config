local M = {}

function M.is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

function M.is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

function M.windows_for_buffer(buf)
  if not M.is_valid_buf(buf) then
    return {}
  end

  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if M.is_valid_win(win) and vim.api.nvim_win_get_buf(win) == buf then
      table.insert(wins, win)
    end
  end

  return wins
end

function M.focus(win, opts)
  opts = opts or {}

  if not M.is_valid_win(win) then
    return false
  end

  vim.api.nvim_set_current_win(win)

  if opts.startinsert then
    vim.schedule(function()
      if M.is_valid_win(win) then
        vim.api.nvim_set_current_win(win)
        vim.cmd("startinsert")
      end
    end)
  end

  return true
end

function M.focus_buffer_window(buf, opts)
  local wins = M.windows_for_buffer(buf)
  return M.focus(wins[1], opts)
end

function M.focus_buffer_when_ready(buf_getter, opts)
  opts = opts or {}

  local attempt = opts.attempt or 1
  local max_attempts = opts.max_attempts or 80
  local interval = opts.interval or 50

  if M.focus_buffer_window(buf_getter(), opts) then
    return
  end

  if attempt >= max_attempts then
    return
  end

  vim.defer_fn(function()
    opts.attempt = attempt + 1
    M.focus_buffer_when_ready(buf_getter, opts)
  end, interval)
end

function M.hide_window(win)
  if not M.is_valid_win(win) then
    return false
  end

  if #vim.api.nvim_tabpage_list_wins(0) > 1 then
    vim.api.nvim_win_close(win, true)
  else
    vim.cmd("bprevious")
  end

  return true
end

function M.hide_buffer_windows(buf)
  local wins = M.windows_for_buffer(buf)
  if vim.tbl_isempty(wins) then
    return false
  end

  for _, win in ipairs(wins) do
    M.hide_window(win)
  end

  return true
end

function M.open_bottom(height)
  vim.cmd("botright split")
  vim.cmd("resize " .. height)
  return vim.api.nvim_get_current_win()
end

function M.rightmost_window()
  local rightmost = nil
  local max_col = -1

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local pos = vim.api.nvim_win_get_position(win)
    local col = pos[2]

    if col > max_col then
      max_col = col
      rightmost = win
    end
  end

  return rightmost
end

function M.open_right(width)
  local wins = vim.api.nvim_tabpage_list_wins(0)

  if #wins == 1 then
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize " .. width)
    return vim.api.nvim_get_current_win()
  end

  local target = M.rightmost_window()
  if M.is_valid_win(target) then
    vim.api.nvim_set_current_win(target)
    vim.cmd("vertical resize " .. width)
    return target
  end

  vim.cmd("botright vsplit")
  vim.cmd("vertical resize " .. width)
  return vim.api.nvim_get_current_win()
end

function M.remember_buffer(win, ignored_buf)
  if not M.is_valid_win(win) then
    return nil
  end

  local buf = vim.api.nvim_win_get_buf(win)
  if M.is_valid_buf(ignored_buf) and buf == ignored_buf then
    return nil
  end

  return buf
end

function M.restore_buffer_or_close(win, buf)
  if M.is_valid_win(win) and M.is_valid_buf(buf) then
    vim.api.nvim_win_set_buf(win, buf)
  elseif M.is_valid_win(win) then
    vim.api.nvim_win_close(win, true)
  end
end

function M.set_terminal_escape(buf)
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })
end

function M.open_terminal(opts)
  opts = opts or {}

  vim.cmd("terminal")

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()

  if opts.buflisted == false then
    vim.bo[buf].buflisted = false
  end

  if opts.esc ~= false then
    M.set_terminal_escape(buf)
  end

  return buf, win
end

function M.terminal_job_id(buf)
  if not M.is_valid_buf(buf) then
    return nil
  end

  return vim.b[buf].terminal_job_id
end

return M
