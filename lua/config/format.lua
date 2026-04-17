local M = {}

-- marker file disabling autoformat in project root
M.disable_file = ".disable_autoformat"

local function root_dir()
  local path = vim.fn.expand("%:p:h")
  local found = vim.fs.find(".git", {
    upward = true,
    path = path,
    type = "directory",
  })[1]

  if found then
    return vim.fs.dirname(found)
  end

  return vim.fn.getcwd()
end

function M.autoformat_enabled()
  local root = root_dir()

  local marker = vim.fs.find(M.disable_file, {
    path = root,
    type = "file",
    limit = 1,
  })[1]

  return marker == nil
end

function M.format(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr or 0,
    filter = function(client)
      return client.name == "air"
    end,
  })
end

return M
