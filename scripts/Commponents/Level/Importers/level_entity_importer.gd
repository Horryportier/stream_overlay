@tool
extends Node


func post_import(entity_layer: LDTKEntityLayer) -> LDTKEntityLayer:
	var importers: LdtkEntityImporters = preload("uid://dpgfvd1ng8vcm")
	var entities: Array = entity_layer.entities
	var level_data: LevelData
	level_data =  entity_layer.get_node_or_null("../Data")
	if !is_instance_valid(level_data):
		level_data = LevelData.new()
	var level_owner: = entity_layer.owner
	level_data.name = "Data"
	for entity: Dictionary in entities:
		var entity_id: String = entity.get("identifier")
		importers.setup_entity(entity_id, entity, entity_layer, level_data, owner)

	level_data.owner = level_owner
	entity_layer.add_sibling(level_data)
	entity_layer.y_sort_enabled = true
	return entity_layer

