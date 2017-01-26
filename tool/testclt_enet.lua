package.cpath = package.cpath..";./build/luaclib/?.so;./3rd/skynet/luaclib/?.so"
package.path = package.path..";./build/lualib/?.lua;./build/lualib/?.lua;./lualib/?.lua;"
		.."./3rd/skynet/lualib/?.lua;./3rd/skynet/examples/?.lua"

local pretty = require 'pl.pretty'
local enet = require "enet"
local SprotoLoader = require "sprotoloader"
local SprotoEnv = require "sproto_env"
SprotoEnv.init('./build/sproto')

local s2c_sp = SprotoLoader.load(SprotoEnv.PID_S2C)
local s2c_host = s2c_sp:host(SprotoEnv.BASE_PACKAGE)
local c2s_client = s2c_host:attach(SprotoLoader.load(SprotoEnv.PID_C2S))

local host = enet.host_create()
local server = host:connect("127.0.0.1:5678")

local session = 0

local function send_request(name, args)
    session = session + 1
    local v = c2s_client(name, args, session)
    server:send(v)
end

local function check_cmd(s)
    if s == "" or s == nil then
        return s
    end

    local cmd = ""
    local args = nil
    local b, e = string.find(s, " ")
    if b then
        cmd = s:sub(0, b - 1)
        local args_data = "return " .. s:sub(e + 1)
        local f, err = load(args_data)
        if f == nil then
            print("illegal cmd", s, _args)
            return
        end

        local ok, _args = pcall(f)
        if (not ok) or (type(_args) ~= 'table') then
            print("illegal cmd", s, _args)
            return
        else
            args = _args
        end
    else
        cmd = s
    end

    local ok, err = pcall(send_request, cmd, args)
    if not ok then
        print('send err', cmd, args, err)
    end
end

while true do
	local event = host:service(100)
	if event then
		if event.type == "receive" then
			local type, session, response = s2c_host:dispatch(event.data)
			print('----',type, session)
			pretty.dump(response)
			print('----')
		else
			print("Got event %s", event.type)
		end
    end

    io.write("Enter some text: ")
	check_cmd(io.read())
end

server:disconnect()
host:flush()
