local M = {}

-- Claude terminal state
M.term_buf = nil
M.term_win = nil
M.width = 80

-- previous buffer shown in Claude window
M.previous_buf = nil
M.previous_win = nil

local function project_root()
  local path = vim.fn.expand("%:p:h")
  local git_dir = vim.fs.find(".git", {
    upward = true,
    path = path,
    type = "directory",
  })[1]

  if git_dir then
    return vim.fs.dirname(git_dir)
  end

  return vim.fn.getcwd()
end

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function set_terminal_keymaps(buf)
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = buf, silent = true })
end

local function rightmost_window()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local rightmost = nil
  local max_col = -1

  for _, win in ipairs(wins) do
    local pos = vim.api.nvim_win_get_position(win)
    local col = pos[2]

    if col > max_col then
      max_col = col
      rightmost = win
    end
  end

  return rightmost
end

local function open_target_window()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  if #wins == 1 then
    vim.cmd("botright vsplit")
    vim.cmd("vertical resize " .. M.width)
    return vim.api.nvim_get_current_win()
  end

  local target = rightmost_window()
  if target and is_valid_win(target) then
    vim.api.nvim_set_current_win(target)
    vim.cmd("vertical resize " .. M.width)
    return target
  end

  vim.cmd("botright vsplit")
  vim.cmd("vertical resize " .. M.width)
  return vim.api.nvim_get_current_win()
end

local function remember_window_state(win)
  if not is_valid_win(win) then
    M.previous_buf = nil
    M.previous_win = nil
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)

  if is_valid_buf(M.term_buf) and buf == M.term_buf then
    M.previous_buf = nil
    M.previous_win = nil
    return
  end

  M.previous_buf = buf
  M.previous_win = win
end

local function restore_window_state()
  if is_valid_win(M.term_win) and is_valid_buf(M.previous_buf) then
    vim.api.nvim_win_set_buf(M.term_win, M.previous_buf)
  elseif is_valid_win(M.term_win) then
    vim.api.nvim_win_close(M.term_win, true)
  end

  M.term_win = nil
  M.previous_buf = nil
  M.previous_win = nil
end

local function terminal_job_id()
  if not is_valid_buf(M.term_buf) then
    return nil
  end

  return vim.b[M.term_buf].terminal_job_id
end

local function leave_visual_mode()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
end

local function ensure_open()
  if is_valid_win(M.term_win) and is_valid_buf(M.term_buf) then
    return false
  end

  M.toggle()
  return true
end

local function send_lines(lines)
  local opened_now = ensure_open()

  local function do_send()
    local job_id = terminal_job_id()
    if not job_id then
      vim.notify("Claude terminal is not available", vim.log.levels.ERROR)
      return
    end

    for _, line in ipairs(lines) do
      vim.fn.chansend(job_id, line .. "\n")
    end

    if is_valid_win(M.term_win) then
      vim.api.nvim_set_current_win(M.term_win)
      vim.schedule(function()
        vim.cmd("startinsert")
      end)
    end
  end

  if opened_now then
    vim.defer_fn(do_send, 800)
  else
    do_send()
  end
end

local function visual_selection_lines()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  if vim.tbl_isempty(lines) then
    return {}
  end

  lines[1] = string.sub(lines[1], start_col)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)

  return lines
end

function M.toggle()
  if is_valid_win(M.term_win) then
    restore_window_state()
    return
  end

  local target = open_target_window()
  remember_window_state(target)

  M.term_win = target
  vim.api.nvim_set_current_win(M.term_win)

  if is_valid_buf(M.term_buf) then
    vim.api.nvim_win_set_buf(M.term_win, M.term_buf)
    vim.cmd("startinsert")
    return
  end

  local root = project_root()

  vim.cmd("terminal")
  M.term_buf = vim.api.nvim_get_current_buf()
  M.term_win = vim.api.nvim_get_current_win()

  vim.bo[M.term_buf].buflisted = false
  set_terminal_keymaps(M.term_buf)

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = M.term_buf,
    once = true,
    callback = function()
      M.term_buf = nil
      M.term_win = nil
      M.previous_buf = nil
      M.previous_win = nil
    end,
  })

  local job_id = terminal_job_id()
  if job_id then
    vim.fn.chansend(job_id, "cd " .. vim.fn.fnameescape(root) .. "\n")
    vim.fn.chansend(job_id, "claude\n")
  end

  vim.cmd("startinsert")
end

function M.send_current_file()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  send_lines({
    file,
  })
end

function M.send_selection()
  local lines = visual_selection_lines()
  if vim.tbl_isempty(lines) then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  leave_visual_mode()

  local payload = {
    "```",
  }

  vim.list_extend(payload, lines)
  vim.list_extend(payload, { "```" })

  send_lines(payload)
end

return M
