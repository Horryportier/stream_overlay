@icon("res://assets/nodes_icons/flip_commponet.svg")
class_name FlipCommponent
extends Node


enum TargetType {
	Sprite,
	Node2D
}

@export  var default: bool
@export var direction_detector: DirectionDetector

@export var target: Node2D

var target_type: TargetType

var _node_orginal_pos: Vector2

func _ready() -> void: 
	if target is Sprite2D or target is AnimatedSprite2D: 
		target_type = TargetType.Sprite
	else: 
		target_type = TargetType.Node2D
		_node_orginal_pos = target.position

func _process(_delta: float) -> void:
	match target_type:
		TargetType.Sprite:
			flip_sprite_type()
		TargetType.Node2D:
			flip_node()

func flip_node() -> void:
	match direction_detector.direction:
		Direction.W:
			target.position = _node_orginal_pos * Vector2(-1, 1)
		Direction.E:
			target.position = _node_orginal_pos

func flip_sprite_type() -> void:
	match direction_detector.direction:
		Direction.W:
			target.flip_h = !default
		Direction.E:
			target.flip_h = default
