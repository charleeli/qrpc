local json = require "cjson"

function send_private_chat(args)
    LOG_INFO("args = %s",json.encode(args))
    return {errcode = 0}
end

function send_world_chat(args)
    LOG_INFO("args = %s",json.encode(args))
    return {errcode = 0}
end