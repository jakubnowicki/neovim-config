local M = {}

local function executable(cmd)
  return vim.fn.executable(cmd) == 1
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

return M
