local skynet = require "skynet"
local enet = require "enet"

local function server()
	local host = enet.host_create"localhost:5678"
	while true do
		local event = host:service(0)
		if event then
			if event.type == "receive" then
				print("Got message: ",  event.data, event.peer)
				event.peer:send("howdy back at ya")
			elseif event.type == "connect" then
				print("Connect:", event.peer)
				host:broadcast("new client connected")
			else
				print("Got event", event.type, event.peer)
			end
        end

        skynet.sleep(-1)
    end
end

skynet.start(function()
	skynet.fork(server)
end)