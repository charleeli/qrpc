local sproto = require "sproto"
local JSON = require "JSON"
local SprotoLoader = require "sprotoloader"
local SprotoEnv = require "sproto_env"
SprotoEnv.init('./build/sproto')

local serialize = {}

function serialize.ParseFromJSON(typename , raw_json_text)
    local sp = SprotoLoader.load(SprotoEnv.PID_S2C)
    local lua_value = JSON:decode(raw_json_text)
    local code = sp:encode(typename, lua_value)
    local obj = sp:decode(typename, code)
    return obj
end

function serialize.SerializeToJSON(typename , lua_value)
    local sp = SprotoLoader.load(SprotoEnv.PID_S2C)
    local code = sp:encode(typename, lua_value)
    local obj = sp:decode(typename, code)
    local raw_json_text = JSON:encode(obj)
    return raw_json_text
end

return serialize
