extends Control

@onready var net_queue_lebel: Label = %NetQueueLabel


func _process(_delta: float) -> void:
	net_queue_lebel.text = "\n".join(Net.message_queue)
