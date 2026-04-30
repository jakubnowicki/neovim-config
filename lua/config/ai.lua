local M = {}
local tool_window = require("config.tool_window")

M.width = 80
M.win = nil
M.previous_buf = nil
M.active = nil
M.sessions = {}

M.tools = {
  claude = {
    label = "Claude Code",
    command = "claude",
  },
  codex = {
    label = "Codex",
    command = "codex",
  },
  opencode = {
    label = "OpenCode",
    command = "opencode",
  },
  gemini = {
    label = "Gemini",
    command = "gemini",
  },
  copilot = {
    label = "GitHub Copilot",
    command = "copilot",
  },
}

local function project_root()
  local path = vim.fn.expand("%:p:h")
  if path == "" then
    return vim.fn.getcwd()
  end

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

local function session(name)
  M.sessions[name] = M.sessions[name] or {}
  return M.sessions[name]
end

local function tool_available(name)
  local tool = M.tools[name]

  if not tool then
    vim.notify("Unknown AI tool: " .. name, vim.log.levels.ERROR)
    return false
  end

  if vim.fn.executable(tool.command) ~= 1 then
    vim.notify(
      tool.label .. " is not available: " .. tool.command,
      vim.log.levels.WARN
    )
    return false
  end

  return true
end

local function remember_window_state(win)
  if not tool_window.is_valid_win(win) then
    M.previous_buf = nil
    return
  end

  M.previous_buf = tool_window.remember_buffer(win, nil)
end

local function restore_window_state()
  tool_window.restore_buffer_or_close(M.win, M.previous_buf)

  M.win = nil
  M.previous_buf = nil
  M.active = nil
end

local function set_session_buffer(name, buf)
  local state = session(name)
  state.buf = buf

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      state.buf = nil

      if M.active == name then
        M.active = nil
        M.win = nil
      end
    end,
  })
end

local function terminal_job_id(name)
  return tool_window.terminal_job_id(session(name).buf)
end

local function start_tool(name)
  local tool = M.tools[name]
  local state = session(name)

  state.buf, M.win = tool_window.open_terminal({
    buflisted = false,
    esc = true,
  })

  set_session_buffer(name, state.buf)

  local job_id = terminal_job_id(name)
  if job_id then
    vim.fn.chansend(job_id, "cd " .. vim.fn.fnameescape(project_root()) .. "\n")
    vim.fn.chansend(job_id, tool.command .. "\n")
  end
end

local function show_tool(name)
  local state = session(name)

  vim.api.nvim_set_current_win(M.win)

  if tool_window.is_valid_buf(state.buf) then
    vim.api.nvim_win_set_buf(M.win, state.buf)
  else
    start_tool(name)
  end

  M.active = name
  tool_window.focus(M.win, { startinsert = true })
end

local function ensure_panel()
  if tool_window.is_valid_win(M.win) then
    return
  end

  for _, state in pairs(M.sessions) do
    local wins = tool_window.windows_for_buffer(state.buf)
    if not vim.tbl_isempty(wins) then
      M.win = wins[1]
      return
    end
  end

  local target = tool_window.open_right(M.width)
  remember_window_state(target)
  M.win = target
end

local function ensure_open(name)
  if M.active == name and tool_window.is_valid_win(M.win) then
    return false
  end

  M.toggle(name)
  return true
end

local function leave_visual_mode()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
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

local function send_lines(name, lines)
  local opened_now = ensure_open(name)

  local function do_send()
    local job_id = terminal_job_id(name)
    if not job_id then
      vim.notify(
        M.tools[name].label .. " terminal is not available",
        vim.log.levels.ERROR
      )
      return
    end

    for _, line in ipairs(lines) do
      vim.fn.chansend(job_id, line .. "\n")
    end

    if tool_window.is_valid_win(M.win) then
      tool_window.focus(M.win, { startinsert = true })
    end
  end

  if opened_now then
    vim.defer_fn(do_send, 800)
  else
    do_send()
  end
end

function M.toggle(name)
  if not tool_available(name) then
    return
  end

  if M.active == name and tool_window.is_valid_win(M.win) then
    restore_window_state()
    return
  end

  ensure_panel()
  show_tool(name)
end

function M.send_current_file()
  if not M.active then
    vim.notify("No active AI tool", vim.log.levels.WARN)
    return
  end

  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  send_lines(M.active, { file })
end

function M.send_selection()
  if not M.active then
    vim.notify("No active AI tool", vim.log.levels.WARN)
    return
  end

  local lines = visual_selection_lines()
  if vim.tbl_isempty(lines) then
    vim.notify("No visual selection found", vim.log.levels.WARN)
    return
  end

  leave_visual_mode()

  local payload = { "```" }
  vim.list_extend(payload, lines)
  vim.list_extend(payload, { "```" })

  send_lines(M.active, payload)
end

return M
