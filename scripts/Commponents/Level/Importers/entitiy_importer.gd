@tool
class_name LdtkEntityImporter
extends Resource

enum EntityType {
	Node,
	Data,
	Both,
}


const ENTITY_TYPE_NODE: = EntityType.Node
const ENTITY_TYPE_DATA: = EntityType.Data
const ENTITY_TYPE_BOTH: = EntityType.Both

@export var enable: bool = true 
@export_group("entity")
@export var entity_id: String
@export var entity_type: EntityType

@export_group("scene")
@export var scene: PackedScene
## maps enity parmas to node params
@export var entity_params_map: Dictionary[String, String] 
@export_group("level_data")
@export var level_data_params: Dictionary[String, String]
@export var add_node: bool = true
@export var add_node_param_name: String


var enum_importers: Dictionary[String, Script]

func setup_entity(entity: Dictionary, ldtk_entitiy_layer: LDTKEntityLayer, level_data: LevelData, owner: Node) -> void:
	match entity_type:
		ENTITY_TYPE_NODE:
			_setup_entity_node(entity, ldtk_entitiy_layer, level_data, owner)
		ENTITY_TYPE_DATA:
			_setup_entity_data(null, entity, level_data)
		ENTITY_TYPE_BOTH:
			var node: = _setup_entity_node(entity, ldtk_entitiy_layer, level_data, owner)
			_setup_entity_data(node, entity, level_data)

func _setup_entity_node(entity: Dictionary, ldtk_entitiy_layer: LDTKEntityLayer, level_data: LevelData, owner: Node) -> Node: 
	var node: Node2D = scene.instantiate()
	if !is_instance_valid(node):
		push_warning("falied to instantiate scene")
		return
	ldtk_entitiy_layer.add_child(node)
	var entity_pos: Vector2 = entity.get("position") as Vector2
	node.global_position = entity_pos
	node.owner = owner
	for param in entity_params_map.keys():
		var value: String = entity_params_map[param]
		if node.get(value) == null:
			push_warning("node dose not have param: ", value)
			continue
		var field: Variant = ldtk_get_field(entity, param)
		if field == null:
			push_warning("entity dose not have filed: ", param)
			continue
		if _is_ldtk_field_enum(param, entity):
			var enum_value: Variant =  parse_enum_value(param, ldtk_get_field(entity, param))
			node.set(value, enum_value)
			continue
		node.set(value, field) 
	if node.has_method("_post_import"):
		print_rich("[color=red]has method")
		node._post_import()
	return node


func _setup_entity_data(node: Node, entity: Dictionary, level_data: LevelData) -> void:
	if add_node:
		set_param_by_type(level_data, add_node_param_name, node)

	for param in level_data_params.keys():
		var value: String = level_data_params[param]
		if level_data.get(value) == null:
			push_warning("node dose not have param: ", value)
			continue
		var field: Variant = ldtk_get_field(entity, param)
		if field == null:
			var entity_field: Variant = entity.get(param)
			set_param_by_type(level_data, value, entity_field)
			continue
		if _is_ldtk_field_enum(param, entity):
			var enum_value: Variant =  parse_enum_value(param, ldtk_get_field(entity, param))
			set_param_by_type(level_data, value, enum_value)
			continue
		level_data.set(value, field) 

func set_param_by_type(obj: Object, param: String, value: Variant) -> void:
	var param_type: = typeof(obj.get(param))
	match param_type:
		TYPE_ARRAY:
			var array: Array = obj.get(param)
			array.append(value)
			obj.set(param, value)
		TYPE_VECTOR2:
			match typeof(value):
				TYPE_VECTOR2:
					obj.set(param, value)
				TYPE_FLOAT:
					obj.set(param, Vector2(value, value))
		TYPE_VECTOR2I:
			match typeof(value):
				TYPE_VECTOR2I:
					obj.set(param, value)
				TYPE_INT:
					obj.set(param, Vector2(value, value))
		_:
			obj.set(param, value)



static func _is_ldtk_field_enum(field_id: String, entity: Dictionary) -> bool:
	var field_defs: Dictionary =  entity.get("definition").get("field_defs")
	var idx: int = field_defs.values().find_custom(func (x: Dictionary) -> bool: return x.get("identifier") == field_id)
	if idx == -1:
		return false
	var type : String = field_defs.values()[idx].get("type") 
	return type.find("LocalEnum") != -1

static func ldtk_get_field(e: Dictionary, field_id: String) -> Variant:
	return e.get("fields").get(field_id, null)

static func sanitize_ldtk_enum(i: String) -> String:
	var s = i.split(".")
	return s[s.size()-1]

func parse_enum_value(id: String, enum_value: String) -> Variant: 
	var importer_script: Script = enum_importers.get(id)
	if importer_script == null:
		push_warning("uknwonwn enum importer: ", id)
		return 0
	var importer: LdtkEnumImporter =  load(importer_script.get_path()).new()
	var val: = sanitize_ldtk_enum(enum_value)
	var res: Variant =  importer.from_string(val)
	return res
