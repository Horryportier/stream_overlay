class_name VisibilityOnReadyCommponent
extends Node

@export var visible: bool = true

func _ready() -> void:
	var parent: Node = get_parent()
	if parent.get("visible") != null:
		parent.visible = visible
