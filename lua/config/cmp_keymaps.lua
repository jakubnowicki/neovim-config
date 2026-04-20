local M = {}

function M.get(cmp)
  return cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-y>"] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_selected_entry() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        })
      else
        fallback()
      end
    end, { "i", "s" }),
  })
end

return M
