extends Control

const room = "95dd4680-ab51-4511-ad4f-22328d8a8aaf"

var socket
var jsonjs
var text_log

func _log(msg):
	text_log.text = text_log.text + msg + "\n"

func send_pressed():

	socket.emit("joinRoom", room)
	
	_log("Sending score")
	socket.emit('updateScore', JSON.print({ "name": 'Nosotros', "score": 5 }));

func _socket_connected():
	_log("connected!")
	socket.emit("joinRoom", room)


func _any_msg_received(event, msg, msg2):
	_log("network msg: " + event + JSON.print(msg))
	
func _msg_received(msg):
	_log("network msg: " + str(msg))
	for o in msg:
		_log(str(jsonjs.stringify(o)))

var socket_connected = JavaScript.create_callback(self, "_socket_connected")
var msg_received = JavaScript.create_callback(self, "_msg_received")
var any_msg_received = JavaScript.create_callback(self, "_any_msg_received")


# todo: make one callback per message, or figure out how to register one callback for all messages on socket.io (probably better)
var room_joined = msg_received
var score_delegated = msg_received
var score_updated = msg_received
var new_player_joined = msg_received


func _ready():
	
	jsonjs = JavaScript.get_interface("JSON")
	
	get_node("send").connect("pressed", self, "send_pressed")
	text_log = get_node("log")

	socket = JavaScript.create_object("io", "http://localhost:3004", { "transports": ["websocket"] })
	socket.onAny(any_msg_received)

	socket.on("connect", socket_connected)
	socket.on("joinedRoom", room_joined)
	socket.on("scoreDelegated", score_delegated)
	socket.on("scoreUpdated", score_updated)
	socket.on("newPlayerJoined", new_player_joined)
	
	socket.emit('delegateScore', {
            "id": 0,
            "name": 'prueba'
        })
	
	


