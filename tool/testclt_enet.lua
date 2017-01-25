package.cpath = package.cpath..";./build/luaclib/?.so;./build/luaclib/levent/?.so"
package.path  = package.path..";./lualib/?.lua"..";./example/complex/?.lua"
                ..";./build/lualib/?.lua;./build/lualib/?.lua"

local enet = require "enet"

local host = enet.host_create()
local server = host:connect("127.0.0.1:5678")

local count = 0
while count < 10000 do
	local event = host:service(100)
	if event then
		if event.type == "receive" then
			print("Got message: %s",  event.data)
		else
			print("Got event %s", event.type)
		end
	end

	if count % 8 == 0 then
		server:send("hello world")
	end

	count = count + 1
end

server:disconnect()
host:flush()
