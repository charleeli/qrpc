local JSON = require "JSON"
local snax = require "snax"
local serialize = require "serialize"
local pretty = require 'pl.pretty'

local redis_cli

function set_role(args)
    LOG_INFO("args = %s",JSON:encode(args))
    if not redis_cli then
		redis_cli = snax.uniqueservice("redis_cli")
    end

    local obj = serialize.CreateObject('Role')
    obj.uid = random(10000, 1000000000)

    local ok = redis_cli.req.set("foo1",JSON:encode(obj))

    return {errcode = ok}
end

function get_role(args)
    LOG_INFO("args = %s",JSON:encode(args))
    if not redis_cli then
		redis_cli = snax.uniqueservice("redis_cli")
    end

    local raw_json_text = redis_cli.req.get("foo1")

    local value =  serialize.LoadMongo('Role',JSON:decode(raw_json_text))

    return {role = value}
end
