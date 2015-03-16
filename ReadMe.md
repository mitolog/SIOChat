# SIOChat

SIOChat is a multi-room chat sample app using SIOSocket.

## Spec
- join a room automatically with your socket id.
- forground only (might support background in the future).
- you can join multi-room at the same time.
- it's just a sample to examine rooms of socket.io.


## How to use

### Serverside

1. Prepare your nodejs environment ([nodebrew](https://github.com/hokaccha/nodebrew) is fast).
2. Just Install [socket.io](https://github.com/Automattic/socket.io) by `npm install socket.io` command where you want to run node.
3. Place **server.js** at the same dir as **node_module** folder. 
4. Just Run with `node server` (or if you want to debug, you can use `DEBUG*= node server`)

::attension:: 
Don't forget to open `3000` inbound port of your server.
For your reference, my environment is:
- Amazon Linux AMI release 2014.09
- node v0.12.0 
- socket.io v1.3.5

### Clientside

Just change **kWebSocketHostName** in `AppConsts.h` file to yours. Be ware HostName doesn't start with `http://` but start with `ws://`.

The project uses cocoapods. so you have to run `pod install`.

### License
MIT

