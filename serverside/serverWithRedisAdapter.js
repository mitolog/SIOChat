var io = require('socket.io')(3000);
var redis = require('socket.io-redis');
var adapter = io.adapter(redis({ host: '127.0.0.1', port: 6379 }));

var sepStr = ',';
var roomIdx = 0;
var isParentIdx = 1;
var nicknameIdx = 3;
var joinedRooms = [];
var nicknames = [];

io.on('connection', function (socket) {
	
    console.log(socket['id'] + ' has connected!');
  
    // join the specific room everytime socket connected
    socket.on('init', function(data){
        
	var params = data.split(sepStr);
        var isParent = params[isParentIdx];
 	var room = params[roomIdx]
        var output = data;	

	if(isParent == '1'){
            room = socket['id'];
	    output = room;
            output += data;
	    nicknames[socket['id']] = params[nicknameIdx];
	}else{
            socket.join(room);
	}
      	
	joinedRooms[socket['id']] = socket.rooms;
 
	io.emit('rooms', io.sockets.adapter.rooms);
	io.to(room).emit('join', output);

        console.log('joined room ' + room);
    });

    // bradcast the specific room everytime someone posted some
    socket.on('post', function (data) {
        
        console.log(socket['id'] + ' ' + data);

        var room = data.split(sepStr)[roomIdx];
        io.to(room).emit('update', data);
    });
    
    // clients are disconnected automatically everytime they going background 
    socket.on('disconnect', function (data) {
       	
	io.emit('rooms', io.sockets.adapter.rooms);
	
	var message = nicknames[socket['id']];
	message += ' left room';
	message += sepStr;
	var prevJoinedRooms = joinedRooms[socket['id']];
 	for(var i=0; i<prevJoinedRooms.length; i++){
	    var room = prevJoinedRooms[i];
	    io.to(room).emit('disappear', message + room);
	    console.log(message + room);
	}
        console.log(socket['id'] + ' has disconnected!');
    });
    
});


