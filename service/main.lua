local skynet = require "skynet"
local max_client = 64

skynet.start(function()
	print("Server start")
	local log = skynet.uniqueservice("log")
	skynet.call(log, "lua", "start")
	skynet.uniqueservice("sproto_loader")
	local console = skynet.newservice("console")
	skynet.newservice("debug_console",tonumber(skynet.getenv("debug_port")))
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	print("Watchdog listen on ", 8888)

	skynet.exit()
end)
