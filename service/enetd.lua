local skynet = require "skynet"
local enet = require "enet"
local lfs = require "lfs"
local ctime = require 'ctime'
local sprotoloader = require "sprotoloader"
local sproto_env = require "sproto_env"
local pretty = require 'pl.pretty'

local c2s_sp = sprotoloader.load(sproto_env.PID_C2S)
local c2s_host = c2s_sp:host(sproto_env.BASE_PACKAGE)
local s2c_client = c2s_host:attach(sprotoloader.load(sproto_env.PID_S2C))

local request_handlers = {}

local function load_request_handlers()
    local path = skynet.getenv('rpc_path') or './service/agent/rpc'
    for file in lfs.dir(path) do
        local _,suffix = file:match "([^.]*).(.*)"
        if suffix == 'lua' then
            local module_data = setmetatable({}, { __index = _ENV })
            local routine, err = loadfile(path..'/'..file, "bt", module_data)
            assert(routine, err)()

            for k, v in pairs(module_data) do
                if type(v) == 'function' then
                    request_handlers[k] = v
                end
            end
        end
    end
end

local function server()
	local host = enet.host_create"localhost:5678"
	while true do
		local event = host:service(0)
		if event then
            if event.type == "receive" then
                LOG_INFO("Got message: %s , %s",  event.data, event.peer)

                local type, name, request, response = c2s_host:dispatch(event.data)
                print(type, name, request, response)
                if not request_handlers[name] then
                    LOG_ERROR('request_handler %s not exist or not loaded',name)
                end

                local r = request_handlers[name](request)
                event.peer:send(response(r))
            elseif event.type == "connect" then
                LOG_INFO("Connect:%s", event.peer)
                host:broadcast(s2c_client("broadcast",{msg="new client connected"},0))
            else
                LOG_INFO("Got event %s,%s", event.type, event.peer)
            end
        end

        skynet.sleep(-1)
    end
end

skynet.start(function()
    load_request_handlers()
	skynet.fork(server)
end)
