class_name LevelData
extends Node

signal level_beaten

signal level_started

@export var camera_snap_positions: Array[Vector2i]
@export var camera_snap_positions_expanded: Array[Vector2]
@export var doorways: Array[Doorway]
@export var spawners: Array[Spawner]
@export var player_pos: Vector2
@export var chests: Dictionary[Chest, Array]


@export var is_level_beaten: bool:
	set(val):
		is_level_beaten = val
		if is_level_beaten:
			level_beaten.emit()

var _entities: Array

func _ready() -> void:
	for doorway in doorways:
		level_beaten.connect(doorway._on_level_beaten)
	for spawner in spawners:
		_entities.append(spawner.spawn_random())
	await  get_tree().create_timer(2).timeout
	if !is_level_beaten:
		level_started.emit()
		for e: Node in _entities:
			if is_instance_valid(e) and e.has_method("activate"):
				e.activate()

func set_level_as_beaten() -> void:
	is_level_beaten = true


