package.cpath = "./luaclib/?.so;./3rd/skynet/luaclib/?.so"
package.path = "./build/lualib/?.lua;./lualib/?.lua;".."./3rd/skynet/lualib/?.lua;./3rd/skynet/examples/?.lua"

local pretty = require 'pl.pretty'

if _VERSION ~= "Lua 5.3" then
	error "Use lua 5.3"
end

local SprotoLoader = require "sprotoloader"
local SprotoEnv = require "sproto_env"
SprotoEnv.init('./build/sproto')

local s2c_sp = SprotoLoader.load(SprotoEnv.PID_S2C)
local s2c_host = s2c_sp:host(SprotoEnv.BASE_PACKAGE)
local c2s_request = s2c_host:attach(SprotoLoader.load(SprotoEnv.PID_C2S))

local socket = require "clientsocket"

local fd = assert(socket.connect("127.0.0.1", 8888))

local function send_package(fd, pack)
	local package = string.pack(">s2", pack)
	socket.send(fd, package)
end

local function unpack_package(text)
	local size = #text
	if size < 2 then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end

	return text:sub(3,2+s), text:sub(3+s)
end

local function recv_package(last)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local r = socket.recv(fd)
	if not r then
		return nil, last
	end
	if r == "" then
		error "Server closed"
	end
	return unpack_package(last .. r)
end

local session = 0

local function send_request(name, args)
	session = session + 1
	local str = c2s_request(name, args, session)
	send_package(fd, str)
	print("Request:", session)
end

local last = ""

local function print_request(name, args)
	print("REQUEST", name)
	pretty.dump(args)
end

local function print_response(session, args)
	print("RESPONSE", session)
	pretty.dump(args)
end

local function print_package(t, ...)
	if t == "REQUEST" then
		print_request(...)
	else
		assert(t == "RESPONSE")
		print_response(...)
	end
end

local function dispatch_package()
	while true do
		local v
		v, last = recv_package(last)
		if not v then
			break
		end

		print_package(s2c_host:dispatch(v))
	end
end

send_request("set_role", {uid=123,name="alice"})
send_request("get_role", {uid=123,name="alice"})

while true do
	dispatch_package()
	local cmd = socket.readstdin()
	if cmd then
		if cmd == "quit" then
			send_request("quit")
		end
	else
		socket.usleep(100)
	end
end
