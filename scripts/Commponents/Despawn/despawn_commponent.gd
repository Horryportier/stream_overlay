class_name DespawnCommponent
extends Node


@export var agent: Node2D
@export var visuals_node: Node2D

func _ready() -> void:
	_setup()

func _setup() -> void:
	var health_commponent: HealthCommponent= agent.get_node_or_null("HealthCommponent")
	if is_instance_valid(health_commponent):
		health_commponent.hp_zero.connect(_despawn)

func _despawn() -> void:
	agent.queue_free()

func _despawn_setup_fn(instance: Node) -> void:
	instance.visuals = visuals_node
