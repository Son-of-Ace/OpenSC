--!strict

--[[
	This Utility defines extra table behaviour which doesn't exist in Luau natively
]]

local TableService = {}

function TableService.Reverse(t)
	local lo, hi = 1, #t
	while lo < hi do
		t[lo], t[hi] = t[hi], t[lo]
		lo += 1
		hi -= 1
	end
end

return TableService
