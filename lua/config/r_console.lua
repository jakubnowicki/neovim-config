local M = {}
local tool_window = require("config.tool_window")

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
end

local function get_r_buffer()
  local ok, builtin = pcall(require, "r.term.builtin")
  if not ok then
    return nil
  end

  local bufnr = builtin.get_buf_nr()
  if not tool_window.is_valid_buf(bufnr) then
    return nil
  end

  return bufnr
end

local function hide_if_visible()
  return tool_window.hide_buffer_windows(get_r_buffer())
end

local function focus_console()
  tool_window.focus_buffer_when_ready(get_r_buffer, {
    startinsert = true,
    max_attempts = 80,
    interval = 50,
  })
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
  focus_console()
end

return M
