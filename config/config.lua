root = "./"
thread = 8
logger = nil
logpath = "."
harbor = 1
address = "127.0.0.1:2526"
master = "127.0.0.1:2013"
start = "main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap
standalone = "0.0.0.0:2013"

skynetroot = "./3rd/skynet/"
debug_port = 8000
sproto_path = './build/sproto'
rpc_path = './service/agent/rpc'
log_dirname = "log"
log_basename = "test"

-- 自定义服务
myservice = "./service/?.lua;" ..
        "./service/?/main.lua;"..
        "./service/agent/?.lua"

-- LUA服务所在位置
luaservice = skynetroot .. "service/?.lua;" .. myservice

-- run preload.lua before every lua service run
preload = "./lualib/preload/preload.lua"

-- 用于加载LUA服务的LUA代码
lualoader = skynetroot .. "lualib/loader.lua"

-- preload = "./examples/preload.lua"	-- run preload.lua before every lua service run
snax = myservice
-- snax_interface_g = "snax_g"

-- C编写的服务模块路径
cpath = skynetroot .. "cservice/?.so;".."./build/cservice/?.so"

-- 将添加到 package.path 中的路径，供 require 调用
lua_path = skynetroot .. "lualib/?.lua;" ..
           "./build/lualib/?.lua;" ..
		   "./lualib/?.lua;" ..
		   "./lualib/preload/?.lua;" ..
		   "./lualib/entity/?.lua;"..
		   "./service/agent/?.lua;"..
		   "./service/?.lua"

-- 将添加到 package.cpath 中的路径，供 require 调用
lua_cpath = skynetroot .. "luaclib/?.so;" .. "./build/luaclib/?.so"

-- 后台模式
-- daemon = "./skynet.pid"

--redis configuration
redis_host = '127.0.0.1'
redis_port = 6379
redis_auth = 'foobared'
