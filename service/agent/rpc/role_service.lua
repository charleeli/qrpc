local snax = require "snax"
local JSON = require "JSON"
local td = require "td"
local random = require 'random'

local redis_cli

function set_role(args)
    LOG_INFO("args = %s",JSON:encode(args))
    if not redis_cli then
		redis_cli = snax.uniqueservice("redis_cli")
    end

    local obj = td.CreateObject('Role')
    obj.uid = random.random(10, 1000)

    local ok = redis_cli.req.set("foo1",td.DumpToJSON('Role', obj))

    return {errcode = ok}
end

function get_role(args)
    LOG_INFO("args = %s",JSON:encode(args))
    if not redis_cli then
		redis_cli = snax.uniqueservice("redis_cli")
    end

    local raw_json_text = redis_cli.req.get("foo1")

    local value =  td.LoadFromJSON('Role',raw_json_text)

    return {role = value}
end
