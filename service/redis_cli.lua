local skynet = require "skynet"
local snax = require "snax"
local redis = require "redis"

local db

function init(...)
    db = assert(redis.connect{
	    host = '127.0.0.1',
	    port = 6379,
	    db = 0,
	    auth = 'foobared',
    },'redis connect error')
end

function exit(...)

end

function response.set(key,value)
	local result = db:set(key, value)
    if result ~= 'OK' then
        return false
    end

    return true
end

function response.get(key)
    local result = db:get(key)
	return result
end

