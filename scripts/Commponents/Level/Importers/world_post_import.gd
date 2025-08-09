@tool
extends Node

const LEVELS_PATH: String = "res://scenes/levels/levels/"

func post_import(world: LDTKWorld) -> LDTKWorld:
	var ids = LevelsIds.new()
	world.add_child(ids)
	ids.name = "LevelIds"
	ids.owner = world
	ids.ids.clear()
	for level in world.levels:
		var id = LevelId.new()
		id.packed_scene_path = LEVELS_PATH + level.name + ".scn"
		id.size = level.size
		id.doorways_directions = get_dorways_directions(level)
		ids.add_id(level.name, id)
	Dev.levels_reimported.emit()
	return world


func get_dorways_directions(level: LDTKLevel) -> Dictionary[int, Direction.T]:
	var data: LevelData = level.get_node_or_null("Data")
	if data == null:
		return {}
	var dirs: Dictionary[int, Direction.T]
	for door in data.doorways:
		dirs[door.id] = door.visual_direction
	return dirs
