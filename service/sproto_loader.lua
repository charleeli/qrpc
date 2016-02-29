local Skynet = require "skynet"
local SprotoEnv = require "sproto_env"

Skynet.start(function()
    local sp_root = Skynet.getenv('sproto_path') or './build/sproto'
    SprotoEnv.init(sp_root)
    LOG_INFO("sproto config is loaded")
end)
