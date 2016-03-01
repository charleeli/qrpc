local skynet = require 'skynet'
local JSON = require "JSON"
local TypeDef = require 'typedef'
local Orm = require 'orm'

Orm.init(TypeDef.parse(
    skynet.getenv("orm_main") or 'main.td',
    skynet.getenv("orm_path") or './service/agent/td'
))

local M = {}

function M.CreateObject(cls_type, data)
    return Orm.create(cls_type, data)
end

function M.dump(data)
    local ret = {}
    for k, v in pairs(data) do
        if type(v) == 'table' then
            ret[k] = M.dump(v)
        else
            ret[k] = v
        end
    end
    return ret
end

function M.DumpToJSON(cls_type, obj)
    assert(obj.__cls.name == cls_type, "dump to json, class type unmatch")
    return JSON:encode(M.dump(obj))
end

function M.LoadFromJSON(cls_type , raw_json_text)
    assert(raw_json_text, "load from json, no raw_json_text")
    return M.CreateObject(cls_type, JSON:decode(raw_json_text))
end

return M
