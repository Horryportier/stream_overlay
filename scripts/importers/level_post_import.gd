@tool
extends Node



func post_import(level: LDTKLevel) -> LDTKLevel:
	var def_material: ShaderMaterial = preload("uid://d08u67c0rh73i")
	var children: = level.get_children()
	for child: Node2D in children:
		child.owner = level
		child.material = def_material
	return level
