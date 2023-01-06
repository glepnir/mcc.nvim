local api = vim.api
local mcc = {}
mcc.ignore_keyword = {
  ['go'] = { 'syntax' }
}

function mcc:magic_char(rules)
  local lnum, col = unpack(api.nvim_win_get_cursor(0))
  local content = api.nvim_get_current_line()
  local diagnostics = vim.diagnostic.get(0, { lnum = lnum - 1 })
  print(vim.inspect(diagnostics))
  local data = vim.treesitter.get_node_at_pos(0, lnum - 1, col, {})
  print(data:type(), data:named(), data:id(), data:symbol())

  local change, times = rules[2], 0
  local target_list = {}
  for _, v in pairs(rules) do
    table.insert(target_list, content:sub(col - #v + 1, col))
  end

  local pos
  for _, target in pairs(target_list) do
    for j, rule in pairs(rules) do
      if target == rule then
        pos = j
      end
    end
  end

  if pos then
    local index = pos == #rules and 1 or pos + 1
    change = rules[index]
    times = #rules[pos]
  end
  return change, times
end

local function delete_keys(times)
  if times ~= 0 then
    return string.rep("<BS>", times)
  end
  return ""
end

function mcc:create_autocmd(ft, rules)
  if self.group == nil then
    self.group = api.nvim_create_augroup("MacgicChar", { clear = true })
  end
  api.nvim_create_autocmd("FileType", {
    group = self.group,
    pattern = ft,
    callback = function()
      vim.keymap.set("i", rules[1], function()
        local key, times = self:magic_char(rules)
        return delete_keys(times) .. key
      end, { expr = true, silent = true, replace_keycodes = true, buffer = true })
    end,
  })
end

function mcc.setup(rules)
  if true then
    vim.notify('please use glepnir/mutchar.nvim instead')
    return
  end
  vim.validate({
    rules = { rules, "t" },
  })
  for ft, data in pairs(rules) do
    if vim.tbl_islist(data) then
      mcc:create_autocmd(ft, data)
    else
      for _, v in pairs(data) do
        mcc:create_autocmd(ft, v)
      end
    end
  end
end

return mcc
