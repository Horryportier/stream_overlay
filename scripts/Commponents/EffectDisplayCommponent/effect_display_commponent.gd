class_name EffectDisplayCommponent
extends TextureRect

@onready var menager: EffectMenager = get_parent()

@onready var null_icon: Texture2D = preload("uid://b358p2b0p0gur")

func _ready() -> void:
	menager.effect_added.connect(_on_effect_added)
	menager.effect_removed.connect(_on_effect_removed)

func _on_effect_added(effect: Effect) -> void:
	texture = effect.icon if effect.icon != null else null_icon

func _on_effect_removed(_effect: Effect) -> void:
	texture = null
