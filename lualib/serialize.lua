local skynet = require 'skynet'
local TypeDef = require 'typedef'
local Orm = require 'orm'

Orm.init(TypeDef.parse(
    skynet.getenv("orm_main") or 'main.orm',
    skynet.getenv("orm_path") or './service/agent/orm'
))

local M = {}

function M.CreateObject(cls_type, data)
    return Orm.create(cls_type, data)
end

function M.ToMongo(data)
    local ret = {}
    for k, v in pairs(data) do
        if type(v) == 'table' then
            ret[k] = M.ToMongo(v)
        else
            ret[k] = v
        end
    end
    return ret
end

function M.DumpMongo(cls_type, obj)
    assert(obj.__cls.name == cls_type, "dump mongo, class type unmatch")
    return M.ToMongo(obj)
end

function M.LoadMongo(cls_type , data)
    assert(data, "load mongo, no data")
    return M.CreateObject(cls_type, data)
end

return M
