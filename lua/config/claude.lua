local M = {}
local tool_window = require("config.tool_window")

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

local function remember_window_state(win)
  if not tool_window.is_valid_win(win) then
    M.previous_buf = nil
    M.previous_win = nil
    return
  end

  M.previous_buf = tool_window.remember_buffer(win, M.term_buf)
  M.previous_win = win
end

local function restore_window_state()
  tool_window.restore_buffer_or_close(M.term_win, M.previous_buf)

  M.term_win = nil
  M.previous_buf = nil
  M.previous_win = nil
end

local function terminal_job_id()
  return tool_window.terminal_job_id(M.term_buf)
end

local function leave_visual_mode()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
end

local function ensure_open()
  if
    tool_window.is_valid_win(M.term_win)
    and tool_window.is_valid_buf(M.term_buf)
  then
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

    if tool_window.is_valid_win(M.term_win) then
      tool_window.focus(M.term_win, { startinsert = true })
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
  if tool_window.is_valid_win(M.term_win) then
    restore_window_state()
    return
  end

  if tool_window.hide_buffer_windows(M.term_buf) then
    M.term_win = nil
    return
  end

  local target = tool_window.open_right(M.width)
  remember_window_state(target)

  M.term_win = target
  vim.api.nvim_set_current_win(M.term_win)

  if tool_window.is_valid_buf(M.term_buf) then
    vim.api.nvim_win_set_buf(M.term_win, M.term_buf)
    tool_window.focus(M.term_win, { startinsert = true })
    return
  end

  local root = project_root()

  M.term_buf, M.term_win = tool_window.open_terminal({
    buflisted = false,
    esc = true,
  })

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

  tool_window.focus(M.term_win, { startinsert = true })
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
