@tool
class_name LdtkEntityImporters
extends Resource


@export var enum_importers: Dictionary[String, Script]

@export var importers: Dictionary[String, LdtkEntityImporter]

func setup_entity(id: String, entity: Dictionary, ldtk_entitiy_layer: LDTKEntityLayer, level_data: LevelData, owner: Node) -> void:
	var importer: LdtkEntityImporter = importers.get(id)
	if importer != null and importer.enable:
		importer.enum_importers = enum_importers
		importer.setup_entity(entity, ldtk_entitiy_layer, level_data, owner)
	else: 
		push_warning("importer not found: ", id)
