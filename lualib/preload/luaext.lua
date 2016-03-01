function enum(begin_idx)
    local enum_idx = (begin_idx or 0) - 1
    return function()
        enum_idx = enum_idx + 1
        return enum_idx
    end
end

function random(a, b)
    math.randomseed(tostring(os.time()):reverse():sub(1, 6))

	if a == nil and b == nil then
		return math.random(0, 100)
	end
	if b == nil then
		return math.random(a)
	end
	return math.random(a, b)
end