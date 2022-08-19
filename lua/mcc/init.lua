local api = vim.api
local mcc = {}

function mcc:magic_char(rules)
	local col = api.nvim_win_get_cursor(0)[2]
	local content = api.nvim_get_current_line()
	for i, v in pairs(rules) do
		local target = content:sub(col - #v + 1, col)
		if target == v then
			if i ~= #rules then
				return rules[i + 1], #v
			else
				return rules[1], #v
			end
		end
	end
	return rules[2]
end

local function delete_keys(times)
	if times ~= nil then
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
	vim.validate({
		rules = { rules, "t" },
	})
	for ft, rule in pairs(rules) do
		if type(rule[1]) == "table" then
			for _, v in pairs(rule) do
				mcc:create_autocmd(ft, v)
			end
		else
			mcc:create_autocmd(ft, rule)
		end
	end
end

return mcc
