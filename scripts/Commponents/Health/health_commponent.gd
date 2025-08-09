@icon("res://assets/nodes_icons/health_commponent.svg")
class_name HealthCommponent
extends Node

signal hp_changed
signal hp_decresed(amount: int, source_type: AttackInfo.AttackType)
signal hp_incised(amount: int)
signal hp_zero
signal hp_max

@export var max_hp: int = 0
@export var start_hp: int = 0
@export var debug: bool = false

var old_hp: int = 0

var hp: int = 0:
	set (val):
		if debug:
			LogDuck.d(hp," -> ", val)
		old_hp = hp
		hp = clampi(val, 0 , max_hp)
		hp_changed.emit()
		if hp == 0:
			hp_zero.emit()
		if hp == max_hp:
			hp_max.emit()
		

func _ready() -> void:
	if start_hp > 0:
		hp  = start_hp
	else:
		hp  = max_hp

func get_hp() -> int:
	return hp


func take_dmg(amount: int, source_type: AttackInfo.AttackType) -> void:
	hp -= amount
	hp_decresed.emit(old_hp - hp, source_type)

func heal(amount: int) -> void:
	hp += amount
	hp_incised.emit(amount)

func reset() -> void:
	hp = max_hp
