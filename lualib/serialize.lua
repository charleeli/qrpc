local sproto = require "sproto"
local JSON = require "JSON"
local SprotoLoader = require "sprotoloader"
local SprotoEnv = require "sproto_env"

local serialize = {
    sp = SprotoLoader.load(SprotoEnv.PID_S2C)
}

function serialize.ParseFromJSON(typename , raw_json_text)
    local lua_value = JSON:decode(raw_json_text)
    local code = serialize.sp:encode(typename, lua_value)
    local obj = serialize.sp:decode(typename, code)
    return obj
end

function serialize.SerializeToJSON(typename , lua_value)
    local code = serialize.sp:encode(typename, lua_value)
    local obj = serialize.sp:decode(typename, code)
    local raw_json_text = JSON:encode(obj)
    return raw_json_text
end

return serialize
