## Basic requirements
    [ubuntu 14.04 lts](http://www.ubuntu.com/download/desktop)

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
./3rd/skynet/skynet config/config
./build/bin/lua service/client.lua
```
