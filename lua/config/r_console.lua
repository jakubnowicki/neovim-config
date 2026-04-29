local M = {}

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function get_r_buffer()
  local ok, builtin = pcall(require, "r.term.builtin")
  if not ok then
    return nil
  end

  local bufnr = builtin.get_buf_nr()
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return nil
  end

  return bufnr
end

local function r_windows()
  local bufnr = get_r_buffer()
  if not bufnr then
    return {}
  end

  local wins = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_valid_win(win) and vim.api.nvim_win_get_buf(win) == bufnr then
      table.insert(wins, win)
    end
  end

  return wins
end

local function hide_if_visible()
  local wins = r_windows()
  if vim.tbl_isempty(wins) then
    return false
  end

  for _, win in ipairs(wins) do
    if is_valid_win(win) then
      if #vim.api.nvim_tabpage_list_wins(0) > 1 then
        vim.api.nvim_win_close(win, true)
      else
        vim.cmd("bprevious")
      end
    end
  end

  return true
end

local function focus_console()
  local wins = r_windows()
  local win = wins[1]
  if not is_valid_win(win) then
    return false
  end

  vim.api.nvim_set_current_win(win)
  vim.schedule(function()
    if is_valid_win(win) then
      vim.api.nvim_set_current_win(win)
      vim.cmd("startinsert")
    end
  end)

  return true
end

local function focus_when_ready(attempt)
  attempt = attempt or 1

  if focus_console() then
    return
  end

  if attempt >= 80 then
    return
  end

  vim.defer_fn(function()
    focus_when_ready(attempt + 1)
  end, 50)
end

function M.get()
  local env = vim.env.NVIM_R_CONSOLE

  if env and env ~= "" then
    return env
  end

  if executable("radian") then
    return "radian"
  end

  if executable("arf") then
    return "arf"
  end

  return "R"
end

function M.toggle()
  if hide_if_visible() then
    return
  end

  require("r.run").start_R("R")
  focus_when_ready()
end

return M
