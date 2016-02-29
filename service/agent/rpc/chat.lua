local JSON = require "JSON"

function send_private_chat(args)
    LOG_INFO("args = %s",JSON:encode(args))
    return {errcode = 0}
end
