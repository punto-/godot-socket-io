extends Control

const room = "95dd4680-ab51-4511-ad4f-22328d8a8aaf"

var socket
var text_log

func _log(msg):
	text_log.text = text_log.text + msg + "\n"

func send_pressed():
	
	_log("Sending score")
	socket.emit('updateScore', { "name": 'Nosotros', "score": 5 });

func _socket_connected():
	_log("connected!")
	socket.emit("joinRoom", room)


func msg_received(msg):
	_log("network msg: " + str(msg))
	

var socket_connected = JavaScript.create_callback(self, "_socket_connected")
var _msg_received = JavaScript.create_callback(self, "msg_received")

# todo: make one callback per message, or figure out how to register one callback for all messages on socket.io (probably better)
var room_joined = _msg_received
var score_delegated = _msg_received
var score_updated = _msg_received
var new_player_joined = _msg_received



func _ready():
	get_node("send").connect("pressed", self, "send_pressed")
	text_log = get_node("log")

	socket = JavaScript.create_object("io", "http://localhost:3004", { "transports": ["websocket"] })
	socket.on("connect", socket_connected)
	socket.on("joinedRoom", room_joined)
	socket.on("scoreDelegated", score_delegated)
	socket.on("scoreUpdated", score_updated)
	socket.on("newPlayerJoined", new_player_joined)
	
	socket.emit('delegateScore', {
            "id": 0,
            "name": 'prueba'
        })
	
	


