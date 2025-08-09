class_name LevelsIds
extends Node

@export var ids: Dictionary[String, LevelId]


func add_id(n: String, id: LevelId) -> void:
        LogDuck.d(ids.set(n, id))
