.PHONY: all skynet clean

TOP=$(PWD)
BUILD_DIR =             $(PWD)/build
BUILD_BIN_DIR =         $(BUILD_DIR)/bin
BUILD_INCLUDE_DIR =     $(BUILD_DIR)/include
BUILD_LUALIB_DIR =      $(BUILD_DIR)/lualib
BUILD_CLIB_DIR =        $(BUILD_DIR)/clib
BUILD_LUACLIB_DIR =     $(BUILD_DIR)/luaclib
BUILD_STATIC_LIB_DIR =  $(BUILD_DIR)/staticlib
BUILD_SPROTO_DIR =      $(BUILD_DIR)/sproto

PLAT ?= linux
SHARED := -fPIC --shared
CFLAGS = -g -O2 -Wall -I$(BUILD_INCLUDE_DIR) 
LDFLAGS= -L$(BUILD_CLIB_DIR) -Wl,-rpath $(BUILD_CLIB_DIR) -lpthread -lm -ldl -lrt
DEFS = -DHAS_SOCKLEN_T=1 -DLUA_COMPAT_APIINTCASTS=1 

all : build skynet lua53 Penlight json

build:
	-mkdir $(BUILD_DIR)
	-mkdir $(BUILD_BIN_DIR)
	-mkdir $(BUILD_INCLUDE_DIR)
	-mkdir $(BUILD_LUALIB_DIR)
	-mkdir $(BUILD_LUALIB_DIR)/pl/
	-mkdir $(BUILD_CLIB_DIR)
	-mkdir $(BUILD_LUACLIB_DIR)
	-mkdir $(BUILD_STATIC_LIB_DIR)
	-mkdir $(BUILD_SPROTO_DIR)

lua53:
	cd 3rd/skynet/3rd/lua/ && $(MAKE) MYCFLAGS="-O2 -fPIC -g" linux
	install -p -m 0755 3rd/skynet/3rd/lua/lua $(BUILD_BIN_DIR)/lua
	install -p -m 0755 3rd/skynet/3rd/lua/luac $(BUILD_BIN_DIR)/luac
	install -p -m 0644 3rd/skynet/3rd/lua/liblua.a $(BUILD_STATIC_LIB_DIR)
	install -p -m 0644 3rd/skynet/3rd/lua/lua.h $(BUILD_INCLUDE_DIR)
	install -p -m 0644 3rd/skynet/3rd/lua/lauxlib.h $(BUILD_INCLUDE_DIR)
	install -p -m 0644 3rd/skynet/3rd/lua/lualib.h $(BUILD_INCLUDE_DIR)
	install -p -m 0644 3rd/skynet/3rd/lua/luaconf.h $(BUILD_INCLUDE_DIR)

Penlight:
	cp -r 3rd/Penlight/lua/pl/* $(BUILD_LUALIB_DIR)/pl/

json:
	cp 3rd/json-lua/JSON.lua $(BUILD_LUALIB_DIR)/

skynet/Makefile :
	git submodule update --init

skynet : skynet/Makefile
	cd 3rd/skynet && $(MAKE) $(PLAT) && cd ../..
	cp 3rd/skynet/skynet-src/skynet_malloc.h $(BUILD_INCLUDE_DIR)
	cp 3rd/skynet/skynet-src/skynet.h $(BUILD_INCLUDE_DIR)
	cp 3rd/skynet/skynet-src/skynet_env.h $(BUILD_INCLUDE_DIR)
	cp 3rd/skynet/skynet-src/skynet_socket.h $(BUILD_INCLUDE_DIR)
	
LUACLIB = log lfs

all : \
  $(foreach v, $(LUACLIB), $(BUILD_LUACLIB_DIR)/$(v).so) 

$(BUILD_CLIB_DIR) :
	mkdir $(BUILD_CLIB_DIR)

$(BUILD_LUACLIB_DIR) :
	mkdir $(BUILD_LUACLIB_DIR)

$(BUILD_LUACLIB_DIR)/log.so : lualib-src/lua-log.c | $(BUILD_LUACLIB_DIR)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@
	
$(BUILD_LUACLIB_DIR)/lfs.so: 3rd/luafilesystem/src/lfs.c | $(BUILD_LUACLIB_DIR) 
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

clean :
	-rm -rf build
	-rm -rf log