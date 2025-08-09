@tool
class_name RemoteSize
extends Node

@onready var agent: Control = get_parent()

@export var target_node: Control
@export var offset: Vector2

func _process(_delta: float) -> void:
	if is_instance_valid(target_node):
		target_node.size = agent.size + offset
		
	

