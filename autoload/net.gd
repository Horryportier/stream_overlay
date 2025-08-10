extends Node

signal command_request(id: int, data: Dictionary)

enum {
	INVALID,
	SET_GREENS_SCREEN_VISIBILITY,
}

var tcp_server: TCPServer
var server_stream: StreamPeerTCP

var message_queue : Array[String]

func _ready() -> void:	
	tcp_server = TCPServer.new()
	tcp_server.listen(42069)

func _physics_process(_delta: float) -> void:
	if !tcp_server.is_listening(): 
		return
	if tcp_server.is_connection_available():
		_take_connection()
	while !message_queue.is_empty():
		var msg: String =  message_queue.pop_back()
		parse(msg)

func _take_connection() -> void:
	server_stream = tcp_server.take_connection()
	server_stream.poll()
	var avalible_bytes = server_stream.get_available_bytes()
	if avalible_bytes > 0:
		var data = server_stream.get_data(avalible_bytes)
		if data[0] ==  OK:
			var message = data[1]
			var res = decode(message)
			message_queue.append(res)

func decode(buff: PackedByteArray)  -> String:
	var packet = StreamPeerBuffer.new()
	packet.data_array = buff
	packet.seek(0)
	var size = packet.get_u32()
	var data = packet.get_data(size)
	if data[0] == 31:
		return (data[1] as PackedByteArray).get_string_from_ascii()
	return ""

func parse(message: String) -> void:
	var data: Variant = JSON.parse_string(message)
	if typeof(data) != TYPE_DICTIONARY:
		print("data is not dictionary")
		return
	var type: int
	match data.get("type", ""):
		"OK":
			type = OK
		"GREEN_SCREEN":
			type = SET_GREENS_SCREEN_VISIBILITY
		_:
			type = INVALID
	command_request.emit(type, data)
		
func _exit_tree() -> void:
	tcp_server.stop()
