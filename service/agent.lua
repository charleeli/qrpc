local skynet = require "skynet"
local netpack = require "netpack"
local lfs = require"lfs"
local socket = require "socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"
local sproto_env = require "sproto_env"

local c2s_sp = sprotoloader.load(sproto_env.PID_C2S)
local c2s_host = c2s_sp:host(sproto_env.BASE_PACKAGE)

local WATCHDOG
local send_request

local CMD = {}
local client_fd

local request_handlers = {}

function request_handlers.quit()
	skynet.call(WATCHDOG, "lua", "close", client_fd)
end

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

local function request(name, args, response)
	local f = assert(request_handlers[name])
	local r = f(args)
	if response then
		return response(r)
	end
end

local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return c2s_host:dispatch(msg, sz)
	end,
	dispatch = function (_, _, type, ...)
		if type == "REQUEST" then
			local ok, result  = pcall(request, ...)
			if ok then
				if result then
					send_package(result)
				end
			else
				skynet.error(result)
			end
		else
			assert(type == "RESPONSE")
			error "This example doesn't support request client"
		end
	end
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end

skynet.start(function()
	load_request_handlers()

	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
