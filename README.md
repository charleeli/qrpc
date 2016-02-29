## Basic requirements
    [ubuntu 14.04 lts](http://www.ubuntu.com/download/desktop)
    [redis desktop manager](http://redisdesktop.com/)

## Ubuntu setup
```
sudo apt-get install autoconf libreadline-dev git gitg
```

## Building from source
```
git clone https://github.com/charleeli/qrpc.git
cd qrpc
make
```

## Test
```
cd qrpc
./build/bin/redis-server config/redis.conf

./3rd/skynet/skynet config/config.lua
./build/bin/lua service/client.lua
```
