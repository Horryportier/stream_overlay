class_name DamageDisplayCommponent
extends Node

var health_commponent: HealthCommponent
var agent: Node2D

func _ready() -> void:
	agent = get_parent()
	health_commponent = agent.get_node_or_null("HealthCommponent")
	if !is_instance_valid(health_commponent):
		push_warning("invalid health commponent")
		return
	health_commponent.hp_decresed.connect(_on_hp_decresed)

func _on_hp_decresed(amount: int, _source_type: AttackInfo.AttackType) -> void:
	var world_text: = WorldText.new(str(amount), agent.global_position)
	TextDisplayer.display_text(world_text)
