local JSON = require "JSON"
local snax = require "snax"
local serialize = require "serialize"
local pretty = require 'pl.pretty'

local redis_cli

function send_private_chat(args)
    LOG_INFO("args = %s",JSON:encode(args))
    if not redis_cli then
		redis_cli = snax.uniqueservice("redis_cli")
    end

    local ok = redis_cli.req.set("foo1", serialize.SerializeToJSON("Chat" , {type = 0,uuid=123}))

    return {errcode = 1}
end

function recv_private_chat(args)
    LOG_INFO("args = %s",JSON:encode(args))
    if not redis_cli then
		redis_cli = snax.uniqueservice("redis_cli")
    end

    local raw_json_text = redis_cli.req.get("foo1")

    local value =  serialize.ParseFromJSON("Chat" , raw_json_text)

    return {chat = value}
end
